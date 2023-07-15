import 'package:flutter/material.dart';
import 'package:reddit_app/app/theme/app_colors.dart';

class Pallete {
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.blackColor,
    cardColor: AppColors.greyColor,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: AppColors.drawerColor,
      iconTheme: IconThemeData(
        color: AppColors.whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.drawerColor,
    ),
    primaryColor: AppColors.redColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.redColor,
      background: AppColors.drawerColor,
    ),
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.whiteColor,
    cardColor: AppColors.greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.whiteColor,
    ),
    primaryColor: AppColors.redColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.redColor,
      background: AppColors.whiteColor,
    ),
  );
}
