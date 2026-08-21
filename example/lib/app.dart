import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:safaeh/safaeh.dart';

import 'catalog.dart';
import 'pages.dart';

class SafaehExampleApp extends StatefulWidget {
  const SafaehExampleApp({
    super.key,
    this.initialLocale = 'en',
    this.initialThemeMode = ThemeMode.light,
  });

  final String initialLocale;
  final ThemeMode initialThemeMode;

  @override
  State<SafaehExampleApp> createState() => _SafaehExampleAppState();
}

class _SafaehExampleAppState extends State<SafaehExampleApp> {
  late String _locale;
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    _themeMode = widget.initialThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF8B6914);
    return SafaehTheme(
      data: const SafaehThemeData(
        tabletBreakpoint: 600,
        dialogMaxWidth: 560,
        contentMaxWidth: 600,
      ),
      child: MaterialApp(
        title: translateCatalog('app_title', _locale),
        debugShowCheckedModeBanner: false,
        locale: Locale(_locale),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: seed),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seed,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: _themeMode,
        home: CatalogHome(
          localeCode: _locale,
          themeMode: _themeMode,
          onToggleLocale: () => setState(() {
            _locale = _locale == 'en' ? 'ar' : 'en';
          }),
          onToggleTheme: () => setState(() {
            _themeMode = _themeMode == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
          }),
        ),
      ),
    );
  }
}

class CatalogHome extends StatelessWidget {
  const CatalogHome({
    super.key,
    required this.localeCode,
    required this.themeMode,
    required this.onToggleLocale,
    required this.onToggleTheme,
  });

  final String localeCode;
  final ThemeMode themeMode;
  final VoidCallback onToggleLocale;
  final VoidCallback onToggleTheme;

  String t(String key) => translateCatalog(key, localeCode);

  @override
  Widget build(BuildContext context) {
    final dark = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('app_title')),
        actions: [
          TextButton(
            key: const ValueKey('language_toggle'),
            onPressed: onToggleLocale,
            child: Text(t('language_toggle')),
          ),
          TextButton(
            key: const ValueKey('theme_toggle'),
            onPressed: onToggleTheme,
            child: Text(dark ? t('theme_toggle_light') : t('theme_toggle')),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (final item in catalogItems)
            ListTile(
              key: ValueKey('catalog_${item.id}'),
              title: Text(t(item.titleKey)),
              subtitle: item.subtitleKey == null
                  ? null
                  : Text(t(item.subtitleKey!)),
              onTap: () => openCatalogItem(context, item.id, t),
            ),
        ],
      ),
    );
  }
}

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
    case 'confirm':
      await showSafaehConfirm(
        context: context,
        title: t('delete_item'),
        content: t('cannot_undo'),
        confirmLabel: t('delete'),
        cancelLabel: t('cancel'),
        isDestructive: true,
      );
    case 'sheet_morph':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => SheetMorphPage(t: t)));
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
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => SheetShellPage(t: t)));
    case 'option_tiles':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => OptionTilesPage(t: t)));
    case 'dialog':
      await showSafaehDialog<void>(
        context: context,
        builder: (ctx) => Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(t('dialog_body')),
          ),
        ),
      );
    case 'sidenav':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => SidenavRailPage(t: t)));
    case 'sidenav_drawer':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => SidenavDrawerPage(t: t)));
    case 'floating_nav':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => FloatingNavPage(t: t)));
    case 'page_index':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => PageIndexRailPage(t: t)));
    case 'page_index_overlay':
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => PageIndexOverlayPage(t: t)),
      );
    case 'content_band':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => ContentBandPage(t: t)));
    case 'end_aside':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => EndAsidePage(t: t)));
    case 'aligned_chrome':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => AlignedChromePage(t: t)));
    case 'camera':
      await showSafaehCameraSheet<void>(
        context: context,
        builder: (context, sheet) => MockCameraChild(sheet: sheet, t: t),
      );
    case 'qr_overlay':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => QrOverlayPage(t: t)));
    case 'qr_message':
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => QrMessagePage(t: t)));
  }
}
