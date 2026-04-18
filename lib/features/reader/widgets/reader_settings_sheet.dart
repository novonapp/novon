import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/novon_colors.dart';
import 'reader_settings_section.dart';
import 'reader_slider_tile.dart';
import 'reader_theme_preset_chip.dart';

/// A specialized configuration surface for tailoring the reading experience,
/// facilitating granular adjustments to typography and thematic ambiance.
class ReaderSettingsSheet extends StatefulWidget {
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final Color readerBackground;
  final Color readerText;
  final bool isArabicSource;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<double> onLineHeightChanged;
  final ValueChanged<String> onFontFamilyChanged;
  final void Function(Color background, Color text) onThemeChanged;

  const ReaderSettingsSheet({
    super.key,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.readerBackground,
    required this.readerText,
    required this.isArabicSource,
    required this.onFontSizeChanged,
    required this.onLineHeightChanged,
    required this.onFontFamilyChanged,
    required this.onThemeChanged,
  });

  @override
  State<ReaderSettingsSheet> createState() => _ReaderSettingsSheetState();
}

class _ReaderSettingsSheetState extends State<ReaderSettingsSheet> {
  late double _fontSize;
  late double _lineHeight;
  late String _fontFamily;
  late Color _bg;
  late Color _fg;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.fontSize;
    _lineHeight = widget.lineHeight;
    _fontFamily = widget.fontFamily;
    _bg = widget.readerBackground;
    _fg = widget.readerText;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.56,
      minChildSize: 0.4,
      maxChildSize: 0.86,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: NovonColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: NovonColors.border.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 28,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
          children: [
            _buildHandle(),
            const SizedBox(height: 14),
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildPreview(),
            const SizedBox(height: 18),
            _buildTypographySection(context),
            const SizedBox(height: 12),
            _buildThemeSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: NovonColors.textSecondary.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            NovonColors.primary.withValues(alpha: 0.16),
            NovonColors.accent.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: NovonColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: NovonColors.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: NovonColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Reader settings',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NovonColors.border.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        'Preview: The quick brown fox jumps over the lazy dog.',
        style: GoogleFonts.inter().copyWith(
          color: _fg,
          fontSize: _fontSize.clamp(14, 22),
          height: _lineHeight.clamp(1.4, 2.2),
        ),
      ),
    );
  }

  Widget _buildTypographySection(BuildContext context) {
    return ReaderSettingsSection(
      title: 'Typography',
      icon: Icons.text_fields_rounded,
      child: Column(
        children: [
          ReaderSliderTile(
            label: 'Font Size',
            valueLabel: _fontSize.toStringAsFixed(0),
            slider: Slider(
              value: _fontSize,
              min: 14,
              max: 24,
              divisions: 10,
              onChanged: (v) {
                setState(() => _fontSize = v);
                widget.onFontSizeChanged(v);
              },
            ),
          ),
          ReaderSliderTile(
            label: 'Line Height',
            valueLabel: _lineHeight.toStringAsFixed(1),
            slider: Slider(
              value: _lineHeight,
              min: 1.4,
              max: 2.2,
              divisions: 8,
              onChanged: (v) {
                setState(() => _lineHeight = v);
                widget.onLineHeightChanged(v);
              },
            ),
          ),
          if (widget.isArabicSource) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Arabic Font',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Alexandria', 'El Messiri', 'Lalezar']
                  .map(
                    (f) => ChoiceChip(
                      label: Text(f),
                      selected: _fontFamily == f,
                      selectedColor: NovonColors.primary.withValues(alpha: 0.2),
                      side: BorderSide(
                        color: _fontFamily == f
                            ? NovonColors.primary
                            : NovonColors.border.withValues(alpha: 0.5),
                      ),
                      onSelected: (_) {
                        setState(() => _fontFamily = f);
                        widget.onFontFamilyChanged(f);
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return ReaderSettingsSection(
      title: 'Theme',
      icon: Icons.palette_rounded,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ReaderThemePresetChip(
            label: 'Dark',
            selected: _bg == NovonColors.background,
            onTap: () {
              setState(() {
                _bg = NovonColors.background;
                _fg = NovonColors.textPrimary;
              });
              widget.onThemeChanged(_bg, _fg);
            },
          ),
          ReaderThemePresetChip(
            label: 'Light',
            selected: _bg == const Color(0xFFF7F2E8),
            onTap: () {
              setState(() {
                _bg = const Color(0xFFF7F2E8);
                _fg = const Color(0xFF2A241B);
              });
              widget.onThemeChanged(_bg, _fg);
            },
          ),
          ReaderThemePresetChip(
            label: 'AMOLED',
            selected: _bg == Colors.black,
            onTap: () {
              setState(() {
                _bg = Colors.black;
                _fg = Colors.white;
              });
              widget.onThemeChanged(_bg, _fg);
            },
          ),
        ],
      ),
    );
  }
}
