import 'package:flutter/material.dart';
import 'reader_paragraph.dart';

/// Renders the chapter text content as styled paragraphs, preserving 
/// directionality and spacing.
///
/// Uses [ListView.builder] for lazy construction of paragraph widgets,
/// ensuring only visible paragraphs are built and laid out. This avoids
/// the cost of eagerly constructing hundreds of [HtmlWidget] instances
/// for long chapters.
class ReaderContentBody extends StatelessWidget {
  final List<String> paragraphs;
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final Color textColor;

  const ReaderContentBody({
    super.key,
    required this.paragraphs,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (paragraphs.isEmpty) {
      return Text(
        'No chapter content found.',
        style: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 14),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          paragraphs.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RepaintBoundary(
              child: ReaderParagraph(
                html: paragraphs[i],
                fontSize: fontSize,
                lineHeight: lineHeight,
                fontFamily: fontFamily,
                textColor: textColor,
              ),
            ),
          ),
          growable: false,
        ),
      ),
    );
  }
}
