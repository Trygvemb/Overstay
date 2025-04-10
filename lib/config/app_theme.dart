import 'package:flutter/material.dart';

class AppColors {
  static const Color color1 = Color(0xFFD9ED92);
  static const Color color2 = Color(0xFFB5E48C);
  static const Color color3 = Color(0xFF99D98C);
  static const Color color4 = Color(0xFF76C893);
  static const Color color5 = Color(0xFF52B69A);
  static const Color color6 = Color(0xFF34A0A4);
  static const Color color7 = Color(0xFF168AAD);
  static const Color color8 = Color(0xFF1A759F);
  static const Color color9 = Color(0xFF1E6091);
  static const Color color10 = Color(0xFF184E77);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors.color1,
      secondary: AppColors.color2,
      tertiary: AppColors.color3,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        displayLarge: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
      ),
    ),
      )
    )
  );

  static const LinearGradient gradient = LinearGradient(
    colors: [
      AppColors.color7,
      AppColors.color8,
      AppColors.color9,
      AppColors.color10,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradient2 = LinearGradient(
    colors: [AppColors.color5, AppColors.color6, AppColors.color7],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradient3 = LinearGradient(
    colors: [
      AppColors.color1,
      AppColors.color2,
      AppColors.color3,
      AppColors.color4,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradient4 = LinearGradient(
    colors: [AppColors.color1, AppColors.color2, AppColors.color3],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradient6 = LinearGradient(
    colors: [AppColors.color7, AppColors.color8, AppColors.color9],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
