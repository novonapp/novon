import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'settings_template.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// Configuration interface for content discovery parameters, facilitating granular
/// control over extension repositories, linguistic filters, and search behavior.
class BrowseSettingsScreen extends StatelessWidget {
  const BrowseSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreenTemplate(
      title: 'Browse',
      boxName: HiveBox.app,
      buildSettings: (box, update) {
        final langs =
            (box.get(HiveKeys.preferredLanguages, defaultValue: ['en']) as List)
                .cast<String>();
        final repos =
            (box.get(
                      HiveKeys.extensionRepos,
                      defaultValue: [
                        'https://raw.githubusercontent.com/novonapp/extensions/main/index.json',
                      ],
                    )
                    as List)
                .cast<String>();
        final autoUpdate =
            box.get(HiveKeys.extensionAutoUpdate, defaultValue: 'wifi_only')
                as String;
        final searchTimeout =
            box.get(HiveKeys.globalSearchTimeoutSec, defaultValue: 15) as int;
        final searchPerSource =
            box.get(HiveKeys.globalSearchPerSource, defaultValue: 5) as int;

        return [
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: const Text('Language Filter'),
            subtitle: Text('Selected: ${langs.join(', ')}'),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: () => _showLanguageDialog(context, langs, update),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.no_adult_content_rounded),
            title: const Text('Show NSFW Sources'),
            value: box.get(HiveKeys.showNsfwExtensions, defaultValue: false),
            onChanged: (val) => update(HiveKeys.showNsfwExtensions, val),
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: const Text('Global Search Timeout'),
            subtitle: Text('${searchTimeout}s'),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: () => _showIntDialog(
              context,
              title: 'Search Timeout (seconds)',
              min: 5,
              max: 60,
              current: searchTimeout,
              onSave: (v) => update(HiveKeys.globalSearchTimeoutSec, v),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.format_list_numbered_rounded),
            title: const Text('Results per Source'),
            subtitle: Text('$searchPerSource per source'),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: () => _showIntDialog(
              context,
              title: 'Results per Source',
              min: 1,
              max: 30,
              current: searchPerSource,
              onSave: (v) => update(HiveKeys.globalSearchPerSource, v),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.source_rounded),
            title: const Text('Extension Repositories'),
            subtitle: Text('${repos.length} repo(s) configured'),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: () => _showRepoDialog(context, repos, update),
          ),
          ListTile(
            leading: const Icon(Icons.system_update_alt_rounded),
            title: const Text('Auto-Update Extensions'),
            subtitle: Text(_autoUpdateLabel(autoUpdate)),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: () => _showAutoUpdateDialog(context, autoUpdate, update),
          ),
        ];
      },
    );
  }

  String _autoUpdateLabel(String val) {
    switch (val) {
      case 'wifi_only':
        return 'Wi-Fi only';
      case 'always':
        return 'Always';
      case 'never':
        return 'Never';
      default:
        return val;
    }
  }

  /// Displays a selection interface for defining preferred linguistic metadata,
  /// allowing users to segregate content discovery by source language.
  void _showLanguageDialog(
    BuildContext context,
    List<String> current,
    void Function(String, dynamic) update,
  ) {
    final allLangs = {
      'en': '🇺🇸 English',
      'zh-Hans': '🇨🇳 Chinese Simplified',
      'ko': '🇰🇷 Korean',
      'ja': '🇯🇵 Japanese',
      'fr': '🇫🇷 French',
      'es': '🇪🇸 Spanish',
      'de': '🇩🇪 German',
      'pt': '🇧🇷 Portuguese',
      'ru': '🇷🇺 Russian',
      'ar': '🇸🇦 Arabic',
      'it': '🇮🇹 Italian',
      'tr': '🇹🇷 Turkish',
    };
    final selected = Set<String>.from(current);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setState) => AlertDialog(
          title: const Text('Language Filter'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: allLangs.entries.map((e) {
                return CheckboxListTile(
                  title: Text(e.value),
                  value: selected.contains(e.key),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        selected.add(e.key);
                      } else {
                        selected.remove(e.key);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                update(
                  HiveKeys.preferredLanguages,
                  selected.isEmpty ? ['en'] : selected.toList(),
                );
                ctx.pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  /// Facilitates the dynamic management of extension source indices, supporting
  /// the addition and removal of remote repository manifest URLs.
  void _showRepoDialog(
    BuildContext context,
    List<String> repos,
    void Function(String, dynamic) update,
  ) {
    final mutable = List<String>.from(repos);
    final tc = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setState) => AlertDialog(
          title: const Text('Extension Repositories'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...mutable.asMap().entries.map(
                  (e) => ListTile(
                    dense: true,
                    title: Text(
                      e.value,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        size: 18,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() => mutable.removeAt(e.key));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tc,
                        decoration: const InputDecoration(
                          hintText: 'https://...',
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        final url = tc.text.trim();
                        if (url.isNotEmpty && !mutable.contains(url)) {
                          setState(() {
                            mutable.add(url);
                            tc.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                update(HiveKeys.extensionRepos, List<String>.from(mutable));
                ctx.pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAutoUpdateDialog(
    BuildContext context,
    String current,
    void Function(String, dynamic) update,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Auto-Update Extensions'),
        children: [
          RadioGroup(
            groupValue: current,
            onChanged: (v) {
              update(HiveKeys.extensionAutoUpdate, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: const Text('Wi-Fi only'),
              value: 'wifi_only',
            ),
          ),
          RadioGroup(
            groupValue: current,
            onChanged: (v) {
              update(HiveKeys.extensionAutoUpdate, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: const Text('Always (any connection)'),
              value: 'always',
            ),
          ),
          RadioGroup(
            groupValue: current,
            onChanged: (v) {
              update(HiveKeys.extensionAutoUpdate, v!);
              ctx.pop();
            },
            child: RadioListTile<String>(
              title: const Text('Never (manual only)'),
              value: 'never',
            ),
          ),
        ],
      ),
    );
  }

  void _showIntDialog(
    BuildContext context, {
    required String title,
    required int min,
    required int max,
    required int current,
    required ValueChanged<int> onSave,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => _IntPickerDialog(
        title: title,
        min: min,
        max: max,
        current: current,
        onSave: onSave,
      ),
    );
  }
}

class _IntPickerDialog extends StatefulWidget {
  final String title;
  final int min;
  final int max;
  final int current;
  final ValueChanged<int> onSave;

  const _IntPickerDialog({
    required this.title,
    required this.min,
    required this.max,
    required this.current,
    required this.onSave,
  });

  @override
  State<_IntPickerDialog> createState() => _IntPickerDialogState();
}

class _IntPickerDialogState extends State<_IntPickerDialog> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: _value > widget.min
                ? () => setState(() => _value--)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '$_value',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _value < widget.max
                ? () => setState(() => _value++)
                : null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(_value);
            context.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
