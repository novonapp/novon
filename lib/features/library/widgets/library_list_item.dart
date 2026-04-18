import 'package:flutter/material.dart';
import '../../../core/common/widgets/novel_cover_image.dart';
import '../../../core/common/models/novel.dart';

/// Specialized list surface responsible for representing library entities,
/// providing a high-information density layout optimized for vertical scanning.
class LibraryListItem extends StatelessWidget {
  final Novel novel;
  final VoidCallback onTap;

  const LibraryListItem({super.key, required this.novel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: NovelCoverImage(
        imageUrl: novel.coverUrl,
        width: 42,
        height: 56,
        borderRadius: 8,
      ),
      title: Text(novel.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        novel.author,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}
