import 'package:flutter/material.dart';
import 'package:wittycar_mobile/core/extansions/string_extansions.dart';
import 'package:wittycar_mobile/core/init/theme/app_theme_manager.dart';

abstract class AppColors {
  //Unique Colors
  Color bleuDeFrance = '3179E4'.color;
  Color charcoal = '2D3F58'.color;
  Color white = 'FFFFFF'.color;
  Color black = '000000'.color;

  //Overrided Colors
  late Color textColor;
  late Color mapViewIconColor;
  late Color primaryColor;
  late Color primaryContainer;
  late Color secondaryColor;
  late Color secondaryContainer;
  late Color tertiaryColor;
  late Color tertiaryContainer;
}

class LightColors extends AppColors {
  ColorScheme colorScheme = AppThemeManager.instance.lightTheme.colorScheme;
  @override
  Color get textColor => white;
  @override
  Color get primaryColor => colorScheme.primary;
  @override
  Color get primaryContainer => colorScheme.primaryContainer;
  @override
  Color get secondaryColor => colorScheme.secondary;
  @override
  Color get secondaryContainer => colorScheme.secondaryContainer;
  @override
  Color get tertiaryColor => colorScheme.tertiary;
  @override
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
}

/*

class DarkColors extends AppColors {
  ColorScheme colorScheme = AppThemeManager.instance.darkTheme.colorScheme;
  @override
  Color get textColor => black;
  @override
  Color get mapViewIconColor => white;
  @override
  Color get primaryColor => colorScheme.primary;
  @override
  Color get primaryContainer => colorScheme.primaryContainer;
  @override
  Color get secondaryColor => colorScheme.secondary;
  @override
  Color get secondaryContainer => colorScheme.secondaryContainer;
  @override
  Color get tertiaryColor => colorScheme.tertiary;
  @override
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
}
 */