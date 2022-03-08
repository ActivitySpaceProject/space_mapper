import 'package:flutter/material.dart';

class Styles {
  static const _textSizeLarge = 25.0;
  static const _textSizeSmall = 12.0;
  static const horizontalPaddingDefault = 12.0;
  static final Color _textColorStrong = _hexToColor('000000');
  static final Color _textColorFaint = _hexToColor('999999');
  static final Color textColorBright = _hexToColor('FFFFFF');
  static final Color accentColor = _hexToColor('FF0000');
  static final String _fontNameDefault = 'Montserrat';

  static final textCTAButton = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    color: textColorBright,
  );

  static final surveyTileTitleLight = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    color: _textColorStrong,
  );

  static final surveyTileTitleDark = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeLarge,
    color: textColorBright,
  );

  static final surveyTileCaption = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeSmall,
    color: _textColorFaint,
  );

  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}
