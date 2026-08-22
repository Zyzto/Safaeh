import 'package:flutter/material.dart';
import 'package:safaeh/safaeh.dart';

import 'catalog.dart';
import 'mock_camera.dart';

class AdaptiveSheetDemo extends StatelessWidget {
  const AdaptiveSheetDemo({super.key, required this.t, this.raised = false});

  final String Function(String key) t;
  final bool raised;

  @override
  Widget build(BuildContext context) {
    return PhoneSheetFrame(
      key: const ValueKey('safaeh_panel'),
      title: t('rename'),
      raised: raised,
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
    return SafaehOptionPickerBody<int>(
      title: t('settle'),
      selected: 1,
      footer: t('picker_footer'),
      tabletBreakpoint: 10000,
      onSelected: (_) {},
      options: [
        SafaehOption(
          value: 1,
          label: t('minimal'),
          subtitle: t('minimal_sub'),
          icon: Icons.bolt_outlined,
        ),
        SafaehOption(
          value: 2,
          label: t('pairs'),
          subtitle: t('pairs_sub'),
          icon: Icons.people_outline,
        ),
      ],
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
      onSelected: (_) {},
      tileBuilder: (context, opt, selected) {
        return SafaehOptionTile(
          title: Text(opt.label),
          subtitle: opt.subtitle != null ? Text(opt.subtitle!) : null,
          leading: opt.leading,
          enabled: opt.enabled,
          selected: selected,
        );
      },
    );
  }
}

class MultiTilePickerDemo extends StatelessWidget {
  const MultiTilePickerDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return SafaehTilePickerBody<String>(
      title: t('choose_account'),
      tabletBreakpoint: 10000,
      multiSelect: true,
      selectedValues: const ['cash'],
      searchHint: t('search_accounts'),
      searchEmptyLabel: t('no_matches'),
      confirmLabel: t('apply'),
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
    );
  }
}

class StatusBodyDemo extends StatelessWidget {
  const StatusBodyDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafaehStatusBody(
          busy: true,
          progress: 0.4,
          message: Text(t('loading')),
        ),
        SafaehStatusBody(
          icon: Icons.inbox_outlined,
          message: Text(t('nothing_here')),
          action: TextButton(onPressed: () {}, child: Text(t('try_again'))),
        ),
      ],
    );
  }
}

class ConfirmDemo extends StatelessWidget {
  const ConfirmDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return SafaehConfirmSheet(
      title: t('delete_item'),
      content: t('cannot_undo'),
      confirmLabel: t('delete'),
      cancelLabel: t('cancel'),
      isDestructive: true,
      tabletBreakpoint: 10000,
    );
  }
}

class TextInputDemo extends StatelessWidget {
  const TextInputDemo({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return SafaehTextInputSheet(
      title: t('tag_name'),
      doneLabel: t('done'),
      hint: t('work'),
      cancelLabel: t('cancel'),
      tabletBreakpoint: 10000,
      autofocus: false,
    );
  }
}

class SheetShellDemo extends StatefulWidget {
  const SheetShellDemo({
    super.key,
    required this.t,
    this.interactive = false,
    this.popOnAction = false,
  });

  final String Function(String key) t;
  final bool interactive;
  final bool popOnAction;

  @override
  State<SheetShellDemo> createState() => _SheetShellDemoState();
}

class _SheetShellDemoState extends State<SheetShellDemo> {
  var _format = 'csv';

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final theme = Theme.of(context);
    final hosted = widget.popOnAction;
    final showTitleInBody = !hosted || !SafaehTheme.of(context).isWide(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );

    void select(String format) {
      if (!widget.interactive) return;
      setState(() => _format = format);
    }

    void act() {
      if (widget.popOnAction) {
        final nav = Navigator.of(context, rootNavigator: true);
        if (nav.canPop()) nav.pop();
      }
    }

    return buildSafaehSheetShell(
      showTitleInBody: showTitleInBody,
      title: Text(t('export_report'), style: titleStyle),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t('shell_body'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          SafaehOptionTile(
            title: Text(t('shell_csv')),
            selected: _format == 'csv',
            onTap: () => select('csv'),
          ),
          const SizedBox(height: 8),
          SafaehOptionTile(
            title: Text(t('shell_pdf')),
            selected: _format == 'pdf',
            onTap: () => select('pdf'),
          ),
          if (widget.interactive) ...[
            const SizedBox(height: 10),
            Text(
              _format == 'csv' ? t('shell_picked_csv') : t('shell_picked_pdf'),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: act, child: Text(t('cancel'))),
        FilledButton(onPressed: act, child: Text(t('save'))),
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
            label: '320',
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
            label: '420',
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
          leading: const Icon(Icons.bookmark_outline),
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
  const DialogDemo({super.key, required this.t, this.fill = false});

  final String Function(String key) t;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final tokens = SafaehTheme.of(context);
    final cs = Theme.of(context).colorScheme;
    final dialog = ColoredBox(
      color: cs.scrim.withValues(alpha: 0.32),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: tokens.dialogMaxWidth),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(tokens.radius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(t('dialog_body')),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return fill ? SizedBox.expand(child: dialog) : dialog;
  }
}

class _DemoPage extends StatelessWidget {
  const _DemoPage({
    required this.title,
    required this.body,
    this.pad = true,
  });

  final String title;
  final String body;
  final bool pad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(body, style: theme.textTheme.bodyMedium),
      ],
    );
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: pad
          ? ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), children: [content])
          : content,
    );
  }
}

class _DemoSection extends StatelessWidget {
  const _DemoSection({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
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
  bool? _collapsedOverride;
  var _index = 0;

  bool _collapsedFor(BuildContext context) {
    return _collapsedOverride ?? !SafaehTheme.of(context).isWide(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final collapsed = _collapsedFor(context);
    return Row(
      children: [
        SafaehSidenav(
          title: t('app_title'),
          collapsed: collapsed,
          onToggleCompact: () {
            setState(() => _collapsedOverride = !collapsed);
          },
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
            label: t('profile_name'),
            subtitle: t('profile_email'),
            labelBuilder: catalogIsolateLabel,
            trailing: Icon(safaehChevronEnd(context), size: 22),
            onTap: () {},
          ),
        ),
        Expanded(
          child: _DemoPage(
            title: _index == 0 ? t('groups') : t('settings'),
            body: t('toggle_rail'),
          ),
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
    final cs = Theme.of(context).colorScheme;
    final drawer = SafaehSidenav(
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
        label: t('profile_name'),
        subtitle: t('profile_email'),
        labelBuilder: catalogIsolateLabel,
        onTap: () {},
      ),
      footer: Text(t('app_title')),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelW = (constraints.maxWidth * 0.86).clamp(0.0, 320.0);
        return Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: cs.surface,
              child: const Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(Icons.menu),
                ),
              ),
            ),
            const ColoredBox(color: Color(0x52000000)),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SizedBox(
                width: panelW,
                child: Material(
                  elevation: 8,
                  color: cs.surfaceContainerLow,
                  child: drawer,
                ),
              ),
            ),
          ],
        );
      },
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
    final bar = SafaehFloatingNavBar(
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
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final tall = constraints.maxHeight.isFinite && constraints.maxHeight > 160;
        final tokens = SafaehTheme.of(context);
        final wide = tokens.isWide(context);
        final metrics = safaehBandMetrics(
          contentAreaWidth: constraints.maxWidth,
          maxWidth: tokens.contentMaxWidth,
        );
        return SizedBox(
          height: tall ? constraints.maxHeight : 240,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    (wide ? metrics.leftOffset : 0) + 20,
                    20,
                    20,
                    88,
                  ),
                  child: _DemoPage(
                    title: _index == 0 ? t('home') : t('settings'),
                    body: t('nav_page_copy'),
                    pad: false,
                  ),
                ),
              ),
              Positioned(
                left: wide ? metrics.leftOffset : 0,
                right: wide ? null : 0,
                width: wide ? metrics.bandWidth : null,
                bottom: 12,
                child: bar,
              ),
            ],
          ),
        );
      },
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
    final wide = SafaehTheme.of(context).isWide(context);
    final list = ListView(
      key: const ValueKey('page_index_demo_list'),
      primary: false,
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
      children: [
        _DemoSection(key: _alpha, title: t('alpha'), body: t('section_copy')),
        _DemoSection(key: _beta, title: t('beta'), body: t('section_copy')),
        _DemoSection(key: _gamma, title: t('gamma'), body: t('section_copy')),
      ],
    );
    Future<void> select(SafaehPageIndexEntry entry) async {
      setState(() => _active = entry.id);
      await scrollToPageSection(entry.key, controller: _scroll);
    }

    final body = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final next = safaehActivePageSectionId(
          sections: [('alpha', _alpha), ('beta', _beta), ('gamma', _gamma)],
          scrollContext: notification.context ?? context,
        );
        if (next != null && next != _active) {
          setState(() => _active = next);
        }
        return true;
      },
      child: list,
    );
    if (!wide) {
      return Stack(
        children: [
          Positioned.fill(child: body),
          SafaehPageIndexOverlay(
            title: t('on_this_page'),
            entries: _entries,
            activeId: _active,
            onSelect: select,
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: body),
        SizedBox(
          width: 168,
          child: SafaehPageIndex(
            title: t('on_this_page'),
            entries: _entries,
            activeId: _active,
            onSelect: select,
          ),
        ),
      ],
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
        Positioned.fill(
          child: NotificationListener<ScrollNotification>(
            onNotification: (_) => true,
            child: ListView(
              key: const ValueKey('page_index_overlay_demo_list'),
              primary: false,
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              children: [
                _DemoSection(
                  key: _alpha,
                  title: t('alpha'),
                  body: t('section_copy'),
                ),
                _DemoSection(
                  key: _beta,
                  title: t('beta'),
                  body: t('section_copy'),
                ),
              ],
            ),
          ),
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
    final cs = Theme.of(context).colorScheme;
    return ColoredBox(
      color: cs.surface,
      child: SafaehContentBand(
        aside: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(t('aside')),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              t('band_copy'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
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
        final tokens = SafaehTheme.of(context);
        final metrics = safaehBandMetrics(
          contentAreaWidth: constraints.maxWidth,
          maxWidth: 420,
        );
        final showRail = tokens.isWide(context) && metrics.endFree >= 176 + 8;
        if (!showRail) {
          return ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  t('aside_copy'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  t('aside'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          );
        }
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
        // Phone preview is a dialog route — canPop is true there and would
        // dismiss the bezel. Only a real pushed page should show back.
        final route = ModalRoute.of(context);
        final canPopPage = route is MaterialPageRoute && route.canPop;
        return Scaffold(
          appBar: SafaehContentAlignedAppBar(
            leftOffset: metrics.leftOffset,
            bandWidth: metrics.bandWidth,
            leading: canPopPage
                ? IconButton(
                    key: const ValueKey('aligned_chrome_back'),
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(safaehArrowBack(context)),
                  )
                : null,
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
  const CameraDemo({super.key, required this.t, this.onDismiss});

  final String Function(String key) t;
  final Future<void> Function()? onDismiss;

  @override
  Widget build(BuildContext context) {
    return SafaehCameraSheetHost(
      onDismiss: onDismiss ?? () async {},
      handleExpandLabel: t('expand'),
      handleCollapseLabel: t('collapse'),
      handleDismissLabel: t('close'),
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
    return Stack(
      fit: StackFit.expand,
      children: [
        CatalogMockCameraFeed(label: t('demo_camera')),
        Positioned.directional(
          textDirection: Directionality.of(context),
          top: 12,
          end: 12,
          child: Row(
            children: [
              IconButton(
                tooltip: sheet.expanded ? t('collapse') : t('expand'),
                onPressed: sheet.toggleExpanded,
                icon: Icon(
                  sheet.expanded
                      ? Icons.close_fullscreen
                      : Icons.open_in_full,
                  color: Colors.white,
                ),
              ),
              IconButton(
                tooltip: t('close'),
                onPressed: sheet.dismiss,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QrOverlayDemo extends StatelessWidget {
  const QrOverlayDemo({super.key, required this.t, this.onDismiss});

  final String Function(String key) t;
  final Future<void> Function()? onDismiss;

  @override
  Widget build(BuildContext context) {
    return SafaehCameraSheetHost(
      onDismiss: onDismiss ?? () async {},
      handleExpandLabel: t('expand'),
      handleCollapseLabel: t('collapse'),
      handleDismissLabel: t('close'),
      builder: (context, sheet) => QrOverlayChrome(sheet: sheet, t: t),
    );
  }
}

class QrOverlayChrome extends StatelessWidget {
  const QrOverlayChrome({super.key, required this.sheet, required this.t});

  final SafaehCameraSheet sheet;
  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return SafaehQrScannerOverlay(
      preview: catalogNeedsMockCamera()
          ? CatalogMockCameraFeed(
              label: t('demo_camera'),
              labelPadding: const EdgeInsetsDirectional.only(
                start: 12,
                top: 64,
              ),
            )
          : null,
      scanLine: const AlwaysStoppedAnimation<double>(0.4),
      title: Text(
        t('scan_invite'),
        style: const TextStyle(color: Colors.white),
      ),
      hint: Text(
        t('point_at_code'),
        style: const TextStyle(color: Color(0xE6FFFFFF)),
      ),
      expanded: sheet.expanded,
      expandTooltip: t('expand'),
      collapseTooltip: t('collapse'),
      onClose: sheet.dismiss,
      onToggleExpanded: sheet.toggleExpanded,
    );
  }
}

class QrMessageDemo extends StatelessWidget {
  const QrMessageDemo({super.key, required this.t, this.onDismiss});

  final String Function(String key) t;
  final Future<void> Function()? onDismiss;

  @override
  Widget build(BuildContext context) {
    return SafaehCameraSheetHost(
      onDismiss: onDismiss ?? () async {},
      handleExpandLabel: t('expand'),
      handleCollapseLabel: t('collapse'),
      handleDismissLabel: t('close'),
      builder: (context, sheet) => QrMessageChrome(sheet: sheet, t: t),
    );
  }
}

class QrMessageChrome extends StatelessWidget {
  const QrMessageChrome({super.key, required this.sheet, required this.t});

  final SafaehCameraSheet sheet;
  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return SafaehQrMessageBody(
      onClose: sheet.dismiss,
      message: Text(
        t('need_camera'),
        style: const TextStyle(color: Colors.white),
      ),
      action: FilledButton(onPressed: () {}, child: Text(t('open_settings'))),
    );
  }
}

class CatalogDemoPage extends StatelessWidget {
  const CatalogDemoPage({
    super.key,
    required this.title,
    required this.child,
    this.padBody = true,
  });

  final String title;
  final Widget child;
  final bool padBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: ModalRoute.of(context)?.canPop == true
            ? IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(safaehArrowBack(context)),
              )
            : null,
        actions: const [SizedBox(width: 104)],
      ),
      body: padBody
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: child,
            )
          : child,
    );
  }
}

Widget _catalogPageBody(String id, String Function(String key) t) {
  switch (id) {
    case 'sheet_shell':
      return SheetShellDemo(t: t);
    case 'sheet_morph':
      return SheetMorphDemo(t: t);
    case 'option_tiles':
      return OptionTilesDemo(t: t);
    case 'status_body':
      return StatusBodyDemo(t: t);
    case 'sidenav':
      return SidenavRailDemo(t: t);
    case 'sidenav_drawer':
      return SidenavDrawerDemo(t: t);
    case 'floating_nav':
      return FloatingNavDemo(t: t);
    case 'page_index':
      return PageIndexRailDemo(t: t);
    case 'page_index_overlay':
      return PageIndexOverlayDemo(t: t);
    case 'content_band':
      return ContentBandDemo(t: t);
    case 'end_aside':
      return EndAsideDemo(t: t);
    default:
      return const SizedBox.shrink();
  }
}

Future<void> _pushDemo(
  BuildContext context,
  String title,
  Widget child, {
  bool padBody = true,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (_) => CatalogDemoPage(
        title: title,
        padBody: padBody,
        child: child,
      ),
    ),
  );
}

/// Opens the same standalone demo the old list catalog used: live sheets for
/// overlay chrome, and a pushed [CatalogDemoPage] for embeddable widgets.
Future<void> openCatalogItem(
  BuildContext context,
  String id,
  String Function(String key) t,
) async {
  switch (id) {
    case 'sheet':
      await showSafaeh<void>(
        context: context,
        title: t('rename'),
        child: Padding(
          padding: kSheetContentPadding,
          child: TextField(decoration: InputDecoration(labelText: t('name'))),
        ),
      );
    case 'picker':
      await showSafaehPicker<int>(
        context: context,
        title: t('settle'),
        selected: 1,
        footer: t('picker_footer'),
        options: [
          SafaehOption(
            value: 1,
            label: t('minimal'),
            subtitle: t('minimal_sub'),
            icon: Icons.bolt_outlined,
          ),
          SafaehOption(
            value: 2,
            label: t('pairs'),
            subtitle: t('pairs_sub'),
            icon: Icons.people_outline,
          ),
        ],
      );
    case 'tile_picker':
      await showSafaehTilePicker<String>(
        context: context,
        title: t('choose_account'),
        selected: 'cash',
        header: Text(t('header_hint')),
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
      );
    case 'multi_picker':
      await showSafaehMultiTilePicker<String>(
        context: context,
        title: t('choose_account'),
        confirmLabel: t('apply'),
        selected: const ['cash'],
        searchHint: t('search_accounts'),
        searchEmptyLabel: t('no_matches'),
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
      );
    case 'confirm':
      await showSafaehConfirm(
        context: context,
        title: t('delete_item'),
        content: t('cannot_undo'),
        confirmLabel: t('delete'),
        cancelLabel: t('cancel'),
        isDestructive: true,
      );
    case 'text_input':
      final value = await showSafaehTextInput(
        context: context,
        title: t('tag_name'),
        doneLabel: t('done'),
        cancelLabel: t('cancel'),
        hint: t('work'),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(value ?? t('dismissed'))));
    case 'sheet_shell':
      await showSafaeh<void>(
        context: context,
        title: t('export_report'),
        child: SheetShellDemo(t: t, interactive: true, popOnAction: true),
      );
    case 'dialog':
      await showSafaehDialog<void>(
        context: context,
        builder: (ctx) {
          final tokens = SafaehTheme.of(ctx);
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.radius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(t('dialog_body')),
            ),
          );
        },
      );
    case 'aligned_chrome':
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => AlignedChromeDemo(t: t)),
      );
    case 'camera':
      await showSafaehCameraSheet<void>(
        context: context,
        handleExpandLabel: t('expand'),
        handleCollapseLabel: t('collapse'),
        handleDismissLabel: t('close'),
        builder: (context, sheet) => MockCameraChild(sheet: sheet, t: t),
      );
    case 'qr_overlay':
      await showSafaehCameraSheet<void>(
        context: context,
        handleExpandLabel: t('expand'),
        handleCollapseLabel: t('collapse'),
        handleDismissLabel: t('close'),
        builder: (context, sheet) => QrOverlayChrome(sheet: sheet, t: t),
      );
    case 'qr_message':
      await showSafaehCameraSheet<void>(
        context: context,
        handleExpandLabel: t('expand'),
        handleCollapseLabel: t('collapse'),
        handleDismissLabel: t('close'),
        builder: (context, sheet) => QrMessageChrome(sheet: sheet, t: t),
      );
    default:
      await _pushDemo(
        context,
        t(id),
        _catalogPageBody(id, t),
        padBody: switch (id) {
          'sidenav' ||
          'sidenav_drawer' ||
          'page_index' ||
          'page_index_overlay' ||
          'floating_nav' =>
            false,
          _ => true,
        },
      );
  }
}

/// Dimmed host page + bottom-docked sheet (compact or center-to-center).
class CatalogPhoneModalStage extends StatelessWidget {
  const CatalogPhoneModalStage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: cs.surfaceContainerLow),
        const ColoredBox(color: Color(0x52000000)),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(width: double.infinity, child: child),
        ),
      ],
    );
  }
}

class PhoneSheetFrame extends StatelessWidget {
  const PhoneSheetFrame({
    super.key,
    required this.title,
    required this.child,
    this.raised = false,
    this.showTitle = true,
  });

  final String title;
  final Widget child;

  /// Taller, still bottom-docked sheet (first-content center at phone center).
  final bool raised;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final radius = SafaehTheme.of(context).radius;
    return SafaehPhoneCenterExtent(
      enabled: raised,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fillHeight =
              raised &&
              constraints.maxHeight.isFinite &&
              constraints.maxHeight < double.infinity;
          return Material(
            color: cs.surfaceContainerLow,
            elevation: 1,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
              side: BorderSide(color: cs.outline),
            ),
            child: Column(
              mainAxisSize: fillHeight
                  ? MainAxisSize.max
                  : MainAxisSize.min,
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
                if (showTitle)
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
        },
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
