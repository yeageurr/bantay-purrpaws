<?php
/**
 * BantayPurrPaws — Application Action
 * Handles approve, reject (with reason), and reschedule flows.
 */

require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/adoption.php';
require_once __DIR__ . '/../includes/submission-notifications.php';

requireCanReviewAdoptionApplications();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ' . url('admin/adoption-requests.php'));
    exit;
}

$applicationId = (int) ($_POST['application_id'] ?? 0);
$action        = $_POST['action'] ?? '';

$app = db_select('adoption_applications', 'id=eq.' . $applicationId . '&limit=1', true);

if (!$app) {
    flash('error', 'Application not found.');
    header('Location: ' . url('admin/adoption-requests.php'));
    exit;
}

// Allow processing if pending, OR if it's a reschedule-pending state (status=pending + rejection_reason=reschedule)
$isReschedulePending = ($app['status'] === 'pending' && ($app['rejection_reason'] ?? '') === 'reschedule');

if ($app['status'] !== 'pending') {
    flash('error', 'This application has already been processed.');
    header('Location: ' . url('admin/application.php?id=' . $applicationId));
    exit;
}

// ── APPROVE ──────────────────────────────────────────────────────────────────
if ($action === 'approve') {
    if (!petCanReceiveApplications((int) $app['pet_id'])) {
        flash('error', 'This pet is no longer available for adoption.');
        header('Location: ' . url('admin/application.php?id=' . $applicationId));
        exit;
    }

    try {
        approveAdoption($applicationId, (int) $app['pet_id']);
    } catch (Throwable $e) {
        error_log('approve adoption: ' . $e->getMessage());
        flash('error', 'Could not approve application. Please try again.');
        header('Location: ' . url('admin/application.php?id=' . $applicationId));
        exit;
    }

    try { markNotificationsReadForApplication($applicationId); } catch (Throwable $e) { error_log($e->getMessage()); }

    $petRow  = getPetById((int) $app['pet_id']);
    $petName = $petRow['name'] ?? 'your pet';

    $app = hydrateAdoptionApplication($app);
    try {
        $mailed = notifyPetSubmissionApproved($app, $petName);
    } catch (Throwable $e) {
        error_log('approval email: ' . $e->getMessage());
        $mailed = false;
    }

    flash('success', 'Application approved. Pet marked as adopted.'
        . ($mailed ? ' Approval email sent.' : ' (Email could not be sent.)'));

// ── REJECT ────────────────────────────────────────────────────────────────────
} elseif ($action === 'reject') {

    $rejectionReason = $_POST['rejection_reason'] ?? '';

    if (!in_array($rejectionReason, ['requirements_not_met', 'reschedule'], true)) {
        flash('error', 'Please select a valid rejection reason.');
        header('Location: ' . url('admin/application.php?id=' . $applicationId));
        exit;
    }

    $app = hydrateAdoptionApplication($app);
    $petRow  = getPetById((int) $app['pet_id']);
    $petName = $petRow['name'] ?? 'the pet';

    // Get the current admin/staff info for reply-to notifications
    $reviewer = currentUser();
    $reviewerUserId = (int) ($reviewer['id'] ?? 0);

    if ($rejectionReason === 'reschedule') {
        // ── RESCHEDULE PROPOSAL ───────────────────────────────────────────────
        $rescheduleDate      = trim($_POST['reschedule_date'] ?? '');
        $rescheduleTimeStart = trim($_POST['reschedule_time_start'] ?? '');
        $rescheduleTimeEnd   = trim($_POST['reschedule_time_end'] ?? '');

        if (!$rescheduleDate || !$rescheduleTimeStart || !$rescheduleTimeEnd) {
            flash('error', 'Please provide the proposed reschedule date and time window.');
            header('Location: ' . url('admin/application.php?id=' . $applicationId));
            exit;
        }
        if ($rescheduleTimeStart >= $rescheduleTimeEnd) {
            flash('error', '"Available Until" must be later than "Available From".');
            header('Location: ' . url('admin/application.php?id=' . $applicationId));
            exit;
        }

        // Generate a unique secure token for email response links
        $token = bin2hex(random_bytes(32));

        db_update('adoption_applications', [
            'rejection_reason'    => 'reschedule',
            'reschedule_date'     => $rescheduleDate,
            'reschedule_time_start' => $rescheduleTimeStart,
            'reschedule_time_end'   => $rescheduleTimeEnd,
            'reschedule_token'    => $token,
            'reschedule_response' => null,
            'rejected_by_user_id' => $reviewerUserId ?: null,
        ], 'id=eq.' . $applicationId);

        // Status stays 'pending' (read-only for user until they respond)

        try {
            $mailed = notifyRescheduleProposal($app, $petName, $rescheduleDate, $rescheduleTimeStart, $rescheduleTimeEnd, $token);
        } catch (Throwable $e) {
            error_log('reschedule email: ' . $e->getMessage());
            $mailed = false;
        }

        // Notify admins/staff in the system
        createSystemNotification(
            'adoption',
            'Reschedule proposed for ' . ($app['full_name'] ?? 'applicant') . ' – awaiting their response.',
            'admin/application.php?id=' . $applicationId,
            $applicationId
        );

        flash('success', 'Reschedule proposal sent to applicant.'
            . ($mailed ? ' Email sent.' : ' (Email could not be sent.)'));

    } else {
        // ── REQUIREMENTS NOT MET REJECTION ───────────────────────────────────
        db_update('adoption_applications', [
            'status'              => 'rejected',
            'rejection_reason'    => 'requirements_not_met',
            'rejected_by_user_id' => $reviewerUserId ?: null,
        ], 'id=eq.' . $applicationId);

        markNotificationsReadForApplication($applicationId);

        try {
            $mailed = notifyPetSubmissionRejectedRequirements($app, $petName);
        } catch (Throwable $e) {
            error_log('rejection email: ' . $e->getMessage());
            $mailed = false;
        }

        flash('success', 'Application rejected.'
            . ($mailed ? ' Rejection email sent.' : ' (Email could not be sent.)'));
    }

} else {
    flash('error', 'Invalid action.');
}

header('Location: ' . url('admin/application.php?id=' . $applicationId));
exit;
