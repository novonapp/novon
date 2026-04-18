import 'package:flutter/material.dart';
import '../../../core/common/widgets/novel_cover_image.dart';
import '../../../core/common/models/novel.dart';

/// Compact grid-based representation of a library entity, optimized for
/// dense visual appraisal and cover-centric navigation.
class LibraryGridItem extends StatelessWidget {
  final Novel novel;
  final VoidCallback onTap;

  const LibraryGridItem({super.key, required this.novel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 3 / 5,
            child: NovelCoverImage(imageUrl: novel.coverUrl, borderRadius: 12),
          ),
          const SizedBox(height: 8),
          Text(
            novel.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
