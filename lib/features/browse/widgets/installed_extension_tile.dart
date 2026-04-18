import 'dart:io';
import 'package:flutter/material.dart';
import 'package:novon/core/services/storage_path_service.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/common/models/extension_manifest.dart';

/// Dedicated UI component for representing localized extension configurations,
/// orchestrating metadata rendering and facilitating administrative
/// lifecycle operations such as deinstallation.
class InstalledExtensionTile extends StatelessWidget {
  final ExtensionManifest manifest;
  final VoidCallback onTap;
  final VoidCallback onUninstall;

  const InstalledExtensionTile({
    super.key,
    required this.manifest,
    required this.onTap,
    required this.onUninstall,
  });

  @override
  Widget build(BuildContext context) {
    final iconPath = manifest.icon;
    return Card(
      margin: EdgeInsets.zero,
      color: NovonColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: NovonColors.divider),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FutureBuilder<bool>(
                  future: File(
                    '${StoragePathService.instance.storagePath}/extensions/${manifest.id}/$iconPath',
                  ).exists(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      return Image.file(
                        File(
                          '${StoragePathService.instance.storagePath}/extensions/${manifest.id}/$iconPath',
                        ),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      );
                    }
                    return Container(
                      width: 48,
                      height: 48,
                      color: NovonColors.surfaceVariant,
                      child: Icon(
                        Icons.extension_rounded,
                        color: NovonColors.textTertiary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manifest.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'v${manifest.version}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: NovonColors.textSecondary),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: NovonColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            manifest.lang.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: NovonColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (manifest.nsfw) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: NovonColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'NSFW',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: NovonColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'uninstall') onUninstall();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'uninstall',
                    child: Text('Uninstall'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
