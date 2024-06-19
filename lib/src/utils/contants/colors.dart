import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';

class BlueLightColors {
  static Color get color1 => const Color(0xFFF0F3FA);
  static Color get color2 => const Color(0xFFD5DEEF);
  static Color get color3 => const Color(0xFFB1C9EF);
  static Color get color4 => const Color(0xFF8AAEE0);
  static Color get color5 => const Color(0xFF638ECB);
  static Color get color6 => const Color(0xFF395886);
}

class BlueDarkColors {
  static Color get color1 => const Color(0xFF032030);
  static Color get color2 => const Color(0xFF022B42);
  static Color get color3 => const Color(0xFF003554);
  static Color get color4 => const Color(0xFF004D74);
  static Color get color5 => const Color(0xFF006494);
  static Color get color6 => const Color(0xFF006DA4);
}

const Color light = Color(0xFFf1f1f3);
const Color light2 = Color(0xFFF8F8F8);
const Color dark = Color(0xFF212121);
const Color dark2 = Color(0xFF1A1A1A);
const Color yellow = Color(0xFFfcd36a);
const Color yellow2 = Color(0xFF8B8000);
const Color yellow3 = Color(0xFFFFDA78);
const Color orange = Color(0xFFd95639);

final List<Color> colorList = [
  Colors.blue,
  Colors.cyan,
  Colors.deepPurple,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.lime,
  Colors.orange,
];

Color createThemeColorSchema(
    {required Color lightColor, required Color darkColor}) {
  return Get.find<ThemeController>().isDarkMode() ? darkColor : lightColor;
}

Color get customPrimaryLayoutColor => createThemeColorSchema(
      lightColor: light,
      darkColor: dark,
    );

Color get customSecondaryLayoutColor => createThemeColorSchema(
      lightColor: light2,
      darkColor: dark2,
    );

Color get customPrimaryTextColor => createThemeColorSchema(
      lightColor: dark,
      darkColor: light,
    );

Color get customSecondaryTextColor => createThemeColorSchema(
      lightColor: dark2,
      darkColor: light2,
    );

// ========= APPBAR LAYOUT ========= \\

Color get customAppBarLayoutColor => createThemeColorSchema(
      lightColor: light,
      darkColor: dark,
    );

Color get customAppBarTextLayoutColor => createThemeColorSchema(
      lightColor: dark2,
      darkColor: light2,
    );

Color get customAppBarIconLayoutColor => customAppBarTextLayoutColor;

Color get customHeaderLayoutColor => customAppBarLayoutColor;

Color get customHeaderCalenderTextLayoutColor =>
    createThemeColorSchema(lightColor: dark2, darkColor: light2);
Color get customHeaderCalenderSelectedTextLayoutColor => orange;

// ========= BODY LAYOUT ========= \\

Color get customBodyLayoutColor => createThemeColorSchema(
      lightColor: dark,
      darkColor: light,
    );

// ========= BOTTOM NAVBAR LAYOUT ========= \\

Color get customBottomNavbarLayoutColor => createThemeColorSchema(
      darkColor: dark,
      lightColor: light,
    );

Color get customBottomNavbarShadowNavbarLayoutColor =>
    customBottomNavbarLayoutColor;

Color get customBottomNavbarIconLayoutColor => createThemeColorSchema(
      lightColor: dark,
      darkColor: light,
    );

Color get customBottomNavbarIndicatorLayoutColor =>
    Color(yellow.value).withOpacity(0.6);

Color get customBottomNavbarTextIndicatorLayoutColor =>
    customBottomNavbarIconLayoutColor;

Color get customBottomNavbarIconSelectedLayoutColor =>
    createThemeColorSchema(darkColor: yellow, lightColor: yellow2);

Color get customBottomNavbarIconUnSelectedLayoutColor =>
    createThemeColorSchema(darkColor: light2, lightColor: dark2);
