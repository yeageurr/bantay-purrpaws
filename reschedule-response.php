<?php
/**
 * BantayPurrPaws — Reschedule Response
 * Handles Accept / Reject reschedule links from email.
 * No login required — token is the auth mechanism.
 */
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/adoption.php';
require_once __DIR__ . '/includes/submission-notifications.php';
require_once __DIR__ . '/includes/sensitive-data.php';
require_once __DIR__ . '/includes/notifications.php';

$token    = trim($_GET['token'] ?? '');
$response = trim($_GET['response'] ?? ''); // 'accept' or 'reject'

$pageTitle     = 'Reschedule Response';
$useSweetAlert = false;

$error   = '';
$success = '';

if (!$token || !in_array($response, ['accept', 'reject'], true)) {
    $error = 'Invalid or missing response link.';
} else {
    // Find application by token
    $app = db_select('adoption_applications', 'reschedule_token=eq.' . $token . '&limit=1', true);

    if (!$app) {
        $error = 'This link is invalid or has already been used.';
    } elseif ($app['status'] !== 'pending' || ($app['rejection_reason'] ?? '') !== 'reschedule') {
        $error = 'This reschedule request is no longer active.';
    } elseif (!empty($app['reschedule_response'])) {
        $error = 'You have already responded to this reschedule request.';
    } else {
        $app = hydrateAdoptionApplication($app);
        $newStatus         = ($response === 'accept') ? 'approved' : 'rejected';
        $rescheduleResponse = ($response === 'accept') ? 'accepted' : 'rejected';

        // Update application
        $updateData = [
            'status'              => $newStatus,
            'reschedule_response' => $rescheduleResponse,
            'reschedule_token'    => null, // invalidate token after use
        ];
        if ($response === 'accept') {
            // Also update the schedule to the proposed date/time
            $updateData['schedule_date'] = $app['reschedule_date'];
            $updateData['schedule_time'] = $app['reschedule_time_start'];
        }

        db_update('adoption_applications', $updateData, 'id=eq.' . (int) $app['id']);

        $petRow  = getPetById((int) $app['pet_id']);
        $petName = $petRow['name'] ?? 'the pet';
        $applicantName = $app['full_name'] ?? 'Applicant';

        // Notify the admin/staff who proposed the reschedule
        $reviewerUserId = (int) ($app['rejected_by_user_id'] ?? 0);
        $notifMsg = $applicantName . ' has ' . $rescheduleResponse . ' the reschedule for adoption of ' . $petName . '.';

        // Create notification visible to all admins/staff
        createSystemNotification(
            'adoption',
            $notifMsg,
            'admin/application.php?id=' . (int) $app['id'],
            (int) $app['id']
        );

        // Also send email to the admin/staff who proposed the reschedule
        if ($reviewerUserId > 0) {
            try {
                $reviewer = db_select('users', 'id=eq.' . $reviewerUserId . '&limit=1', true);
                if ($reviewer) {
                    $reviewer = hydrateUserSensitiveFields($reviewer);
                    $reviewerEmail = $reviewer['email'] ?? '';
                    $reviewerName  = $reviewer['full_name'] ?? 'Administrator';
                    if ($reviewerEmail && filter_var($reviewerEmail, FILTER_VALIDATE_EMAIL)) {
                        notifyAdminOfRescheduleResponse(
                            $reviewerEmail,
                            $reviewerName,
                            $applicantName,
                            $petName,
                            $rescheduleResponse,
                            (int) $app['id']
                        );
                    }
                }
            } catch (Throwable $e) {
                error_log('reschedule admin notify: ' . $e->getMessage());
            }
        }

        if ($response === 'accept') {
            // Approved — mark pet as adopted
            try {
                approveAdoption((int) $app['id'], (int) $app['pet_id']);
            } catch (Throwable $e) {
                error_log('reschedule approve adoption: ' . $e->getMessage());
            }
            $success = 'You have <strong>accepted</strong> the reschedule. Your adoption appointment is confirmed for <strong>'
                . date('F j, Y', strtotime($app['reschedule_date']))
                . '</strong> between <strong>'
                . date('g:i A', strtotime($app['reschedule_time_start']))
                . ' – '
                . date('g:i A', strtotime($app['reschedule_time_end']))
                . '</strong>. Our team will be in touch!';
        } else {
            $success = 'You have <strong>declined</strong> the reschedule. Your adoption application for <strong>'
                . htmlspecialchars($petName, ENT_QUOTES, 'UTF-8')
                . '</strong> has been closed. Thank you for your interest in BantayPurrPaws.';
        }
    }
}

require_once __DIR__ . '/includes/header.php';
?>

<div style="max-width:540px;margin:60px auto;padding:0 20px;">
    <div class="card" style="text-align:center;padding:40px 32px;">
        <?php if ($error): ?>
            <div style="font-size:3rem;margin-bottom:16px;">⚠️</div>
            <h2 style="margin:0 0 12px;">Link Invalid</h2>
            <p style="color:var(--text-secondary);"><?= htmlspecialchars($error, ENT_QUOTES, 'UTF-8') ?></p>
            <a href="<?= url('dashboard.php') ?>" class="btn btn-accent" style="margin-top:24px;">Go to Dashboard</a>
        <?php elseif ($success): ?>
            <div style="font-size:3rem;margin-bottom:16px;"><?= ($response === 'accept') ? '✅' : '🙏' ?></div>
            <h2 style="margin:0 0 12px;">Response Recorded</h2>
            <p style="color:var(--text-secondary);line-height:1.6;"><?= $success ?></p>
            <a href="<?= url('my-applications.php') ?>" class="btn btn-accent" style="margin-top:24px;">View My Applications</a>
        <?php endif; ?>
    </div>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
