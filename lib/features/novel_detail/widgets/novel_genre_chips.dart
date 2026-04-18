import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Specialized horizontal orchestration surface responsible for presenting
/// categorical genre tokens associated with the novel entity.
class NovelGenreChips extends StatelessWidget {
  final AsyncValue<dynamic> detail;

  const NovelGenreChips({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 36,
        child: detail.when(
          loading: () => ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [_genreChip('...')],
          ),
          error: (e, st) => const SizedBox.shrink(),
          data: (d) => ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: (d.genres.isEmpty ? ['Unknown'] : d.genres)
                .map<Widget>((g) => _genreChip(g.toString()))
                .toList(),
          ),
        ),
      ),
    );
  }

  static Widget _genreChip(String genre) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(genre),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelStyle: const TextStyle(fontSize: 11),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
