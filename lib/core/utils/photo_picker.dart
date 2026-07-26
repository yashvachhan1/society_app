import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_theme.dart';

/// A photo the resident chose for `users.photo_url`, held in memory until the
/// backend exists to upload it to.
///
/// Bytes are used rather than a file path so the same code works on Android,
/// iOS and web.
class PickedPhoto {
  PickedPhoto({required this.bytes, required this.fileName});

  final Uint8List bytes;
  final String fileName;

  /// Returned when the resident chose "Remove photo".
  static final removed = PickedPhoto(bytes: Uint8List(0), fileName: '');

  /// True for the [removed] result — the caller should clear the photo.
  bool get isRemoval => bytes.isEmpty;
}

/// Asks the resident where the photo should come from, then opens the camera or
/// the gallery. Returns null if they cancel.
///
/// [allowRemove] adds a "Remove photo" option, used when one is already set.
Future<PickedPhoto?> pickProfilePhoto(
  BuildContext context, {
  bool allowRemove = false,
}) async {
  final source = await showModalBottomSheet<_PhotoAction>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _PhotoSourceSheet(allowRemove: allowRemove),
  );

  if (source == null) return null;
  if (source == _PhotoAction.remove) return PickedPhoto.removed;

  final picker = ImagePicker();
  final file = await picker.pickImage(
    source: source == _PhotoAction.camera
        ? ImageSource.camera
        : ImageSource.gallery,
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 85,
  );
  if (file == null) return null;

  final bytes = await file.readAsBytes();
  return PickedPhoto(bytes: bytes, fileName: file.name);
}

enum _PhotoAction { camera, gallery, remove }

class _PhotoSourceSheet extends StatelessWidget {
  const _PhotoSourceSheet({required this.allowRemove});

  final bool allowRemove;

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
              'Profile photo',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _SourceTile(
              icon: Icons.photo_camera_outlined,
              label: 'Take a photo',
              subtitle: 'Use the camera',
              color: AppColors.primary,
              onTap: () => Navigator.of(context).pop(_PhotoAction.camera),
            ),
            const SizedBox(height: 10),
            _SourceTile(
              icon: Icons.photo_library_outlined,
              label: 'Choose from gallery',
              subtitle: 'Pick an existing picture',
              color: AppColors.accent,
              onTap: () => Navigator.of(context).pop(_PhotoAction.gallery),
            ),
            if (allowRemove) ...[
              const SizedBox(height: 10),
              _SourceTile(
                icon: Icons.delete_outline_rounded,
                label: 'Remove photo',
                subtitle: 'Go back to your initials',
                color: AppColors.error,
                onTap: () => Navigator.of(context).pop(_PhotoAction.remove),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
