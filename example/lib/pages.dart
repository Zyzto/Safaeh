import 'package:flutter/material.dart';
import 'package:safaeh/safaeh.dart';

class AdaptiveSheetDemo extends StatelessWidget {
  const AdaptiveSheetDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return PhoneSheetFrame(
      key: const ValueKey('safaeh_panel'),
      title: t('rename'),
      child: Padding(
        padding: kSheetContentPadding,
        child: TextField(decoration: InputDecoration(labelText: t('name'))),
      ),
    );
  }
}

class CardPickerDemo extends StatelessWidget {
  const CardPickerDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t('settle'), style: titleStyle),
          const SizedBox(height: 10),
          _PickerCard(
            icon: Icons.bolt_outlined,
            label: t('minimal'),
            subtitle: t('minimal_sub'),
            selected: true,
          ),
          const SizedBox(height: 6),
          _PickerCard(
            icon: Icons.people_outline,
            label: t('pairs'),
            subtitle: t('pairs_sub'),
            selected: false,
          ),
          const SizedBox(height: 10),
          Text(
            t('picker_footer'),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerCard extends StatelessWidget {
  const _PickerCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: selected ? cs.primaryContainer : cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? cs.primary : cs.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: selected ? cs.onPrimaryContainer : cs.onSurface,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected ? cs.onPrimaryContainer : cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: selected
                            ? cs.onPrimaryContainer
                            : cs.onSurfaceVariant,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  color: cs.onPrimaryContainer,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TilePickerDemo extends StatelessWidget {
  const TilePickerDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return SafaehTilePickerBody<String>(
      title: t('choose_account'),
      header: Text(t('header_hint')),
      selected: 'cash',
      tabletBreakpoint: 10000,
      options: [
        SafaehTileOption(
          value: 'cash',
          label: t('cash'),
          subtitle: t('minimal_sub'),
          leading: const Icon(Icons.payments_outlined),
        ),
        SafaehTileOption(
          value: 'card',
          label: t('card'),
          leading: const Icon(Icons.credit_card_outlined),
        ),
        SafaehTileOption(
          value: 'offline',
          label: t('offline'),
          enabled: false,
          leading: const Icon(Icons.cloud_off_outlined),
        ),
      ],
      tileBuilder: (context, opt, selected) {
        return SafaehOptionTile(
          title: Text(opt.label),
          subtitle: opt.subtitle != null ? Text(opt.subtitle!) : null,
          leading: opt.leading,
          enabled: opt.enabled,
          selected: selected,
          onTap: opt.enabled ? () {} : null,
        );
      },
    );
  }
}

class ConfirmDemo extends StatelessWidget {
  const ConfirmDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    return buildSafaehSheetShell(
      title: Text(t('delete_item'), style: titleStyle),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            t('cannot_undo'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          key: const ValueKey('safaeh_cancel'),
          onPressed: () {},
          child: Text(t('cancel')),
        ),
        Material(
          key: const ValueKey('safaeh_confirm'),
          color: cs.error,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text(
              t('delete'),
              style: theme.textTheme.labelLarge?.copyWith(
                color: cs.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TextInputDemo extends StatelessWidget {
  const TextInputDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    return buildSafaehSheetShell(
      title: Text(t('tag_name'), style: titleStyle),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: TextField(
            decoration: InputDecoration(
              hintText: t('work'),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () {}, child: Text(t('cancel'))),
        FilledButton(
          key: const ValueKey('safaeh_text_done'),
          onPressed: () {},
          child: Text(t('done')),
        ),
      ],
    );
  }
}

class SheetShellDemo extends StatelessWidget {
  const SheetShellDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    return buildSafaehSheetShell(
      title: Text(t('sheet_shell'), style: titleStyle),
      body: Text(t('shell_body')),
      actions: [
        TextButton(onPressed: () {}, child: Text(t('cancel'))),
        FilledButton(onPressed: () {}, child: Text(t('save'))),
      ],
    );
  }
}

class SheetMorphDemo extends StatelessWidget {
  const SheetMorphDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _LabeledFrame(
            label: '400',
            width: 320,
            child: PhoneSheetFrame(
              title: t('rename'),
              child: Padding(
                padding: kSheetContentPadding,
                child: Text(t('sheet_sub')),
              ),
            ),
          ),
          const SizedBox(width: 16),
          _LabeledFrame(
            label: '900',
            width: 420,
            child: TabletSheetFrame(
              title: t('rename'),
              child: Padding(
                padding: kSheetContentPadding,
                child: Text(t('sheet_sub')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledFrame extends StatelessWidget {
  const _LabeledFrame({
    required this.label,
    required this.width,
    required this.child,
  });

  final String label;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class OptionTilesDemo extends StatelessWidget {
  const OptionTilesDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return SafaehOptionList(
      children: [
        SafaehOptionTile(
          title: Text(t('selected')),
          subtitle: Text(t('selected_sub')),
          selected: true,
          leading: const Icon(Icons.check_circle_outline),
          onTap: () {},
        ),
        SafaehOptionTile(
          title: Text(t('disabled')),
          subtitle: Text(t('disabled_sub')),
          enabled: false,
        ),
        SafaehOptionTile(
          title: Text(t('destructive')),
          subtitle: Text(t('destructive_sub')),
          destructive: true,
          onTap: () {},
        ),
      ],
    );
  }
}

class DialogDemo extends StatelessWidget {
  const DialogDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ColoredBox(
      color: cs.scrim.withValues(alpha: 0.32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(t('dialog_body')),
          ),
        ),
      ),
    );
  }
}

class SidenavRailDemo extends StatefulWidget {
  const SidenavRailDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<SidenavRailDemo> createState() => _SidenavRailDemoState();
}

class _SidenavRailDemoState extends State<SidenavRailDemo> {
  var _collapsed = false;
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return Row(
      children: [
        SafaehSidenav(
          title: t('app_title'),
          collapsed: _collapsed,
          onToggleCompact: () => setState(() => _collapsed = !_collapsed),
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          expandTooltip: t('expand'),
          collapseTooltip: t('collapse'),
          destinations: [
            SafaehSidenavDestination(
              label: t('groups'),
              icon: Icons.group_outlined,
              selectedIcon: Icons.group,
            ),
            SafaehSidenavDestination(
              label: t('settings'),
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
            ),
          ],
          profile: SafaehSidenavProfile(
            label: 'Ada Lovelace',
            subtitle: 'ada@example.com',
            trailing: const Icon(Icons.chevron_right, size: 22),
            onTap: () {},
          ),
        ),
        Expanded(
          child: Center(child: Text(t('toggle_rail'))),
        ),
      ],
    );
  }
}

class SidenavDrawerDemo extends StatefulWidget {
  const SidenavDrawerDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<SidenavDrawerDemo> createState() => _SidenavDrawerDemoState();
}

class _SidenavDrawerDemoState extends State<SidenavDrawerDemo> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafaehSidenav(
        asDrawer: true,
        title: t('app_title'),
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          SafaehSidenavDestination(
            label: t('groups'),
            icon: Icons.group_outlined,
            selectedIcon: Icons.group,
          ),
          SafaehSidenavDestination(
            label: t('settings'),
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
          ),
        ],
        profile: SafaehSidenavProfile(
          label: 'Ada Lovelace',
          subtitle: 'ada@example.com',
          onTap: () {},
        ),
        footer: Text(t('app_title')),
      ),
    );
  }
}

class FloatingNavDemo extends StatefulWidget {
  const FloatingNavDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<FloatingNavDemo> createState() => _FloatingNavDemoState();
}

class _FloatingNavDemoState extends State<FloatingNavDemo> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text('${t('selected_index')} $_index'),
        ),
        SafaehFloatingNavBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          destinations: [
            SafaehSidenavDestination(
              label: t('home'),
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
            ),
            SafaehSidenavDestination(
              label: t('settings'),
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
            ),
          ],
        ),
      ],
    );
  }
}

class PageIndexRailDemo extends StatefulWidget {
  const PageIndexRailDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<PageIndexRailDemo> createState() => _PageIndexRailDemoState();
}

class _PageIndexRailDemoState extends State<PageIndexRailDemo> {
  final _scroll = ScrollController();
  final _alpha = GlobalKey();
  final _beta = GlobalKey();
  final _gamma = GlobalKey();
  late final List<SafaehPageIndexEntry> _entries;
  String? _active = 'alpha';

  @override
  void initState() {
    super.initState();
    _entries = [
      SafaehPageIndexEntry(id: 'alpha', label: widget.t('alpha'), key: _alpha),
      SafaehPageIndexEntry(id: 'beta', label: widget.t('beta'), key: _beta),
      SafaehPageIndexEntry(id: 'gamma', label: widget.t('gamma'), key: _gamma),
    ];
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final next = safaehActivePageSectionId(
          sections: [('alpha', _alpha), ('beta', _beta), ('gamma', _gamma)],
          scrollContext: notification.context ?? context,
        );
        if (next != null && next != _active) {
          setState(() => _active = next);
        }
        return false;
      },
      child: Row(
        children: [
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              children: [
                SizedBox(key: _alpha, height: 120, child: Text(t('alpha'))),
                SizedBox(key: _beta, height: 120, child: Text(t('beta'))),
                SizedBox(key: _gamma, height: 120, child: Text(t('gamma'))),
              ],
            ),
          ),
          SizedBox(
            width: 168,
            child: SafaehPageIndex(
              title: t('on_this_page'),
              entries: _entries,
              activeId: _active,
              onSelect: (entry) async {
                setState(() => _active = entry.id);
                await scrollToPageSection(entry.key, controller: _scroll);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PageIndexOverlayDemo extends StatefulWidget {
  const PageIndexOverlayDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<PageIndexOverlayDemo> createState() => _PageIndexOverlayDemoState();
}

class _PageIndexOverlayDemoState extends State<PageIndexOverlayDemo> {
  final _scroll = ScrollController();
  final _alpha = GlobalKey();
  final _beta = GlobalKey();
  late final List<SafaehPageIndexEntry> _entries;
  String? _active = 'alpha';

  @override
  void initState() {
    super.initState();
    _entries = [
      SafaehPageIndexEntry(id: 'alpha', label: widget.t('alpha'), key: _alpha),
      SafaehPageIndexEntry(id: 'beta', label: widget.t('beta'), key: _beta),
    ];
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return Stack(
      children: [
        ListView(
          controller: _scroll,
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(key: _alpha, height: 140, child: Text(t('alpha'))),
            SizedBox(key: _beta, height: 140, child: Text(t('beta'))),
          ],
        ),
        SafaehPageIndexOverlay(
          title: t('on_this_page'),
          entries: _entries,
          activeId: _active,
          onSelect: (entry) async {
            setState(() => _active = entry.id);
            await scrollToPageSection(entry.key, controller: _scroll);
          },
        ),
      ],
    );
  }
}

class ContentBandDemo extends StatelessWidget {
  const ContentBandDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return SafaehContentBand(
      aside: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(t('aside')),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(t('band_copy')),
      ),
    );
  }
}

class EndAsideDemo extends StatelessWidget {
  const EndAsideDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = safaehBandMetrics(
          contentAreaWidth: constraints.maxWidth,
          maxWidth: 420,
        );
        return SafaehEndAsideLayout(
          leftOffset: metrics.leftOffset,
          bandWidth: metrics.bandWidth,
          endFree: metrics.endFree,
          isRtl: Directionality.of(context) == TextDirection.rtl,
          aside: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(t('aside')),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(t('aside_copy')),
          ),
        );
      },
    );
  }
}

class AlignedChromeDemo extends StatelessWidget {
  const AlignedChromeDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = safaehBandMetrics(
          contentAreaWidth: constraints.maxWidth,
          maxWidth: 480,
        );
        return Scaffold(
          appBar: SafaehContentAlignedAppBar(
            leftOffset: metrics.leftOffset,
            bandWidth: metrics.bandWidth,
            leading: const IconButton(
              onPressed: null,
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(t('aligned_title')),
          ),
          floatingActionButtonLocation: SafaehContentAlignedFabLocation.resolve(
            leftOffset: metrics.leftOffset,
            bandWidth: metrics.bandWidth,
            endFree: metrics.endFree,
            textDirection: Directionality.of(context),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: t('add'),
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(metrics.leftOffset, 16, 16, 16),
            child: SizedBox(
              width: metrics.bandWidth,
              child: Text(t('aligned_chrome_sub')),
            ),
          ),
        );
      },
    );
  }
}

class CameraDemo extends StatelessWidget {
  const CameraDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return SafaehCameraSheetHost(
      onDismiss: () async {},
      builder: (context, sheet) => MockCameraChild(sheet: sheet, t: t),
    );
  }
}

class MockCameraChild extends StatelessWidget {
  const MockCameraChild({super.key, required this.sheet, required this.t});

  final SafaehCameraSheet sheet;
  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        children: [
          Center(
            child: Text(
              t('mock_preview'),
              style: const TextStyle(color: Color(0xE6FFFFFF)),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              children: [
                IconButton(
                  onPressed: sheet.toggleExpanded,
                  icon: Icon(
                    sheet.expanded
                        ? Icons.close_fullscreen
                        : Icons.open_in_full,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: sheet.dismiss,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QrOverlayDemo extends StatelessWidget {
  const QrOverlayDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: SafaehQrScannerOverlay(
        scanLine: const AlwaysStoppedAnimation<double>(0.4),
        title: Text(
          t('scan_invite'),
          style: const TextStyle(color: Colors.white),
        ),
        hint: Text(
          t('point_at_code'),
          style: const TextStyle(color: Color(0xE6FFFFFF)),
        ),
        expanded: false,
        expandTooltip: t('expand'),
        collapseTooltip: t('collapse'),
        onClose: () {},
        onToggleExpanded: () {},
      ),
    );
  }
}

class QrMessageDemo extends StatelessWidget {
  const QrMessageDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: SafaehQrMessageBody(
        onClose: () {},
        message: Text(
          t('need_camera'),
          style: const TextStyle(color: Colors.white),
        ),
        action: FilledButton(onPressed: () {}, child: Text(t('open_settings'))),
      ),
    );
  }
}

class PhoneSheetFrame extends StatelessWidget {
  const PhoneSheetFrame({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: cs.surfaceContainerLow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class TabletSheetFrame extends StatelessWidget {
  const TabletSheetFrame({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: cs.surfaceContainerLow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(Icons.close, size: 22, color: cs.onSurface),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
