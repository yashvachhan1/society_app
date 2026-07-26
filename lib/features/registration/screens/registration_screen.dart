import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:society_app/core/constants/app_constants.dart';
import 'package:society_app/core/data/demo_data.dart';
import 'package:society_app/core/models/models.dart';
import 'package:society_app/core/theme/app_theme.dart';
import 'package:society_app/core/widgets/widgets.dart';

/// Resident self-registration (requirement R4.1.5): the resident picks their
/// society and unit, submits proof, and waits for admin approval.
///
/// Five steps, each collecting the columns of one table:
///
/// | Step | Table | Fields |
/// |---|---|---|
/// | 1 Verify | `users` | `phone` (+ OTP) |
/// | 2 About you | `users` | `name`, `email`, `language` |
/// | 3 Society | `societies` | pick the society |
/// | 4 Your flat | `units`, `unit_occupancies` | tower, unit, owner/tenant |
/// | 5 Proof | `files` | ownership/agreement document |
///
/// Submitting creates a `memberships` row with `status = 'pending'`.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static const _steps = ['Verify', 'About you', 'Society', 'Your flat', 'Proof'];

  int _step = 0;

  // users.phone
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  bool _otpSent = false;

  // users.name / users.email / users.language
  final _name = TextEditingController();
  final _email = TextEditingController();
  AppLanguage _language = AppLanguage.en;

  // memberships.society_id
  int? _societyId;

  // units.tower_id / units.id, unit_occupancies.occupancy_type
  int? _towerId;
  int? _unitId;
  OccupancyType _occupancy = OccupancyType.owner;

  // files — the proof document
  String? _proofName;

  bool get _isLast => _step == _steps.length - 1;

  @override
  void initState() {
    super.initState();
    // The Continue button enables as soon as the required fields are filled.
    for (final c in [_phone, _otp, _name]) {
      c.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    for (final c in [_phone, _otp, _name]) {
      c.removeListener(_onFieldChanged);
    }
    _phone.dispose();
    _otp.dispose();
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  bool get _canContinue {
    switch (_step) {
      case 0:
        return _otpSent && _otp.text.trim().length >= 4;
      case 1:
        return _name.text.trim().isNotEmpty;
      case 2:
        return _societyId != null;
      case 3:
        return _unitId != null;
      default:
        return _proofName != null;
    }
  }

  void _next() {
    if (_isLast) {
      context.go(AppRoutes.pendingApproval);
      return;
    }
    setState(() => _step++);
  }

  void _back() {
    if (_step == 0) {
      context.go(AppRoutes.login);
      return;
    }
    setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _StepBar(steps: _steps, current: _step),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: _buildStep(),
              ),
            ),
            _Footer(
              isLast: _isLast,
              enabled: _canContinue,
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _verifyStep();
      case 1:
        return _aboutStep();
      case 2:
        return _societyStep();
      case 3:
        return _flatStep();
      default:
        return _proofStep();
    }
  }

  // ── Step 1 — users.phone ───────────────────────────────────────────────
  Widget _verifyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepIntro(
          title: 'Verify your phone',
          subtitle:
              'Your phone number is your login. We will send a one-time password to confirm it.',
        ),
        LabelledField(
          label: 'Mobile number',
          required: true,
          controller: _phone,
          hint: '98765 43210',
          keyboardType: TextInputType.phone,
          maxLength: 10,
          prefix: const Padding(
            padding: EdgeInsets.fromLTRB(14, 13, 8, 13),
            child: Text(
              '+91',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          helper: 'This becomes your account ID — it cannot be changed later.',
        ),
        const SizedBox(height: 14),
        if (!_otpSent)
          OutlinedButton.icon(
            onPressed: _phone.text.trim().length == 10
                ? () => setState(() => _otpSent = true)
                : null,
            icon: const Icon(Icons.sms_outlined, size: 18),
            label: const Text('Send OTP'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: const BorderSide(color: AppColors.divider),
              foregroundColor: AppColors.primary,
            ),
          )
        else ...[
          LabelledField(
            label: 'Enter OTP',
            required: true,
            controller: _otp,
            hint: '6-digit code',
            keyboardType: TextInputType.number,
            maxLength: 6,
            helper: 'Sent to +91 ${_phone.text}. Valid for 5 minutes.',
          ),
          const SizedBox(height: 12),
          const InfoBanner(
            message: 'Demo build — type any 4 to 6 digits to continue.',
          ),
        ],
      ],
    );
  }

  // ── Step 2 — users.name / email / language ─────────────────────────────
  Widget _aboutStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepIntro(
          title: 'About you',
          subtitle: 'This is how your name appears to the committee and neighbours.',
        ),
        LabelledField(
          label: 'Full name',
          required: true,
          controller: _name,
          hint: 'e.g. Rahul Sharma',
          helper: 'Use the name as printed on your agreement.',
        ),
        const SizedBox(height: 18),
        LabelledField(
          label: 'Email',
          controller: _email,
          hint: 'name@email.com',
          keyboardType: TextInputType.emailAddress,
          helper: 'Optional — used for receipts and bill copies.',
        ),
        const SizedBox(height: 18),
        const FieldLabel('Preferred language'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final language in AppLanguage.values)
              ChoiceChipTile(
                label: language.nativeLabel,
                selected: language == _language,
                onTap: () => setState(() => _language = language),
              ),
          ],
        ),
      ],
    );
  }

  // ── Step 3 — societies ─────────────────────────────────────────────────
  Widget _societyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepIntro(
          title: 'Find your society',
          subtitle: 'Pick the society you live in. Ask the committee if you are unsure.',
        ),
        for (final society in DemoData.societies)
          SelectableTile(
            title: society.name,
            subtitle: '${society.shortLocation}  ·  Reg. ${society.registrationNo}',
            selected: society.id == _societyId,
            onTap: () => setState(() => _societyId = society.id),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.apartment_rounded,
                size: 21,
                color: AppColors.primary,
              ),
            ),
          ),
        const SizedBox(height: 6),
        const InfoBanner(
          message: 'Society not listed? Ask your secretary to register it first.',
          icon: Icons.help_outline_rounded,
          color: AppColors.warning,
        ),
      ],
    );
  }

  // ── Step 4 — towers / units / unit_occupancies ─────────────────────────
  Widget _flatStep() {
    final units = _towerId == null
        ? DemoData.units
        : DemoData.units.where((u) => u.towerId == _towerId).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepIntro(
          title: 'Your flat',
          subtitle: 'Select your wing and flat number, then tell us how you occupy it.',
        ),
        const FieldLabel('Wing / Tower', required: true),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tower in DemoData.towers)
              ChoiceChipTile(
                label: tower.name,
                selected: tower.id == _towerId,
                onTap: () => setState(() {
                  _towerId = tower.id;
                  _unitId = null;
                }),
              ),
          ],
        ),
        const SizedBox(height: 20),
        const FieldLabel('Flat number', required: true),
        for (final unit in units)
          SelectableTile(
            title: 'Flat ${unit.unitNo}',
            subtitle:
                'Floor ${unit.floor}  ·  ${unit.unitType}  ·  ${unit.areaSqft.toStringAsFixed(0)} sq.ft  ·  ${unit.parkingSlots} parking',
            selected: unit.id == _unitId,
            onTap: () => setState(() {
              _unitId = unit.id;
              _towerId = unit.towerId;
            }),
          ),
        const SizedBox(height: 12),
        const FieldLabel('You are the', required: true),
        for (final type in OccupancyType.values)
          SelectableTile(
            title: type.label,
            subtitle: type.description,
            selected: type == _occupancy,
            onTap: () => setState(() => _occupancy = type),
          ),
      ],
    );
  }

  // ── Step 5 — files (proof) ─────────────────────────────────────────────
  Widget _proofStep() {
    final isOwner = _occupancy == OccupancyType.owner;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepIntro(
          title: 'Upload proof',
          subtitle: isOwner
              ? 'Attach your sale agreement, share certificate or index II.'
              : 'Attach your rent agreement (and police verification if you have it).',
        ),
        _UploadBox(
          fileName: _proofName,
          onPick: () => setState(
            () => _proofName = isOwner ? 'sale-agreement.pdf' : 'rent-agreement.pdf',
          ),
          onClear: () => setState(() => _proofName = null),
        ),
        const SizedBox(height: 18),
        const InfoBanner(
          message:
              'Your document is visible only to you and the society admin. It is never shown to other residents.',
          icon: Icons.lock_outline_rounded,
        ),
        const SizedBox(height: 18),
        _ReviewSummary(
          societyId: _societyId,
          unitId: _unitId,
          occupancy: _occupancy,
          name: _name.text.trim(),
          phone: _phone.text.trim(),
        ),
      ],
    );
  }
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.steps, required this.current});

  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Step ${current + 1} of ${steps.length}',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '   ·   ${steps[current]}',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                if (i > 0) const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: i <= current ? AppColors.primary : AppColors.divider,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StepIntro extends StatelessWidget {
  const _StepIntro({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.fileName,
    required this.onPick,
    required this.onClear,
  });

  final String? fileName;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (fileName != null) {
      return AppCard(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.description_rounded,
                color: AppColors.success,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Ready to submit',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onClear,
              icon: const Icon(
                Icons.close_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Tap to upload',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'PDF or image, up to 5 MB',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewSummary extends StatelessWidget {
  const _ReviewSummary({
    required this.societyId,
    required this.unitId,
    required this.occupancy,
    required this.name,
    required this.phone,
  });

  final int? societyId;
  final int? unitId;
  final OccupancyType occupancy;
  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    const dash = '—';
    final society = societyId == null
        ? null
        : DemoData.societies.firstWhere((s) => s.id == societyId);
    final unit = unitId == null
        ? null
        : DemoData.units.firstWhere((u) => u.id == unitId);
    final tower = unit == null
        ? null
        : DemoData.towers.firstWhere((t) => t.id == unit.towerId);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your request',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          _SummaryLine(label: 'Name', value: name.isEmpty ? dash : name),
          _SummaryLine(
            label: 'Phone',
            value: phone.isEmpty ? dash : '+91 $phone',
          ),
          _SummaryLine(label: 'Society', value: society?.name ?? dash),
          _SummaryLine(
            label: 'Flat',
            value: unit == null || tower == null
                ? dash
                : '${tower.name}, Flat ${unit.unitNo}',
          ),
          _SummaryLine(label: 'You are', value: occupancy.label),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 74,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.isLast,
    required this.enabled,
    required this.onNext,
  });

  final bool isLast;
  final bool enabled;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: ElevatedButton(
        onPressed: enabled ? onNext : null,
        child: Text(isLast ? 'Submit for approval' : 'Continue'),
      ),
    );
  }
}
