import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'dashboard_models.dart';

/// Lets any page inside a [DashboardShell] switch the selected sidebar tab —
/// e.g. an "Add Property" button that jumps to the onboarding tab. Access it
/// with `DashboardScope.of(context).go(index)`.
class DashboardScope extends InheritedWidget {
  const DashboardScope({
    super.key,
    required this.currentIndex,
    required this.go,
    required super.child,
  });

  final int currentIndex;
  final void Function(int index) go;

  static DashboardScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DashboardScope>();
    assert(scope != null, 'DashboardScope.of() used outside a DashboardShell');
    return scope!;
  }

  @override
  bool updateShouldNotify(DashboardScope oldWidget) =>
      currentIndex != oldWidget.currentIndex;
}

/// A responsive web-dashboard scaffold shared by the admin and owner panels.
///
/// Wide screens get a permanent left sidebar; narrow screens (phones/tablets)
/// collapse it into a hamburger drawer. The shell owns the selected-tab state
/// and asks [pageBuilder] for the body of the current tab.
class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.brandTitle,
    required this.brandSubtitle,
    required this.brandLogo,
    required this.navItems,
    required this.pageBuilder,
    required this.userInitials,
    required this.userName,
    required this.userRole,
    this.initialIndex = 0,
  });

  final String brandTitle;
  final String brandSubtitle;
  final Widget brandLogo;
  final List<DashNavItem> navItems;

  /// Builds the body for the currently-selected nav index.
  final IndexedWidgetBuilder pageBuilder;

  final String userInitials;
  final String userName;
  final String userRole;
  final int initialIndex;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _index = widget.initialIndex;

  static const _wideBreakpoint = 900.0;

  @override
  Widget build(BuildContext context) {
    final title = widget.navItems[_index].label;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _wideBreakpoint;

        void onSelect(int i) {
          setState(() => _index = i);
          if (!isWide) _scaffoldKey.currentState?.closeDrawer();
        }

        final sidebar = _Sidebar(
          brandTitle: widget.brandTitle,
          brandSubtitle: widget.brandSubtitle,
          brandLogo: widget.brandLogo,
          navItems: widget.navItems,
          selectedIndex: _index,
          onSelect: onSelect,
          userInitials: widget.userInitials,
          userName: widget.userName,
          userRole: widget.userRole,
        );

        return DashboardScope(
          currentIndex: _index,
          go: onSelect,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.background,
            drawer: isWide
                ? null
                : Drawer(
                    width: 270,
                    backgroundColor: AppColors.surface,
                    child: sidebar,
                  ),
            body: SafeArea(
              child: Row(
                children: [
                  if (isWide) sidebar,
                  Expanded(
                    child: Column(
                      children: [
                        _TopBar(
                          title: title,
                          onMenu: isWide
                              ? null
                              : () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                        Expanded(child: widget.pageBuilder(context, _index)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.brandTitle,
    required this.brandSubtitle,
    required this.brandLogo,
    required this.navItems,
    required this.selectedIndex,
    required this.onSelect,
    required this.userInitials,
    required this.userName,
    required this.userRole,
  });

  final String brandTitle;
  final String brandSubtitle;
  final Widget brandLogo;
  final List<DashNavItem> navItems;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final String userInitials;
  final String userName;
  final String userRole;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 264,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Brand(title: brandTitle, subtitle: brandSubtitle, logo: brandLogo),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              itemCount: navItems.length,
              itemBuilder: (context, i) => _NavTile(
                item: navItems[i],
                selected: i == selectedIndex,
                onTap: () => onSelect(i),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          _UserTile(initials: userInitials, name: userName, role: userRole),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({
    required this.title,
    required this.subtitle,
    required this.logo,
  });

  final String title;
  final String subtitle;
  final Widget logo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: Row(
        children: [
          logo,
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final DashNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 21,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (item.badge != null)
                  _Badge(count: item.badge!, selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count, required this.selected});

  final int count;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: selected
            ? Colors.white.withValues(alpha: 0.25)
            : AppColors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.initials,
    required this.name,
    required this.role,
  });

  final String initials;
  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.logout_rounded,
            size: 19,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, this.onMenu});

  final String title;
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
          hintText: 'Search…',
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
