import 'package:flutter/material.dart';

import 'catalog.dart';
import 'pages.dart';

class CatalogGallery extends StatefulWidget {
  const CatalogGallery({super.key, required this.t});

  final String Function(String key) t;

  @override
  State<CatalogGallery> createState() => CatalogGalleryState();
}

class CatalogGalleryState extends State<CatalogGallery> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    return ListView.separated(
      key: const ValueKey('catalog_gallery'),
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: catalogItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final item = catalogItems[index];
        return GallerySection(
          key: ValueKey('catalog_${item.id}'),
          title: t(item.titleKey),
          subtitle: item.subtitleKey == null ? null : t(item.subtitleKey!),
          child: galleryPreview(item.id, t),
        );
      },
    );
  }
}

class GallerySection extends StatelessWidget {
  const GallerySection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outline),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: child,
          ),
        ),
      ],
    );
  }
}

Widget galleryPreview(String id, String Function(String key) t) {
  switch (id) {
    case 'sheet':
      return AdaptiveSheetDemo(t: t);
    case 'picker':
      return CardPickerDemo(t: t);
    case 'tile_picker':
      return TilePickerDemo(t: t);
    case 'confirm':
      return ConfirmDemo(t: t);
    case 'text_input':
      return TextInputDemo(t: t);
    case 'sheet_shell':
      return SheetShellDemo(t: t);
    case 'sheet_morph':
      return SheetMorphDemo(t: t);
    case 'option_tiles':
      return OptionTilesDemo(t: t);
    case 'dialog':
      return DialogDemo(t: t);
    case 'sidenav':
      return SizedBox(height: 360, child: SidenavRailDemo(t: t));
    case 'sidenav_drawer':
      return SizedBox(height: 360, child: SidenavDrawerDemo(t: t));
    case 'floating_nav':
      return FloatingNavDemo(t: t);
    case 'page_index':
      return SizedBox(height: 280, child: PageIndexRailDemo(t: t));
    case 'page_index_overlay':
      return SizedBox(height: 320, child: PageIndexOverlayDemo(t: t));
    case 'content_band':
      return SizedBox(height: 160, child: ContentBandDemo(t: t));
    case 'end_aside':
      return SizedBox(height: 140, child: EndAsideDemo(t: t));
    case 'aligned_chrome':
      return SizedBox(height: 220, child: AlignedChromeDemo(t: t));
    case 'camera':
      return SizedBox(height: 300, child: CameraDemo(t: t));
    case 'qr_overlay':
      return SizedBox(height: 360, child: QrOverlayDemo(t: t));
    case 'qr_message':
      return SizedBox(height: 280, child: QrMessageDemo(t: t));
    default:
      return const SizedBox.shrink();
  }
}
