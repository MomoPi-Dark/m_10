import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';

class DarkColor {
  static Color primary() => const Color(0xFF212832);
  static Color secondary() => const Color(0xFF263238);
}

class LightColor {
  static Color primary() => const Color(0xFFf7f7f7);
  static Color secondary() => const Color(0xFFf1f1f3);
}

const Color primaryGrey = Color(0xFF455A64);
const Color yellow0 = Color(0xFFFED36A);
const Color orange0 = Color(0xFFd95639);

Color createThemeColorSchema2(
    {required Color lightColor, required Color darkColor}) {
  return Get.find<ThemeController>().isDarkMode() ? darkColor : lightColor;
}

Color get defaultTextPrimaryLayoutColor => createThemeColorSchema(
      darkColor: LightColor.primary(),
      lightColor: DarkColor.primary(),
    );

Color get defaultTextSecondaryLayoutColor => createThemeColorSchema(
      darkColor: LightColor.secondary(),
      lightColor: DarkColor.secondary(),
    );

Color get defaultContainerSecondaryLayoutColor => createThemeColorSchema(
      darkColor: DarkColor.secondary(),
      lightColor: LightColor.secondary(),
    );

// LOGIN \\
Color get fieldCostumColor => createThemeColorSchema(
      darkColor: primaryGrey,
      lightColor: Colors.white,
    );

Color get fieldTextCustomColor => createThemeColorSchema(
      darkColor: const Color(0xFF8CAAB9),
      lightColor: DarkColor.primary(),
    );
