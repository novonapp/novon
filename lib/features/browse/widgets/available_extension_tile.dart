import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/novon_colors.dart';
import '../../../core/common/models/repo_index.dart';

/// Specifies the operational state of the extension tile action button,
/// determining the available interaction flow.
enum ExtensionTileStatus {
  /// Diagnostic state indicating the extension is not registered on the device.
  install,

  /// Diagnostic state indicating a remote version precedence over the localized instance.
  update,

  /// Diagnostic state indicating localized version parity or precedence.
  installed,
}

/// Specialized list item responsible for representing extensions available within
/// a remote repository index, orchestrating categorical actions for
/// acquisition and synchronization.
class AvailableExtensionTile extends StatefulWidget {
  final RepoExtensionEntry entry;
  final ExtensionTileStatus status;
  final String? installedVersion;
  final Future<void> Function()? onAction;

  const AvailableExtensionTile({
    super.key,
    required this.entry,
    required this.status,
    this.installedVersion,
    required this.onAction,
  });

  @override
  State<AvailableExtensionTile> createState() => _AvailableExtensionTileState();
}

class _AvailableExtensionTileState extends State<AvailableExtensionTile> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.status == ExtensionTileStatus.update;
    return Card(
      margin: EdgeInsets.zero,
      color: isUpdate
          ? NovonColors.warning.withValues(alpha: 0.06)
          : NovonColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUpdate
              ? NovonColors.warning.withValues(alpha: 0.3)
              : NovonColors.divider,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 48,
                height: 48,
                color: NovonColors.surfaceVariant,
                child:
                    widget.entry.icon != null && widget.entry.icon!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: widget.entry.icon!,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Icon(
                          Icons.extension_rounded,
                          color: NovonColors.textTertiary,
                        ),
                      )
                    : Icon(
                        Icons.extension_rounded,
                        color: NovonColors.textTertiary,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.entry.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (isUpdate && widget.installedVersion != null) ...[
                        Text(
                          'v${widget.installedVersion}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: NovonColors.textTertiary,
                                decoration: TextDecoration.lineThrough,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: NovonColors.warning,
                          ),
                        ),
                      ],
                      Text(
                        'v${widget.entry.version}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isUpdate
                              ? NovonColors.warning
                              : NovonColors.textSecondary,
                          fontWeight: isUpdate
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
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
                          widget.entry.lang.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: NovonColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  /// Orchestrates the assembly of the primary action interface based on
  /// the current operational status and localized loading state.
  Widget _buildActionButton() {
    if (_loading) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(NovonColors.primary),
        ),
      );
    }
    switch (widget.status) {
      case ExtensionTileStatus.update:
        return SizedBox(
          height: 32,
          child: FilledButton.icon(
            onPressed: () async {
              setState(() => _loading = true);
              try {
                await widget.onAction?.call();
              } finally {
                if (mounted) setState(() => _loading = false);
              }
            },
            icon: const Icon(Icons.system_update_rounded, size: 16),
            label: const Text('Update', style: TextStyle(fontSize: 12)),
            style: FilledButton.styleFrom(
              backgroundColor: NovonColors.warning,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      case ExtensionTileStatus.install:
        return IconButton(
          icon: Icon(Icons.download_rounded, color: NovonColors.primary),
          onPressed: () async {
            setState(() => _loading = true);
            try {
              await widget.onAction?.call();
            } finally {
              if (mounted) setState(() => _loading = false);
            }
          },
        );
      case ExtensionTileStatus.installed:
        return Icon(
          Icons.check_circle_rounded,
          color: NovonColors.success.withValues(alpha: 0.6),
          size: 24,
        );
    }
  }
}
