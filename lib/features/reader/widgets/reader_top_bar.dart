import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';

/// Top overlay bar shown when the reader controls are toggled visible.
/// Displays back button, novel title, chapter title, progress %, and action icons.
class ReaderTopBar extends StatelessWidget {
  final String novelTitle;
  final String chapterTitle;
  final ValueNotifier<double> progressNotifier;
  final Animation<double> controlsOpacity;
  final VoidCallback onBack;
  final VoidCallback onWebView;
  final VoidCallback onBookmark;

  const ReaderTopBar({
    super.key,
    required this.novelTitle,
    required this.chapterTitle,
    required this.progressNotifier,
    required this.controlsOpacity,
    required this.onBack,
    required this.onWebView,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: controlsOpacity,
        child: Container(
          decoration: BoxDecoration(
            color: NovonColors.surface,
            border: Border(
              bottom: BorderSide(
                color: NovonColors.border.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: onBack,
                    color: NovonColors.textPrimary,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          novelTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: NovonColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          chapterTitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: NovonColors.textSecondary,
                              ),
                        ),
                        ValueListenableBuilder<double>(
                          valueListenable: progressNotifier,
                          builder: (context, value, _) {
                            return Text(
                              '${value.toStringAsFixed(0)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: NovonColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.public_rounded),
                    tooltip: 'WebView',
                    onPressed: onWebView,
                    color: NovonColors.textPrimary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border_rounded),
                    tooltip: 'Bookmark',
                    onPressed: onBookmark,
                    color: NovonColors.textPrimary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
