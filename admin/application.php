<?php
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/adoption.php';
require_once __DIR__ . '/../includes/sensitive-data.php';

requireCanViewAdoptionApplications();

$id = (int) ($_GET['id'] ?? 0);

$appRows = db_select('adoption_applications', 'id=eq.' . $id . '&limit=1');
$app = $appRows[0] ?? null;

if ($app) {
    $app = hydrateAdoptionApplication($app);
    $petRows = db_select('pets', 'id=eq.' . (int) $app['pet_id'] . '&select=name,breed,image,status&limit=1');
    $pet = $petRows[0] ?? [];
    $app['pet_name']   = $pet['name']   ?? 'Unknown Pet';
    $app['breed']      = $pet['breed']  ?? '';
    $app['pet_image']  = $pet['image']  ?? '';
    $app['pet_status'] = $pet['status'] ?? 'unknown';
}

if (!$app) {
    flash('error', 'Application not found.');
    header('Location: ' . url('admin/adoption-requests.php'));
    exit;
}

markNotificationsReadForApplication($id);

$pageTitle = 'Adoption Application';
$st        = formatApplicationStatus($app['status']);
$useSweetAlert = true;

// Determine if this is in "reschedule pending" state
$isReschedulePending = ($app['status'] === 'pending' && ($app['rejection_reason'] ?? '') === 'reschedule');

require_once __DIR__ . '/../includes/header.php';
?>

<div class="page-header">
    <a href="<?= url('admin/adoption-requests.php') ?>" class="btn btn-ghost btn-sm">← Back to requests</a>
    <h2 class="mt-2">Application #<?= (int) $app['id'] ?></h2>
    <p>Submitted <?= timeAgo($app['created_at']) ?> · Pet: <strong><?= sanitize($app['pet_name']) ?></strong></p>
</div>

<div class="adoption-application-layout">
    <div class="card">
        <div class="card-header">
            <span class="card-title">Applicant Information</span>
            <span class="status-badge <?= $st['class'] ?>"><span class="status-dot"></span><?= $st['label'] ?></span>
        </div>
        <dl class="detail-grid">
            <div><dt>Full Name</dt><dd><?= sanitize($app['full_name'] ?? '—') ?></dd></div>
            <div><dt>Email</dt><dd><?= sanitize($app['email'] ?? '—') ?></dd></div>
            <div><dt>Contact</dt><dd><?= sanitize($app['contact_number'] ?? '—') ?></dd></div>
            <div><dt>Occupation</dt><dd><?= $app['occupation'] ? sanitize($app['occupation']) : '<span class="text-secondary">—</span>' ?></dd></div>
            <?php if (!empty($app['address'])): ?>
            <div class="detail-full"><dt>Address</dt><dd><?= sanitize($app['address']) ?></dd></div>
            <?php endif; ?>
            <?php if (!empty($app['home_type'])): ?>
            <div><dt>Home Type</dt><dd><?= sanitize($app['home_type']) ?></dd></div>
            <?php endif; ?>
            <div><dt>Has Existing Pets</dt><dd><?= ucfirst(sanitize($app['existing_pets'] ?? '—')) ?></dd></div>
            <?php if (!empty($app['reason_for_adoption'])): ?>
            <div class="detail-full"><dt>Reason for Adoption</dt><dd><?= nl2br(sanitize($app['reason_for_adoption'])) ?></dd></div>
            <?php endif; ?>
            <div><dt>Requested Visit Date</dt><dd><?= !empty($app['schedule_date']) ? date('F j, Y', strtotime($app['schedule_date'])) : '<span class="text-secondary">—</span>' ?></dd></div>
            <div><dt>Requested Visit Time</dt><dd><?= !empty($app['schedule_time']) ? date('g:i A', strtotime($app['schedule_time'])) : '<span class="text-secondary">—</span>' ?></dd></div>
            <div><dt>Application Submitted</dt><dd><?= !empty($app['created_at']) ? date('F j, Y g:i A', strtotime($app['created_at'])) : '—' ?></dd></div>
        </dl>

        <?php if ($isReschedulePending): ?>
        <div class="card-body" style="border-top:1px solid var(--border);background:var(--surface-2);padding:16px 20px;border-radius:0 0 10px 10px;">
            <p style="margin:0 0 6px;font-weight:600;color:var(--accent);">⏳ Awaiting applicant response to reschedule</p>
            <p style="margin:0;font-size:.875rem;color:var(--text-secondary);">
                Proposed date: <strong><?= !empty($app['reschedule_date']) ? date('F j, Y', strtotime($app['reschedule_date'])) : '—' ?></strong>
                &nbsp;·&nbsp;
                Time window: <strong><?= !empty($app['reschedule_time_start']) ? date('g:i A', strtotime($app['reschedule_time_start'])) : '—' ?> – <?= !empty($app['reschedule_time_end']) ? date('g:i A', strtotime($app['reschedule_time_end'])) : '—' ?></strong>
            </p>
            <?php if (!empty($app['reschedule_response'])): ?>
            <p style="margin-top:8px;font-size:.875rem;">
                Applicant response:
                <strong style="color:<?= $app['reschedule_response'] === 'accepted' ? 'var(--status-rescued, green)' : 'var(--status-failed, #ef4444)' ?>">
                    <?= ucfirst($app['reschedule_response']) ?>
                </strong>
            </p>
            <?php endif; ?>
        </div>
        <?php endif; ?>
    </div>

    <div class="card">
        <div class="card-header"><span class="card-title">Pet Applied For</span></div>
        <div class="card-body text-center">
            <img src="<?= petImageUrl($app['pet_image']) ?>" alt="" class="application-pet-photo">
            <h3 class="application-pet-name"><?= sanitize($app['pet_name']) ?></h3>
            <p class="text-secondary text-sm"><?= sanitize($app['breed']) ?></p>
            <p class="mt-3">
                <span class="pet-status-badge <?= formatPetStatus($app['pet_status'])['class'] ?>">
                    <?= formatPetStatus($app['pet_status'])['label'] ?>
                </span>
            </p>
        </div>

        <?php if ($app['status'] === 'pending' && !canReviewAdoptionApplications()): ?>
        <div class="permission-notice">
            Pending applications can only be approved or rejected by an administrator.
        </div>
        <?php endif; ?>

        <?php if ($app['status'] === 'pending' && canReviewAdoptionApplications() && !$isReschedulePending): ?>
        <div class="card-body pt-0 flex flex-col gap-2">
            <form method="POST" action="<?= url('admin/application-action.php') ?>" class="app-action-form">
                <input type="hidden" name="application_id" value="<?= (int) $app['id'] ?>">
                <input type="hidden" name="action" value="approve">
                <button type="submit" class="btn btn-accent" style="width:100%">Approve Application</button>
            </form>
            <button type="button" class="btn btn-ghost" style="width:100%;color:var(--status-failed)" id="openRejectModal">
                Reject Application
            </button>
        </div>
        <?php endif; ?>

        <?php if ($isReschedulePending): ?>
        <div class="card-body pt-0">
            <p class="text-sm text-secondary" style="text-align:center;">Actions are locked while awaiting reschedule response.</p>
        </div>
        <?php endif; ?>

        <?php if (in_array($app['status'], ['approved','rejected']) && ($app['rejection_reason'] ?? '') !== 'reschedule'): ?>
        <div class="card-body pt-0">
            <p class="text-sm text-secondary" style="text-align:center;">This application has been <?= $app['status'] ?>.</p>
            <?php if (!empty($app['rejection_reason'])): ?>
            <p class="text-sm text-secondary" style="text-align:center;">Reason: <strong><?= $app['rejection_reason'] === 'requirements_not_met' ? 'Requirements not met' : ucfirst($app['rejection_reason']) ?></strong></p>
            <?php endif; ?>
        </div>
        <?php endif; ?>
    </div>
</div>

<!-- Reject Modal -->
<div id="rejectModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.5);z-index:1000;align-items:center;justify-content:center;">
    <div style="background:#fff;border-radius:12px;padding:32px;max-width:520px;width:90%;max-height:90vh;overflow-y:auto;position:relative;">
        <button type="button" id="closeRejectModal" style="position:absolute;top:12px;right:16px;background:none;border:none;font-size:1.4rem;cursor:pointer;color:#6b7280;">✕</button>
        <h3 style="margin:0 0 4px;font-size:1.1rem;">Reject Application</h3>
        <p style="margin:0 0 20px;color:#6b5f56;font-size:.9rem;">Select the reason for rejecting this adoption application.</p>

        <form method="POST" action="<?= url('admin/application-action.php') ?>" id="rejectForm">
            <input type="hidden" name="application_id" value="<?= (int) $app['id'] ?>">
            <input type="hidden" name="action" value="reject">

            <div style="display:flex;flex-direction:column;gap:12px;margin-bottom:20px;">
                <label style="display:flex;align-items:flex-start;gap:10px;cursor:pointer;padding:14px 16px;border:2px solid var(--border,#e5e7eb);border-radius:8px;transition:border-color .15s;" class="reason-option">
                    <input type="radio" name="rejection_reason" value="requirements_not_met" required style="margin-top:2px;accent-color:var(--accent);">
                    <span>
                        <strong style="display:block;margin-bottom:2px;">Requirements Not Met</strong>
                        <span style="font-size:.85rem;color:#6b5f56;">The applicant does not meet one or more adoption qualifications.</span>
                    </span>
                </label>
                <label style="display:flex;align-items:flex-start;gap:10px;cursor:pointer;padding:14px 16px;border:2px solid var(--border,#e5e7eb);border-radius:8px;transition:border-color .15s;" class="reason-option">
                    <input type="radio" name="rejection_reason" value="reschedule" required style="margin-top:2px;accent-color:var(--accent);">
                    <span>
                        <strong style="display:block;margin-bottom:2px;">Unavailable on Requested Date</strong>
                        <span style="font-size:.85rem;color:#6b5f56;">Admin/staff is unavailable on the applicant's selected date. Propose a new schedule below.</span>
                    </span>
                </label>
            </div>

            <!-- Reschedule fields (shown only when reschedule reason is selected) -->
            <div id="rescheduleFields" style="display:none;background:#faf8f6;border:1px solid #ede9e4;border-radius:8px;padding:16px;margin-bottom:20px;">
                <p style="margin:0 0 12px;font-size:.875rem;font-weight:600;color:var(--text-primary);">Propose a New Schedule</p>
                <div style="display:grid;grid-template-columns:1fr;gap:10px;">
                    <div>
                        <label style="display:block;font-size:.85rem;font-weight:500;margin-bottom:4px;">New Date <span style="color:#ef4444;">*</span></label>
                        <input type="date" name="reschedule_date" id="reschedule_date" class="form-control"
                               min="<?= date('Y-m-d') ?>" style="width:100%;">
                    </div>
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
                        <div>
                            <label style="display:block;font-size:.85rem;font-weight:500;margin-bottom:4px;">Available From <span style="color:#ef4444;">*</span></label>
                            <input type="time" name="reschedule_time_start" id="reschedule_time_start" class="form-control">
                        </div>
                        <div>
                            <label style="display:block;font-size:.85rem;font-weight:500;margin-bottom:4px;">Available Until <span style="color:#ef4444;">*</span></label>
                            <input type="time" name="reschedule_time_end" id="reschedule_time_end" class="form-control">
                        </div>
                    </div>
                </div>
                <p style="margin:10px 0 0;font-size:.8rem;color:#9c8f84;">The applicant will receive an email with these proposed times and can Accept or Reject the reschedule.</p>
            </div>

            <div style="display:flex;gap:10px;justify-content:flex-end;">
                <button type="button" id="closeRejectModal2" class="btn btn-ghost">Cancel</button>
                <button type="submit" class="btn" style="background:#ef4444;color:#fff;" id="rejectSubmitBtn">Send Rejection</button>
            </div>
        </form>
    </div>
</div>

<script>
// Approve form confirm
document.querySelectorAll('.app-action-form').forEach(function (form) {
    form.addEventListener('submit', function (e) {
        e.preventDefault();
        const action = form.querySelector('[name="action"]').value;
        const title  = 'Approve application?';
        const text   = 'The pet will be marked as adopted and no new applications will be accepted.';
        if (typeof Swal !== 'undefined') {
            Swal.fire({ title, text, icon: 'question', showCancelButton: true,
                confirmButtonColor: '#8B3A3A', confirmButtonText: 'Approve'
            }).then(function (r) { if (r.isConfirmed) form.submit(); });
        } else if (confirm(title)) {
            form.submit();
        }
    });
});

// Reject modal
const modal = document.getElementById('rejectModal');
document.getElementById('openRejectModal')?.addEventListener('click', () => {
    modal.style.display = 'flex';
});
['closeRejectModal','closeRejectModal2'].forEach(id => {
    document.getElementById(id)?.addEventListener('click', () => {
        modal.style.display = 'none';
    });
});
modal?.addEventListener('click', e => { if (e.target === modal) modal.style.display = 'none'; });

// Show/hide reschedule fields
const radios = document.querySelectorAll('input[name="rejection_reason"]');
const rescheduleFields = document.getElementById('rescheduleFields');
const rejectBtn = document.getElementById('rejectSubmitBtn');

radios.forEach(r => {
    r.addEventListener('change', () => {
        const isReschedule = document.querySelector('input[name="rejection_reason"]:checked')?.value === 'reschedule';
        rescheduleFields.style.display = isReschedule ? 'block' : 'none';
        rejectBtn.textContent = isReschedule ? 'Send Reschedule' : 'Send Rejection';

        // Toggle required on reschedule fields
        ['reschedule_date','reschedule_time_start','reschedule_time_end'].forEach(id => {
            document.getElementById(id).required = isReschedule;
        });
    });
});

// Highlight selected reason
document.querySelectorAll('.reason-option').forEach(label => {
    label.querySelector('input').addEventListener('change', () => {
        document.querySelectorAll('.reason-option').forEach(l => l.style.borderColor = 'var(--border,#e5e7eb)');
        label.style.borderColor = 'var(--accent,#7c6f5b)';
    });
});

// Reject form validation
document.getElementById('rejectForm')?.addEventListener('submit', function(e) {
    const reason = document.querySelector('input[name="rejection_reason"]:checked')?.value;
    if (!reason) { e.preventDefault(); alert('Please select a rejection reason.'); return; }
    if (reason === 'reschedule') {
        const d  = document.getElementById('reschedule_date').value;
        const ts = document.getElementById('reschedule_time_start').value;
        const te = document.getElementById('reschedule_time_end').value;
        if (!d || !ts || !te) { e.preventDefault(); alert('Please fill in all reschedule date and time fields.'); return; }
        if (ts >= te) { e.preventDefault(); alert('"Available Until" must be later than "Available From".'); return; }
    }
    const label = reason === 'reschedule' ? 'send reschedule proposal' : 'reject this application';
    if (typeof Swal !== 'undefined') {
        e.preventDefault();
        Swal.fire({
            title: 'Confirm',
            text: 'Are you sure you want to ' + label + '?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            confirmButtonText: 'Yes, proceed'
        }).then(r => { if (r.isConfirmed) document.getElementById('rejectForm').submit(); });
    }
});
</script>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
