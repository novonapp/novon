import 'package:flutter/material.dart';
import '../../../core/theme/novon_colors.dart';
import 'status_badge.dart';

/// Specialized presentation component responsible for rendering individual
/// chapter identifiers and orchestrating interactive gestures for reading,
/// horizontal consumption tracking, and read-status management.
class NovelChapterTile extends StatelessWidget {
  final String chapterName;
  final String chapterUrl;
  final num? chapterNumber;
  final bool isRead;
  final double progressPercent;
  final VoidCallback onTap;
  final Future<bool?> Function(DismissDirection) onSwipeDismiss;
  final Widget downloadTrailing;

  const NovelChapterTile({
    super.key,
    required this.chapterName,
    required this.chapterUrl,
    required this.chapterNumber,
    required this.isRead,
    required this.progressPercent,
    required this.onTap,
    required this.onSwipeDismiss,
    required this.downloadTrailing,
  });

  @override
  Widget build(BuildContext context) {
    String baseLabel = 'Chapter';
    if (chapterNumber != null && chapterNumber! >= 0) {
      final isInteger = chapterNumber!.truncateToDouble() == chapterNumber;
      baseLabel = 'Chapter ${isInteger ? chapterNumber!.toInt() : chapterNumber}';
    }

    return Dismissible(
      key: ValueKey('chapter-swipe-$chapterUrl'),
      direction: DismissDirection.endToStart,
      confirmDismiss: onSwipeDismiss,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: isRead
              ? NovonColors.warning.withValues(alpha: 0.2)
              : NovonColors.success.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              isRead ? Icons.markunread_rounded : Icons.mark_email_read_rounded,
              color: isRead ? NovonColors.warning : NovonColors.success,
            ),
            const SizedBox(width: 8),
            Text(
              isRead ? 'Mark unread' : 'Mark read',
              style: TextStyle(
                color: isRead ? NovonColors.warning : NovonColors.success,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            decoration: BoxDecoration(
              color: NovonColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isRead
                    ? NovonColors.border.withValues(alpha: 0.35)
                    : NovonColors.primary.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapterName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isRead
                              ? NovonColors.textSecondary.withValues(alpha: 0.7)
                              : NovonColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          StatusBadge(
                            status: baseLabel,
                            color: NovonColors.primary,
                          ),
                          if (progressPercent > 0 && !isRead)
                            StatusBadge(
                              status: '${progressPercent.toStringAsFixed(0)}% read',
                              color: NovonColors.primary.withValues(alpha: 0.8),
                            ),
                          if (isRead)
                            StatusBadge(
                              status: 'Read',
                              color: NovonColors.success,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                downloadTrailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
