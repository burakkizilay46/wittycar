import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wittycar_mobile/core/init/theme/app_theme.dart';
import 'package:wittycar_mobile/core/init/theme/text_theme/text_theme.dart';

class AppThemeManager extends AppTheme {
  static AppThemeManager? _instance;
  static AppThemeManager get instance {
    return _instance ??= AppThemeManager._init();
  }

  AppThemeManager._init();

  @override
  ThemeData get lightTheme => FlexThemeData.light(
    fontFamily: GoogleFonts.poppins().fontFamily,
    scheme: FlexScheme.bahamaBlue,
    textTheme: TextThemeManager.instance.textTheme(),
  );
}
