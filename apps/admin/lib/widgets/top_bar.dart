import 'package:flutter/material.dart';
import 'package:society_core/society_core.dart';

/// The dashboard top bar: page title on the left; search box and quick-action
/// icons on the right.
class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.title, this.onMenu});

  final String title;

  /// When non-null the bar shows a hamburger button (compact / mobile layout)
  /// that opens the navigation drawer. Null on desktop where the sidebar is
  /// always visible.
  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    final compact = onMenu != null;
    return Container(
      height: 74,
      padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          if (compact) ...[
            IconButton(
              onPressed: onMenu,
              tooltip: 'Menu',
              icon: const Icon(
                Icons.menu_rounded,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (compact)
            const _ActionIcon(icon: Icons.search_rounded)
          else
            const _SearchBox(),
          const SizedBox(width: 12),
          const _ActionIcon(icon: Icons.notifications_none_rounded, dot: true),
          if (!compact) ...[
            const SizedBox(width: 10),
            const _ActionIcon(icon: Icons.help_outline_rounded),
          ],
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 42,
      child: TextField(
        style: const TextStyle(fontSize: 13.5),
        decoration: InputDecoration(
          hintText: 'Search residents, flats, bills…',
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, this.dot = false});

  final IconData icon;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 21, color: AppColors.textPrimary),
        ),
        if (dot)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
