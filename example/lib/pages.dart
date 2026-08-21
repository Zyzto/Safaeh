import 'package:flutter/material.dart';
import 'package:safaeh/safaeh.dart';

class OptionTilesPage extends StatelessWidget {
  const OptionTilesPage({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('option_tiles'))),
      body: SafaehOptionList(
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
      ),
    );
  }
}

class SidenavRailPage extends StatefulWidget {
  const SidenavRailPage({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<SidenavRailPage> createState() => _SidenavRailPageState();
}

class _SidenavRailPageState extends State<SidenavRailPage> {
  var _collapsed = false;
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return Scaffold(
      body: Row(
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
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(t('toggle_rail')),
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('Back'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SidenavDrawerPage extends StatefulWidget {
  const SidenavDrawerPage({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<SidenavDrawerPage> createState() => _SidenavDrawerPageState();
}

class _SidenavDrawerPageState extends State<SidenavDrawerPage> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return Scaffold(
      appBar: AppBar(title: Text(t('sidenav_drawer'))),
      drawer: Drawer(
        child: SafaehSidenav(
          asDrawer: true,
          title: t('app_title'),
          selectedIndex: _index,
          onDestinationSelected: (i) {
            setState(() => _index = i);
            Navigator.of(context).pop();
          },
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
      ),
      body: Center(child: Text('${t('selected_index')} $_index')),
    );
  }
}

class FloatingNavPage extends StatefulWidget {
  const FloatingNavPage({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<FloatingNavPage> createState() => _FloatingNavPageState();
}

class _FloatingNavPageState extends State<FloatingNavPage> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return Scaffold(
      appBar: AppBar(title: Text(t('floating_nav'))),
      body: Center(child: Text('${t('selected_index')} $_index')),
      bottomNavigationBar: SafaehFloatingNavBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
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
    );
  }
}

class PageIndexRailPage extends StatefulWidget {
  const PageIndexRailPage({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<PageIndexRailPage> createState() => _PageIndexRailPageState();
}

class _PageIndexRailPageState extends State<PageIndexRailPage> {
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

  Future<void> _select(SafaehPageIndexEntry entry) async {
    setState(() => _active = entry.id);
    await scrollToPageSection(entry.key, controller: _scroll);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return Scaffold(
      appBar: AppBar(title: Text(t('page_index'))),
      body: NotificationListener<ScrollNotification>(
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
                padding: const EdgeInsets.all(24),
                children: [
                  SizedBox(key: _alpha, height: 320, child: Text(t('alpha'))),
                  SizedBox(key: _beta, height: 320, child: Text(t('beta'))),
                  SizedBox(key: _gamma, height: 320, child: Text(t('gamma'))),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              child: SafaehPageIndex(
                title: t('on_this_page'),
                entries: _entries,
                activeId: _active,
                onSelect: _select,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageIndexOverlayPage extends StatefulWidget {
  const PageIndexOverlayPage({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<PageIndexOverlayPage> createState() => _PageIndexOverlayPageState();
}

class _PageIndexOverlayPageState extends State<PageIndexOverlayPage> {
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
  Widget build(BuildContext context) {
    final t = widget.t;
    return Scaffold(
      appBar: AppBar(title: Text(t('page_index_overlay'))),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(24),
            children: [
              SizedBox(key: _alpha, height: 280, child: Text(t('alpha'))),
              SizedBox(key: _beta, height: 280, child: Text(t('beta'))),
            ],
          ),
          SafaehPageIndexOverlay(
            title: t('on_this_page'),
            entries: _entries,
            activeId: _active,
            onSelect: (entry) => setState(() => _active = entry.id),
          ),
        ],
      ),
    );
  }
}

class ContentBandPage extends StatelessWidget {
  const ContentBandPage({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('content_band'))),
      body: SafaehContentBand(
        aside: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(t('aside')),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [Text(t('band_copy'))],
        ),
      ),
    );
  }
}

class EndAsidePage extends StatelessWidget {
  const EndAsidePage({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('end_aside'))),
      body: LayoutBuilder(
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
              padding: const EdgeInsets.all(24),
              child: Text(t('aside_copy')),
            ),
          );
        },
      ),
    );
  }
}

class AlignedChromePage extends StatelessWidget {
  const AlignedChromePage({super.key, required this.t});

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
            leading: const BackButton(),
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
            padding: EdgeInsets.fromLTRB(metrics.leftOffset, 24, 24, 24),
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
              style: const TextStyle(color: Colors.white70),
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

class QrOverlayPage extends StatelessWidget {
  const QrOverlayPage({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafaehQrScannerOverlay(
        scanLine: const AlwaysStoppedAnimation<double>(0.4),
        title: Text(
          t('scan_invite'),
          style: const TextStyle(color: Colors.white),
        ),
        hint: Text(
          t('point_at_code'),
          style: const TextStyle(color: Colors.white70),
        ),
        expanded: false,
        expandTooltip: t('expand'),
        collapseTooltip: t('collapse'),
        onClose: () => Navigator.of(context).pop(),
        onToggleExpanded: () {},
      ),
    );
  }
}

class QrMessagePage extends StatelessWidget {
  const QrMessagePage({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafaehQrMessageBody(
        onClose: () => Navigator.of(context).pop(),
        message: Text(
          t('need_camera'),
          style: const TextStyle(color: Colors.white),
        ),
        action: FilledButton(onPressed: () {}, child: Text(t('open_settings'))),
      ),
    );
  }
}

class SheetMorphPage extends StatelessWidget {
  const SheetMorphPage({super.key, required this.t});

  final String Function(String key) t;

  Widget _preview(
    BuildContext context, {
    required double width,
    required String label,
  }) {
    return SizedBox(
      width: width,
      height: 520,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(size: Size(width, 520)),
        child: ClipRect(
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (ctx) => Scaffold(
                appBar: AppBar(title: Text(label)),
                body: Center(
                  child: FilledButton(
                    onPressed: () => showSafaeh<void>(
                      context: ctx,
                      title: t('rename'),
                      child: Padding(
                        padding: kSheetContentPadding,
                        child: Text(t('sheet_sub')),
                      ),
                    ),
                    child: Text(t('sheet')),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('sheet_morph'))),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _preview(context, width: 400, label: '400'),
            const SizedBox(width: 16),
            _preview(context, width: 900, label: '900'),
          ],
        ),
      ),
    );
  }
}

class SheetShellPage extends StatelessWidget {
  const SheetShellPage({super.key, required this.t});

  final String Function(String key) t;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    return Scaffold(
      appBar: AppBar(title: Text(t('sheet_shell'))),
      body: buildSafaehSheetShell(
        title: Text(t('sheet_shell'), style: titleStyle),
        body: Text(t('shell_body')),
        actions: [
          TextButton(onPressed: () {}, child: Text(t('cancel'))),
          FilledButton(onPressed: () {}, child: Text(t('save'))),
        ],
      ),
    );
  }
}
