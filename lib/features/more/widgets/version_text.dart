import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/config/app_config.dart';

/// Specialized reactive component responsible for orchestrating the resolution
/// and presentation of application version credentials.
class VersionText extends StatelessWidget {
  const VersionText({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.hasData
            ? AppConfig.formatVersion(
                snapshot.data!.version,
                snapshot.data!.buildNumber,
              )
            : 'Loading...';

        return Text(
          '$version • Open Source Novel Reader',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.74),
          ),
        );
      },
    );
  }
}
