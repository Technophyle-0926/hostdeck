import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color iconBackgroundColor;
  final Color primaryIconColor;
  final Color envProdBackground;
  final Color envProdText;
  final Color envStageBackground;
  final Color envStageText;
  final Color warningBannerBackground;
  final Color warningBannerBorder;
  final Color warningBannerIcon;
  final Color warningBannerTitle;
  final Color warningBannerText;

  const AppThemeExtension({
    required this.iconBackgroundColor,
    required this.primaryIconColor,
    required this.envProdBackground,
    required this.envProdText,
    required this.envStageBackground,
    required this.envStageText,
    required this.warningBannerBackground,
    required this.warningBannerBorder,
    required this.warningBannerIcon,
    required this.warningBannerTitle,
    required this.warningBannerText,
  });

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? iconBackgroundColor,
    Color? primaryIconColor,
    Color? envProdBackground,
    Color? envProdText,
    Color? envStageBackground,
    Color? envStageText,
    Color? warningBannerBackground,
    Color? warningBannerBorder,
    Color? warningBannerIcon,
    Color? warningBannerTitle,
    Color? warningBannerText,
  }) {
    return AppThemeExtension(
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      primaryIconColor: primaryIconColor ?? this.primaryIconColor,
      envProdBackground: envProdBackground ?? this.envProdBackground,
      envProdText: envProdText ?? this.envProdText,
      envStageBackground: envStageBackground ?? this.envStageBackground,
      envStageText: envStageText ?? this.envStageText,
      warningBannerBackground: warningBannerBackground ?? this.warningBannerBackground,
      warningBannerBorder: warningBannerBorder ?? this.warningBannerBorder,
      warningBannerIcon: warningBannerIcon ?? this.warningBannerIcon,
      warningBannerTitle: warningBannerTitle ?? this.warningBannerTitle,
      warningBannerText: warningBannerText ?? this.warningBannerText,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      iconBackgroundColor: Color.lerp(iconBackgroundColor, other.iconBackgroundColor, t)!,
      primaryIconColor: Color.lerp(primaryIconColor, other.primaryIconColor, t)!,
      envProdBackground: Color.lerp(envProdBackground, other.envProdBackground, t)!,
      envProdText: Color.lerp(envProdText, other.envProdText, t)!,
      envStageBackground: Color.lerp(envStageBackground, other.envStageBackground, t)!,
      envStageText: Color.lerp(envStageText, other.envStageText, t)!,
      warningBannerBackground: Color.lerp(warningBannerBackground, other.warningBannerBackground, t)!,
      warningBannerBorder: Color.lerp(warningBannerBorder, other.warningBannerBorder, t)!,
      warningBannerIcon: Color.lerp(warningBannerIcon, other.warningBannerIcon, t)!,
      warningBannerTitle: Color.lerp(warningBannerTitle, other.warningBannerTitle, t)!,
      warningBannerText: Color.lerp(warningBannerText, other.warningBannerText, t)!,
    );
  }
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.light),
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.scaffoldLight,
    cardColor: Colors.white,
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: Colors.black.withValues(alpha: 0.24), // Approx equivalent to visual spread
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerColor: Colors.grey.shade200,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      labelSmall: TextStyle(color: Colors.black54),
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppThemeExtension(
        iconBackgroundColor: AppColors.iconBgLight,
        primaryIconColor: AppColors.iconPrimaryLight,
        envProdBackground: AppColors.envProdBgLight,
        envProdText: AppColors.envProdTextLight,
        envStageBackground: AppColors.envStageBgLight,
        envStageText: AppColors.envStageTextLight,
        warningBannerBackground: AppColors.warningBannerBgLight,
        warningBannerBorder: AppColors.warningBannerBorderLight,
        warningBannerIcon: AppColors.warningBannerIconLight,
        warningBannerTitle: AppColors.warningBannerTitleLight,
        warningBannerText: AppColors.warningBannerTextLight,
      ),
    ],
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.dark),
    useMaterial3: true,
    cardColor: AppColors.cardDark,
    scaffoldBackgroundColor: AppColors.scaffoldDark,
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      shadowColor: Colors.black,
      elevation: 8, // More elevation for dark mode shadow visibility
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerColor: Colors.grey.shade800,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cardDark,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.grey),
    ),
    extensions: <ThemeExtension<dynamic>>[
      AppThemeExtension(
        iconBackgroundColor: AppColors.iconBgDark.withValues(alpha: 0.5),
        primaryIconColor: AppColors.iconPrimaryDark,
        envProdBackground: AppColors.envProdBgDark.withValues(alpha: 0.6),
        envProdText: AppColors.envProdTextDark,
        envStageBackground: AppColors.envStageBgDark.withValues(alpha: 0.6),
        envStageText: AppColors.envStageTextDark,
        warningBannerBackground: AppColors.warningBannerBgDark.withValues(alpha: 0.5),
        warningBannerBorder: AppColors.warningBannerBorderDark,
        warningBannerIcon: AppColors.warningBannerIconDark,
        warningBannerTitle: AppColors.warningBannerTitleDark,
        warningBannerText: AppColors.warningBannerTextDark,
      ),
    ],
  );
}
