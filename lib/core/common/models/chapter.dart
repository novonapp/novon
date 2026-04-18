import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter.freezed.dart';
part 'chapter.g.dart';

@freezed
abstract class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required String novelId,
    required String url,
    required String name,
    @Default(-1) double number,
    DateTime? dateUpload,
    @Default(false) bool read,
    @Default(0) int lastPageRead,
    @Default(0) double lastScrollOffset,
    @Default(false) bool downloaded,
    @Default(0) int wordCount,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);
}

@freezed
abstract class ChapterContent with _$ChapterContent {
  const factory ChapterContent({
    required String chapterId,
    required String html,
    String? title,
    @Default(0) int wordCount,
    DateTime? fetchedAt,
  }) = _ChapterContent;

  factory ChapterContent.fromJson(Map<String, dynamic> json) =>
      _$ChapterContentFromJson(json);
}
