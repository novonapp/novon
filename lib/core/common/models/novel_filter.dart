import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:novon/core/common/enums/sort_mode.dart';

part 'novel_filter.freezed.dart';
part 'novel_filter.g.dart';

enum SortDirection { ascending, descending }

@freezed
abstract class NovelFilter with _$NovelFilter {
  const factory NovelFilter({
    @Default('') String query,
    @Default(SortMode.lastRead) SortMode sortMode,
    @Default(SortDirection.descending) SortDirection sortDirection,
    @Default(null) bool? downloaded,
    @Default(null) bool? unread,
    @Default(null) bool? started,
    @Default(null) bool? completed,
    @Default(null) String? categoryId,
  }) = _NovelFilter;

  factory NovelFilter.fromJson(Map<String, dynamic> json) =>
      _$NovelFilterFromJson(json);
}
