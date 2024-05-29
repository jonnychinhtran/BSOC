import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App Styles Class -> Resource class for storing app level styles constants
class AppStyles {
  // Light Theme
  static ThemeData lightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: AppColors.PRIMARY_COLOR,
      primaryColorLight: AppColors.PRIMARY_COLOR_LIGHT,
      primaryColorDark: AppColors.PRIMARY_COLOR_DARK,
      // accentColor: AppColors.ACCENT_COLOR,
      scaffoldBackgroundColor: AppColors.BACKGROUND_COLOR_LIGHT,
      textTheme: base.textTheme.apply(fontFamily: 'Nunito'),
      primaryTextTheme: base.textTheme.apply(fontFamily: 'Nunito'),
      // accentTextTheme: base.textTheme.apply(fontFamily: 'Nunito'),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        textTheme: ButtonTextTheme.primary,
        buttonColor: AppColors.ACCENT_COLOR,
      ),
    );
  }

  // Dark Theme
  static ThemeData darkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
        primaryColor: AppColors.PRIMARY_COLOR,
        primaryColorLight: AppColors.PRIMARY_COLOR_LIGHT,
        primaryColorDark: AppColors.PRIMARY_COLOR_DARK,
        textTheme: base.textTheme.apply(fontFamily: 'Poppins'),
        primaryTextTheme: base.textTheme.apply(fontFamily: 'Poppins'),
        // accentTextTheme: base.textTheme.apply(fontFamily: 'Poppins'),
        // accentColor: AppColors.ACCENT_COLOR,
        scaffoldBackgroundColor: AppColors.BACKGROUND_COLOR_DARK);
  }
}
