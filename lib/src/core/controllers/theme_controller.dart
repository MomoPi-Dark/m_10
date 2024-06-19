import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';

const fontFamily = "SF Pro Display";
const fontFamilyFallback = ["SF Pro Display", "SF Pro Text"];

class ThemeController extends GetxController {
  late final GetStorage storeTheme;

  final _themeMode = ThemeMode.system.obs;

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  Future<void> init() async {
    storeTheme = GetStorage();

    String? getTheme = storeTheme.read("theme");

    if (getTheme != null) {
      setThemeData(parseThemeMode(getTheme));
    }
  }

  ThemeData get darkMode => ThemeData(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: dark,
          secondary: dark2,
        ),
        scaffoldBackgroundColor: dark2,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
        ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: dark,
        //   ),
        // ),
      );

  ThemeData get lightMode => ThemeData(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: light,
          secondary: light2,
        ),
        scaffoldBackgroundColor: light2,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
        ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: light,
        //   ),
        // ),
      );

  Rx<ThemeMode> get themeMode => _themeMode;

  Rx<ThemeData> get currentTheme {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return lightMode.obs;
      case ThemeMode.dark:
        return darkMode.obs;
      default:
        return lightMode.obs;
    }
  }

  RxBool get isDarkMode => (_themeMode.value == ThemeMode.dark).obs;

  void setThemeData(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    _setStoreTheme(themeMode);
  }

  ThemeMode parseThemeMode(String themeString) {
    switch (themeString) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void _setStoreTheme(ThemeMode themeMode) {
    storeTheme.write("theme", themeMode.toString().split('.').last);
  }
}
