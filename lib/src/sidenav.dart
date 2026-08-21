import 'package:flutter/material.dart';

import 'theme.dart';

/// One shell destination in [SafaehSidenav].
class SafaehSidenavDestination {
  const SafaehSidenavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.tileKey,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Key? tileKey;
}

/// Profile / account row at the bottom of [SafaehSidenav].
class SafaehSidenavProfile {
  const SafaehSidenavProfile({
    required this.label,
    required this.onTap,
    this.subtitle,
    this.leading,
    this.trailing,
    this.selected = false,
    this.tileKey,
    this.labelBuilder,
  });

  final String label;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final VoidCallback onTap;
  final Key? tileKey;
  final Widget Function(String data, TextStyle? style)? labelBuilder;
}

/// Temporary drawer (mid) or clipping rail (desktop). Collapse hides labels
/// inside the current width so icons do not slide — including in RTL.
class SafaehSidenav extends StatelessWidget {
  const SafaehSidenav({
    super.key,
    required this.title,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.profile,
    this.footer,
    this.asDrawer = false,
    this.collapsed = false,
    this.onToggleCompact,
    this.expandTooltip,
    this.collapseTooltip,
    this.compactWidth,
    this.expandedWidth,
    this.duration,
    this.railKey = const ValueKey('safaeh_nav_rail'),
    this.expandKey = const ValueKey('safaeh_nav_expand'),
    this.collapseKey = const ValueKey('safaeh_nav_collapse'),
  });

  final String title;
  final List<SafaehSidenavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final SafaehSidenavProfile? profile;
  final Widget? footer;
  final bool asDrawer;
  final bool collapsed;
  final VoidCallback? onToggleCompact;
  final String? expandTooltip;
  final String? collapseTooltip;
  final double? compactWidth;
  final double? expandedWidth;
  final Duration? duration;
  final Key railKey;
  final Key expandKey;
  final Key collapseKey;

  @override
  Widget build(BuildContext context) {
    final tokens = SafaehTheme.of(context);
    final compact = compactWidth ?? tokens.compactNavWidth;
    final expanded = expandedWidth ?? tokens.expandedNavWidth;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final chrome = (fill: cs.surfaceContainerLow, onFill: cs.onSurface);
    final width = collapsed ? compact : expanded;
    final motion = safaehResolvedMotion(context, duration ?? tokens.navMotion);

    final body = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            title: title,
            asDrawer: asDrawer,
            collapsed: collapsed,
            onFill: chrome.onFill,
            onToggleCompact: asDrawer ? null : onToggleCompact,
            expandTooltip: expandTooltip,
            collapseTooltip: collapseTooltip,
            compactWidth: compact,
            expandKey: expandKey,
            collapseKey: collapseKey,
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < destinations.length; i++)
            _NavTile(
              tileKey: destinations[i].tileKey ?? ValueKey('safaeh_nav_$i'),
              label: destinations[i].label,
              icon: selectedIndex == i
                  ? destinations[i].selectedIcon
                  : destinations[i].icon,
              selected: selectedIndex == i,
              collapsed: !asDrawer && collapsed,
              fill: chrome.fill,
              onFill: chrome.onFill,
              onTap: () => onDestinationSelected(i),
            ),
          const Spacer(),
          if (profile != null)
            _NavTile(
              tileKey: profile!.tileKey ?? const ValueKey('safaeh_nav_profile'),
              label: profile!.label,
              subtitle: profile!.subtitle,
              selected: profile!.selected,
              collapsed: !asDrawer && collapsed,
              fill: chrome.fill,
              onFill: chrome.onFill,
              leading: profile!.leading,
              trailing: profile!.trailing,
              labelBuilder: profile!.labelBuilder,
              onTap: profile!.onTap,
            ),
          if (footer != null)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: asDrawer ? 20 : compact,
                end: 16,
                top: 4,
                bottom: 12,
              ),
              child: footer,
            ),
        ],
      ),
    );

    if (asDrawer) {
      return body;
    }

    return AnimatedContainer(
      key: railKey,
      duration: motion,
      curve: Curves.fastOutSlowIn,
      width: width,
      clipBehavior: Clip.hardEdge,
      color: chrome.fill,
      child: body,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.asDrawer,
    required this.collapsed,
    required this.onFill,
    required this.compactWidth,
    required this.expandKey,
    required this.collapseKey,
    this.onToggleCompact,
    this.expandTooltip,
    this.collapseTooltip,
  });

  final String title;
  final bool asDrawer;
  final bool collapsed;
  final Color onFill;
  final double compactWidth;
  final VoidCallback? onToggleCompact;
  final String? expandTooltip;
  final String? collapseTooltip;
  final Key expandKey;
  final Key collapseKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleWidget = Text(
      title,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.titleMedium?.copyWith(
        color: onFill,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
    );

    if (asDrawer || onToggleCompact == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: titleWidget,
      );
    }

    return SizedBox(
      height: 56,
      child: Row(
        children: [
          SizedBox(
            width: compactWidth,
            child: Center(
              child: IconButton(
                key: collapsed ? expandKey : collapseKey,
                tooltip: collapsed ? expandTooltip : collapseTooltip,
                color: onFill,
                onPressed: onToggleCompact,
                icon: Icon(collapsed ? Icons.menu : Icons.chevron_left),
              ),
            ),
          ),
          Expanded(child: titleWidget),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.tileKey,
    required this.label,
    required this.selected,
    required this.collapsed,
    required this.fill,
    required this.onFill,
    required this.onTap,
    this.icon,
    this.leading,
    this.trailing,
    this.subtitle,
    this.labelBuilder,
  });

  final Key tileKey;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final bool collapsed;
  final Color fill;
  final Color onFill;
  final VoidCallback onTap;
  final Widget Function(String data, TextStyle? style)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected ? fill : onFill;
    final radius = BorderRadius.circular(16);

    final labelColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _labelText(
          theme: theme,
          data: label,
          color: color,
          selected: selected,
          isSubtitle: false,
        ),
        if (subtitle != null)
          _labelText(
            theme: theme,
            data: subtitle!,
            color: color.withValues(alpha: 0.8),
            selected: false,
            isSubtitle: true,
          ),
      ],
    );

    final tile = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: selected ? onFill : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          key: tileKey,
          canRequestFocus: false,
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final showTrailing =
                    trailing != null && constraints.maxWidth >= 72;
                return Row(
                  children: [
                    leading ?? Icon(icon, color: color),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 12),
                        child: labelColumn,
                      ),
                    ),
                    if (showTrailing) trailing!,
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    if (collapsed) return Tooltip(message: label, child: tile);
    return tile;
  }

  Widget _labelText({
    required ThemeData theme,
    required String data,
    required Color color,
    required bool selected,
    required bool isSubtitle,
  }) {
    final style =
        (isSubtitle ? theme.textTheme.labelSmall : theme.textTheme.bodyMedium)
            ?.copyWith(
              color: color,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            );
    if (!isSubtitle && labelBuilder != null) {
      return labelBuilder!(data, style);
    }
    return Text(
      data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}
