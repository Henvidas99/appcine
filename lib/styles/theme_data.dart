import 'package:flutter/material.dart';
import 'app_colors.dart'; 

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.accentRed,
    scaffoldBackgroundColor: AppColors.darkBackground,
    dialogBackgroundColor: AppColors.darkBackground,
    hintColor: AppColors.accentRed,
    cardColor: AppColors.accentRed,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.lightBackground),
      bodyLarge: TextStyle(color: AppColors.lightBackground),
      headlineLarge: TextStyle(color: AppColors.lightBackground),
      headlineMedium: TextStyle(color: AppColors.lightBackground),
      headlineSmall: TextStyle(color: AppColors.lightBackground),
      titleLarge: TextStyle(color: AppColors.lightBackground),
      titleMedium: TextStyle(color: AppColors.lightBackground),
      titleSmall: TextStyle(color: AppColors.lightBackground),
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.blackBackground,
      iconTheme: IconThemeData(color: AppColors.lightBackground),
      titleTextStyle: TextStyle(color: AppColors.lightBackground, fontSize: 20),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.accentRed,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.lightBackground,
    ),
  );
}