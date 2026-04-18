import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';

final RegExp _htmlTagRx = RegExp(r'<[^>]+>');
final RegExp _arabicCharRx = RegExp(r'[\u0600-\u06FF]');
final RegExp _latinCharRx = RegExp(r'[A-Za-z]');

class ReaderParagraph extends StatelessWidget {
  final String html;
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final Color textColor;

  const ReaderParagraph({
    super.key,
    required this.html,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final direction = _guessTextDirection(html);
    final isArabic = direction == TextDirection.rtl;
    final arabicFont = _arabicReaderFont(fontFamily);
    final baseStyle = (isArabic ? arabicFont : GoogleFonts.inter()).copyWith(
      color: textColor.withValues(alpha: 0.95),
      fontSize: fontSize,
      height: lineHeight,
    );
    
    return Directionality(
      textDirection: direction,
      child: HtmlWidget(
        html,
        textStyle: baseStyle,
      ),
    );
  }

  static TextDirection _guessTextDirection(String html) {
    final text = html.replaceAll(_htmlTagRx, ' ');
    final arabicCount = _arabicCharRx.allMatches(text).length;
    final latinCount = _latinCharRx.allMatches(text).length;
    return arabicCount > latinCount ? TextDirection.rtl : TextDirection.ltr;
  }

  static TextStyle _arabicReaderFont(String family) {
    switch (family) {
      case 'El Messiri':
        return const TextStyle(fontFamily: 'El Messiri');
      case 'Lalezar':
        return const TextStyle(fontFamily: 'Lalezar');
      case 'Alexandria':
      default:
        return const TextStyle(fontFamily: 'Alexandria');
    }
  }
}
