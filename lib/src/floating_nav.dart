import 'package:flutter/material.dart';

import 'sidenav.dart';
import 'theme.dart';

/// Phone floating destination bar. Reuses [SafaehSidenavDestination].
///
/// ColorScheme + a modest shadow. Hosts pass radius / shadows / colors when
/// they need experiment styles or cheap-shadow overrides.
class SafaehFloatingNavBar extends StatelessWidget {
  const SafaehFloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.radius = 24,
    this.iconSize = 24,
    this.shadows,
    this.border,
    this.motion,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<SafaehSidenavDestination> destinations;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;
  final double radius;
  final double iconSize;
  final List<BoxShadow>? shadows;
  final BoxBorder? border;
  final Duration? motion;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final active = activeColor ?? cs.primary;
    final inactive = inactiveColor ?? cs.onSurfaceVariant;
    final background = backgroundColor ?? cs.surfaceContainerHighest;
    final tabMotion = safaehResolvedMotion(
      context,
      motion ?? const Duration(milliseconds: 200),
    );
    final decoration = BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
      border: border,
      boxShadow:
          shadows ??
          [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
    );

    return SafeArea(
      child: Container(
        margin: margin,
        decoration: decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(destinations.length, (index) {
            final destination = destinations[index];
            final isSelected = index == selectedIndex;
            final color = isSelected ? active : inactive;

            return Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: destination.tileKey ?? ValueKey('safaeh_fab_nav_$index'),
                  onTap: () => onDestinationSelected(index),
                  borderRadius: BorderRadius.circular(12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 44,
                      minWidth: 44,
                    ),
                    child: AnimatedContainer(
                      duration: tabMotion,
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected
                                ? destination.selectedIcon
                                : destination.icon,
                            color: color,
                            size: iconSize,
                          ),
                          if (destination.label.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: tabMotion,
                              style: theme.textTheme.labelSmall!.copyWith(
                                color: color,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              child: Text(destination.label),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
