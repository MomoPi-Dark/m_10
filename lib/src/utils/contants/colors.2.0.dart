import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';

class DarkColor {
  static Color primary() => const Color(0xFF212832);
  static Color secondary() => const Color(0xFF263238);
}

class LightColor {
  static Color primary() => const Color(0xFFf7f7f7);
  static Color secondary() => const Color(0xFFf1f1f3);
}

const Color primaryGrey = Color(0xFF455A64);
const Color yellow = Color(0xFFFED36A);
const Color orange = Color(0xFFd95639);

const Color light = Color(0xFFf1f1f3);
const Color light2 = Color(0xFFF8F8F8);
const Color light3 = Color(0xFFf7f7f7);
const Color dark = Color(0xFF212121);
const Color dark2 = Color(0xFF1A1A1A);
const Color yellow2 = Color(0xFF8B8000);
const Color yellow3 = Color(0xFFFFDA78);

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

Color get defaultContainerPrimaryLayoutColor => createThemeColorSchema(
      darkColor: DarkColor.primary(),
      lightColor: LightColor.primary(),
    );

// APP BAR \\

Color get customAppBarLayoutColor => createThemeColorSchema(
      lightColor: LightColor.primary(),
      darkColor: DarkColor.primary(),
    );

Color get customAppBarTextLayoutColor => createThemeColorSchema(
      lightColor: DarkColor.secondary(),
      darkColor: LightColor.secondary(),
    );

Color get customAppBarIconLayoutColor => customAppBarTextLayoutColor;

Color get customHeaderLayoutColor => customAppBarLayoutColor;

Color get customHeaderCalenderTextLayoutColor => createThemeColorSchema(
    lightColor: DarkColor.secondary(), darkColor: LightColor.secondary());
Color get customHeaderCalenderSelectedTextLayoutColor => orange;

// LOGIN \\
Color get fieldCostumColor => createThemeColorSchema(
      darkColor: primaryGrey,
      lightColor: Colors.white,
    );

Color get fieldTextCustomColor => createThemeColorSchema(
      darkColor: const Color(0xFF8CAAB9),
      lightColor: DarkColor.primary(),
    );

Color get defaultCustomPrimaryLayoutColor => createThemeColorSchema(
      lightColor: Colors.white,
      darkColor: Colors.black,
    );

Color get customPrimaryLayoutColor => createThemeColorSchema(
      lightColor: light,
      darkColor: dark,
    );

Color get customSecondaryLayoutColor => createThemeColorSchema(
      lightColor: light3,
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
