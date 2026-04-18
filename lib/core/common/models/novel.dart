import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:novon/core/common/enums/novel_status.dart';
export 'package:novon/core/common/enums/novel_status.dart';

part 'novel.freezed.dart';
part 'novel.g.dart';

@freezed
abstract class Novel with _$Novel {
  const factory Novel({
    required String id,
    required String sourceId,
    required String url,
    required String title,
    @Default('') String author,
    @Default('') String description,
    @Default('') String coverUrl,
    @Default(NovelStatus.unknown) NovelStatus status,
    @Default([]) List<String> genres,
    @Default(false) bool inLibrary,
    @Default(0) int totalChapters,
    @Default(0) int readChapters,
    @Default(0) int downloadedChapters,
    DateTime? dateAdded,
    DateTime? lastFetched,
    DateTime? lastRead,
  }) = _Novel;

  factory Novel.fromJson(Map<String, dynamic> json) => _$NovelFromJson(json);
}
