import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'settings_template.dart';
import 'package:novon/core/common/constants/hive_constants.dart';

/// Configuration interface for managing background synchronization frequencies
/// and orchestrating application-wide notification preferences.
class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  static const _intervals = [
    ('30m', '30 minutes'),
    ('1h', '1 hour'),
    ('3h', '3 hours'),
    ('6h', '6 hours'),
    ('12h', '12 hours'),
    ('24h', '24 hours'),
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsScreenTemplate(
      title: 'Notifications',
      boxName: HiveBox.app,
      buildSettings: (box, update) {
        final interval =
            box.get(HiveKeys.updateCheckInterval, defaultValue: '6h') as String;
        final intervalLabel = _intervals
            .firstWhere(
              (e) => e.$1 == interval,
              orElse: () => (interval, interval),
            )
            .$2;

        return [
          SwitchListTile(
            secondary: const Icon(Icons.menu_book_rounded),
            title: const Text('Chapter Update Notifications'),
            subtitle: const Text('Alert when new chapters are found'),
            value: box.get(HiveKeys.notifChapterUpdates, defaultValue: true),
            onChanged: (val) => update(HiveKeys.notifChapterUpdates, val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.download_rounded),
            title: const Text('Download Notifications'),
            subtitle: const Text('Alert when downloads complete or fail'),
            value: box.get(HiveKeys.notifDownloads, defaultValue: true),
            onChanged: (val) => update(HiveKeys.notifDownloads, val),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.schedule_rounded),
            title: const Text('Update Check Frequency'),
            subtitle: Text(intervalLabel),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text('Update Check Frequency'),
                  children: _intervals.map((e) {
                    return RadioGroup(
                      groupValue: interval,
                      onChanged: (v) {
                        update(HiveKeys.updateCheckInterval, v!);
                        ctx.pop();
                      },
                      child: RadioListTile<String>(
                        title: Text(e.$2),
                        value: e.$1,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.wifi_rounded),
            title: const Text('Restrict Update Checks to Wi-Fi'),
            value: box.get(HiveKeys.updateCheckWifiOnly, defaultValue: true),
            onChanged: (val) => update(HiveKeys.updateCheckWifiOnly, val),
          ),
        ];
      },
    );
  }
}
