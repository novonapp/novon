import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'settings_template.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// A configuration interface for defining global consumption parameters,
/// including typography presets, navigation models, and environmental behavior.
class ReaderSettingsScreen extends StatelessWidget {
  const ReaderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreenTemplate(
      title: 'Reader',
      boxName: HiveBox.reader,
      buildSettings: (box, update) {
        return [
          ListTile(
            title: const Text('Default Reading Mode'),
            subtitle: Text(
              box.get(
                HiveKeys.defaultReadingMode,
                defaultValue: 'vertical_scroll',
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text('Reading Mode'),
                  children: ['vertical_scroll', 'paged', 'webtoon']
                      .map(
                        (p) => SimpleDialogOption(
                          onPressed: () {
                            update(HiveKeys.defaultReadingMode, p);
                            ctx.pop();
                          },
                          child: Text(p),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Default Font Family'),
            subtitle: Text(
              box.get(HiveKeys.readerFontFamily, defaultValue: 'Alexandria'),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text('Font Family'),
                  children: ['Alexandria', 'El Messiri', 'Lalezar']
                      .map(
                        (p) => SimpleDialogOption(
                          onPressed: () {
                            update(HiveKeys.readerFontFamily, p);
                            ctx.pop();
                          },
                          child: Text(p),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Font Size'),
            subtitle: Text(
              box.get(HiveKeys.readerFontSize, defaultValue: 18).toString(),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    int val = box.get(
                      HiveKeys.readerFontSize,
                      defaultValue: 18,
                    );
                    if (val > 10) {
                      update(HiveKeys.readerFontSize, val - 1);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    int val = box.get(
                      HiveKeys.readerFontSize,
                      defaultValue: 18,
                    );
                    if (val < 36) {
                      update(HiveKeys.readerFontSize, val + 1);
                    }
                  },
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text('Keep Screen On'),
            value: box.get(HiveKeys.readerKeepScreenOn, defaultValue: true),
            onChanged: (val) => update(HiveKeys.readerKeepScreenOn, val),
          ),
          SwitchListTile(
            title: const Text('Full Screen Mode'),
            value: box.get(HiveKeys.readerFullscreen, defaultValue: true),
            onChanged: (val) => update(HiveKeys.readerFullscreen, val),
          ),
          SwitchListTile(
            title: const Text('Show Reading Progress Bar'),
            value: box.get(HiveKeys.readerShowProgressBar, defaultValue: true),
            onChanged: (val) => update(HiveKeys.readerShowProgressBar, val),
          ),
          SwitchListTile(
            title: const Text('Volume Button Navigation'),
            value: box.get(HiveKeys.readerVolumeButtons, defaultValue: false),
            onChanged: (val) => update(HiveKeys.readerVolumeButtons, val),
          ),
        ];
      },
    );
  }
}
