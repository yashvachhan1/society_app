import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'labelled_field.dart';

/// A labelled, tappable date input backed by the platform date picker — used
/// for the `DATE` columns the resident fills in (agreement start / end).
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint = 'Select date',
    this.helper,
    this.required = false,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String hint;
  final String? helper;
  final bool required;
  final DateTime? firstDate;
  final DateTime? lastDate;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: firstDate ?? DateTime(now.year - 10),
      lastDate: lastDate ?? DateTime(now.year + 10),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, required: required),
        InkWell(
          onTap: () => _pick(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasValue ? formatDate(value) : hint,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                      color: hasValue
                          ? AppColors.textPrimary
                          : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (helper != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              helper!,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

/// A round avatar that shows the user's photo when `users.photo_url` is set and
/// their initials otherwise, with an optional camera button to change it.
class PhotoAvatar extends StatelessWidget {
  const PhotoAvatar({
    super.key,
    required this.initials,
    this.photoUrl,
    this.radius = 45,
    this.onEdit,
    this.onLight = false,
  });

  final String initials;
  final String? photoUrl;
  final double radius;
  final VoidCallback? onEdit;

  /// Set on a coloured header so the fallback uses white-on-tint.
  final bool onLight;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;
    final fg = onLight ? Colors.white : AppColors.primary;

    return Stack(
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            color: onLight
                ? Colors.white.withValues(alpha: 0.18)
                : AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: onLight
                ? Border.all(color: Colors.white, width: 3)
                : null,
            image: hasPhoto
                ? DecorationImage(
                    image: NetworkImage(photoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: hasPhoto
              ? null
              : Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: fg,
                      fontSize: radius * 0.66,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
        ),
        if (onEdit != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: onEdit,
              customBorder: const CircleBorder(),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
