import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/theme/theme_provider.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// An environmental configuration interface allowing for the granular
/// personalization of the application's visual identity and thematic ambiance.
class AppearanceSettingsScreen extends ConsumerStatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  ConsumerState<AppearanceSettingsScreen> createState() =>
      _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState
    extends ConsumerState<AppearanceSettingsScreen> {
  late Box _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box(HiveBox.app);
  }

  void _update(String key, dynamic value) {
    _box.put(key, value);
    setState(() {});
  }

  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ThemePickerSheet(
        currentTheme: _box.get(HiveKeys.appTheme, defaultValue: 'dark'),
        onSelected: (val) {
          ref.read(themeProvider.notifier).updateTheme(val);
          _update(HiveKeys.appTheme, val);
          ctx.pop();
        },
      ),
    );
  }

  void _confirmResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Defaults'),
        content: const Text(
          'Are you sure you want to restore the default color scheme? This will wipe your custom Primary, Background, and Surface palette overrides.',
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(themeProvider.notifier).resetColors();
              setState(() {});
              ctx.pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: NovonColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => GenericColorPickerSheet(
        title: 'Primary / Accent Color',
        currentColor:
            _box.get(HiveKeys.accentColor, defaultValue: 0xFF6C63FF) is int
            ? _box.get(HiveKeys.accentColor, defaultValue: 0xFF6C63FF)
            : 0xFF6C63FF,
        onSelected: (val) {
          ref.read(themeProvider.notifier).updateAccentColor(Color(val));
          _update(HiveKeys.accentColor, val);
          ctx.pop();
        },
      ),
    );
  }

  void _showBackgroundPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => GenericColorPickerSheet(
        title: 'Background Color',
        currentColor:
            _box.get(HiveKeys.customBgColor, defaultValue: 0xFF0D0D0F) is int
            ? _box.get(HiveKeys.customBgColor, defaultValue: 0xFF0D0D0F)
            : 0xFF0D0D0F,
        onSelected: (val) {
          ref.read(themeProvider.notifier).updateBackgroundColor(Color(val));
          _update(HiveKeys.customBgColor, val);
          ctx.pop();
        },
      ),
    );
  }

  void _showSurfacePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => GenericColorPickerSheet(
        title: 'Surface Color',
        currentColor:
            _box.get(HiveKeys.customSurfaceColor, defaultValue: 0xFF16161A)
                is int
            ? _box.get(HiveKeys.customSurfaceColor, defaultValue: 0xFF16161A)
            : 0xFF16161A,
        onSelected: (val) {
          ref.read(themeProvider.notifier).updateSurfaceColor(Color(val));
          _update(HiveKeys.customSurfaceColor, val);
          ctx.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('App Theme'),
            subtitle: Text(_box.get(HiveKeys.appTheme, defaultValue: 'dark')),
            onTap: _showThemePicker,
          ),
          ListTile(
            title: const Text('Primary/Accent Color'),
            subtitle: const Text('Tap to change'),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Color(
                  _box.get(HiveKeys.accentColor, defaultValue: 0xFF6C63FF)
                      as int,
                ),
                shape: BoxShape.circle,
              ),
            ),
            onTap: _showColorPicker,
          ),
          ListTile(
            title: const Text('Background Color'),
            subtitle: const Text('Tap to change'),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Color(
                  _box.get(HiveKeys.customBgColor, defaultValue: 0xFF0D0D0F)
                      as int,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
            ),
            onTap: _showBackgroundPicker,
          ),
          ListTile(
            title: const Text('Surface Color'),
            subtitle: const Text('Tap to change'),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Color(
                  _box.get(
                        HiveKeys.customSurfaceColor,
                        defaultValue: 0xFF16161A,
                      )
                      as int,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
            ),
            onTap: _showSurfacePicker,
          ),

          const Divider(),

          SwitchListTile(
            title: const Text('Show Update Count Badge'),
            value: _box.get(HiveKeys.showUpdateBadge, defaultValue: true),
            onChanged: (val) => _update(HiveKeys.showUpdateBadge, val),
          ),
          ListTile(
            title: Text(
              'Restore Default Colors',
              style: TextStyle(color: NovonColors.error),
            ),
            leading: Icon(Icons.restore, color: NovonColors.error),
            onTap: () => _confirmResetDialog(context),
          ),
        ],
      ),
    );
  }
}

/// A specialized selection surface for mapping semantic theme identifiers
/// to structural application style objects.
class ThemePickerSheet extends StatelessWidget {
  final String currentTheme;
  final ValueChanged<String> onSelected;

  const ThemePickerSheet({
    super.key,
    required this.currentTheme,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'App Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: const Text('Light'),
            trailing: currentTheme == 'light'
                ? Icon(Icons.check, color: NovonColors.primary)
                : null,
            onTap: () => onSelected('light'),
          ),
          ListTile(
            title: const Text('Dark'),
            trailing: currentTheme == 'dark'
                ? Icon(Icons.check, color: NovonColors.primary)
                : null,
            onTap: () => onSelected('dark'),
          ),
          ListTile(
            title: const Text('AMOLED'),
            trailing: currentTheme == 'amoled'
                ? Icon(Icons.check, color: NovonColors.primary)
                : null,
            onTap: () => onSelected('amoled'),
          ),
          ListTile(
            title: const Text('System Default'),
            trailing: currentTheme == 'system'
                ? Icon(Icons.check, color: NovonColors.primary)
                : null,
            onTap: () => onSelected('system'),
          ),
        ],
      ),
    );
  }
}

/// A generic polymorphic widget providing a dual-mode interface for
/// predefined palette selection and arbitrary color definition.
class GenericColorPickerSheet extends StatefulWidget {
  final String title;
  final int currentColor;
  final ValueChanged<int> onSelected;

  const GenericColorPickerSheet({
    super.key,
    required this.title,
    required this.currentColor,
    required this.onSelected,
  });

  @override
  State<GenericColorPickerSheet> createState() =>
      _GenericColorPickerSheetState();
}

class _GenericColorPickerSheetState extends State<GenericColorPickerSheet> {
  late Color pickerColor;

  final List<int> presets = [
    0xFF1A3A5C,
    0xFF009688,
    0xFF9C27B0,
    0xFFE53935,
    0xFFFF9800,
    0xFFFFB300,
    0xFF4CAF50,
    0xFFE91E63,
    0xFF3F51B5,
    0xFF00BCD4,
    0xFF607D8B,
    0xFFFFFFFF,
  ];

  @override
  void initState() {
    super.initState();
    pickerColor = Color(widget.currentColor);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: presets
                .map(
                  (color) => GestureDetector(
                    onTap: () => widget.onSelected(color),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                        border: color == widget.currentColor
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          const Text('Custom', style: TextStyle(fontWeight: FontWeight.bold)),
          ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (c) => setState(() => pickerColor = c),
            pickerAreaHeightPercent: 0.7,
            enableAlpha: false,
          ),
          ElevatedButton(
            onPressed: () => widget.onSelected(pickerColor.toARGB32()),
            child: const Text('Save Custom Color'),
          ),
        ],
      ),
    );
  }
}
