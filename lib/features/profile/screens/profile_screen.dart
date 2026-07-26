import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:society_app/core/constants/app_constants.dart';
import 'package:society_app/core/data/demo_data.dart';
import 'package:society_app/core/models/models.dart';
import 'package:society_app/core/theme/app_theme.dart';
import 'package:society_app/core/utils/formatters.dart';
import 'package:society_app/core/utils/photo_picker.dart';
import 'package:society_app/core/widgets/widgets.dart';

/// The resident's account.
///
/// Every field maps to a column: the `users` row (name, phone, email, language,
/// status, last login) and their `memberships` row (society, flat, role,
/// status, start date).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AppLanguage _language = DemoData.signedInUser.language;

  /// The photo chosen from the camera or gallery, held until there is a backend
  /// to upload it to (`users.photo_url`).
  Uint8List? _photoBytes;

  Future<void> _changeLanguage() async {
    final picked = await showModalBottomSheet<AppLanguage>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _LanguageSheet(selected: _language),
    );
    if (picked == null || !mounted) return;
    setState(() => _language = picked);
  }

  @override
  Widget build(BuildContext context) {
    final user = DemoData.signedInUser;
    final membership = DemoData.currentMembership;
    final society = DemoData.currentSociety;
    final unit = DemoData.currentUnit;
    final tower = DemoData.currentTower;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit profile',
            onPressed: () => _showEditSheet(context, user),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProfileHeader(
              user: user,
              membership: membership,
              unit: unit,
              tower: tower,
              photoBytes: _photoBytes,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _AccountCard(
                user: user,
                language: _language,
                onEditLanguage: _changeLanguage,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MembershipCard(
                membership: membership,
                society: society,
                unit: unit,
                tower: tower,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _LogoutButton(onTap: () => context.go(AppRoutes.login)),
            ),
            const SizedBox(height: 14),
            const Text(
              '${AppConstants.appName}  v${AppConstants.appVersion}',
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, AppUser user) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _EditProfileSheet(
        user: user,
        photoBytes: _photoBytes,
        onPhotoChanged: (bytes) => setState(() => _photoBytes = bytes),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    required this.membership,
    required this.unit,
    required this.tower,
    required this.photoBytes,
  });

  final AppUser user;
  final Membership membership;
  final Unit unit;
  final Tower tower;
  final Uint8List? photoBytes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.primary),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        children: [
          Stack(
            children: [
              // users.photo_url — falls back to initials when not set.
              // Changed from the Edit profile sheet, not from here.
              PhotoAvatar(
                initials: user.initials,
                photoUrl: user.photoUrl,
                photoBytes: photoBytes,
                onLight: true,
              ),
              if (membership.isActive)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            user.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _HeaderChip(
            icon: Icons.home_outlined,
            label: 'Flat ${unit.unitNo}, ${tower.name}',
          ),
          const SizedBox(height: 8),
          _HeaderChip(
            icon: Icons.person_outline,
            label: membership.role.label,
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// The `users` row: name, phone, email, language, status, last login.
class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.user,
    required this.language,
    required this.onEditLanguage,
  });

  final AppUser user;
  final AppLanguage language;
  final VoidCallback onEditLanguage;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Account Details',
      rows: [
        IconDetailRow(
          icon: Icons.person_outline,
          label: 'Full name',
          value: user.name,
          color: AppColors.primary,
        ),
        IconDetailRow(
          icon: Icons.phone_outlined,
          label: 'Mobile (login ID)',
          value: user.phone,
          color: AppColors.success,
        ),
        IconDetailRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: user.hasEmail ? user.email! : 'Not added',
          color: AppColors.accent,
          isPlaceholder: !user.hasEmail,
        ),
        IconDetailRow(
          icon: Icons.translate_outlined,
          label: 'Language',
          value: '${language.nativeLabel} (${language.label})',
          color: AppColors.warning,
          onTap: onEditLanguage,
        ),
        IconDetailRow(
          icon: Icons.shield_outlined,
          label: 'Account status',
          value: user.status == UserStatus.active ? 'Active' : 'Blocked',
          color: user.status == UserStatus.active
              ? AppColors.success
              : AppColors.error,
        ),
        IconDetailRow(
          icon: Icons.schedule_outlined,
          label: 'Last login',
          value: formatDateTime(user.lastLoginAt),
          color: AppColors.primary,
        ),
      ],
    );
  }
}

/// The `memberships` row plus the society and unit it points at.
class _MembershipCard extends StatelessWidget {
  const _MembershipCard({
    required this.membership,
    required this.society,
    required this.unit,
    required this.tower,
  });

  final Membership membership;
  final Society society;
  final Unit unit;
  final Tower tower;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: 'Membership',
      rows: [
        IconDetailRow(
          icon: Icons.location_city_outlined,
          label: 'Society',
          value: society.name,
          color: AppColors.primary,
        ),
        IconDetailRow(
          icon: Icons.home_work_outlined,
          label: 'Flat',
          value: '${unit.unitNo}, ${tower.name}  ·  ${unit.unitType}',
          color: AppColors.accent,
        ),
        IconDetailRow(
          icon: Icons.verified_user_outlined,
          label: 'Role',
          value: membership.role.label,
          color: AppColors.success,
        ),
        IconDetailRow(
          icon: Icons.task_alt_outlined,
          label: 'Status',
          value: membership.status.label,
          color: membership.isActive ? AppColors.success : AppColors.warning,
        ),
        IconDetailRow(
          icon: Icons.event_outlined,
          label: 'Member since',
          value: formatDate(membership.startDate),
          color: AppColors.warning,
        ),
        // memberships.end_date — only set when the admin records a move-out
        if (membership.endDate != null)
          IconDetailRow(
            icon: Icons.event_busy_outlined,
            label: 'Valid till',
            value: formatDate(membership.endDate),
            color: AppColors.error,
          ),
      ],
    );
  }
}

/// Language picker opened by tapping the Language row in Account Details.
class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet({required this.selected});

  final AppLanguage selected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App language',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            for (final language in AppLanguage.values)
              SelectableTile(
                title: language.nativeLabel,
                subtitle: language.label,
                selected: language == selected,
                onTap: () => Navigator.of(context).pop(language),
              ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.logout_rounded, size: 18),
      label: const Text('Logout'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
        foregroundColor: AppColors.error,
      ),
    );
  }
}

/// Edits the columns a resident may change themselves: `users.name` and
/// `users.email`. The phone number is the account identifier and is locked.
class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({
    required this.user,
    required this.photoBytes,
    required this.onPhotoChanged,
  });

  final AppUser user;
  final Uint8List? photoBytes;

  /// Called as soon as a photo is picked or removed, so the screen behind the
  /// sheet updates its header too.
  final ValueChanged<Uint8List?> onPhotoChanged;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final _name = TextEditingController(text: widget.user.name);
  late final _email = TextEditingController(text: widget.user.email ?? '');
  late Uint8List? _photoBytes = widget.photoBytes;

  Future<void> _pickPhoto() async {
    final hasPhoto = _photoBytes != null || widget.user.photoUrl != null;
    final picked = await pickProfilePhoto(context, allowRemove: hasPhoto);
    if (picked == null || !mounted) return;
    final bytes = picked.isRemoval ? null : picked.bytes;
    setState(() => _photoBytes = bytes);
    widget.onPhotoChanged(bytes);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          // users.photo_url — camera or gallery
          Center(
            child: Column(
              children: [
                PhotoAvatar(
                  initials: widget.user.initials,
                  photoUrl: widget.user.photoUrl,
                  photoBytes: _photoBytes,
                  radius: 40,
                  onEdit: _pickPhoto,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _pickPhoto,
                  child: Text(
                    _photoBytes == null && widget.user.photoUrl == null
                        ? 'Add profile photo'
                        : 'Change photo',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          LabelledField(
            label: 'Full name',
            required: true,
            controller: _name,
            hint: 'Your name',
          ),
          const SizedBox(height: 16),
          LabelledField(
            label: 'Email',
            controller: _email,
            hint: 'name@email.com',
            keyboardType: TextInputType.emailAddress,
            helper: 'Used for receipts and bill copies.',
          ),
          const SizedBox(height: 16),
          const InfoBanner(
            message: 'Your mobile number is your login and cannot be changed.',
            icon: Icons.lock_outline_rounded,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save changes'),
          ),
        ],
      ),
    );
  }
}
