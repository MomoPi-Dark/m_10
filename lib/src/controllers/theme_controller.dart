import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const fontFamily = "SF Pro Display";
const fontFamilyFallback = ["SF Pro Display", "SF Pro Text"];

class ThemeController extends GetxController {
  late final GetStorage storeTheme;

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  final ThemeData lightMode = ThemeData(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
    ),
  );

  final ThemeData darkMode = ThemeData(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
    ),
  );

  final _themeMode = ThemeMode.system.obs;
  Rx<ThemeMode> get themeMode => _themeMode;

  Rx<ThemeData> get themeDataNow {
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

  void _setStoreTheme(ThemeMode themeMode) {
    storeTheme.write("theme", themeMode.toString().split('.').last);
  }

  Future<void> init() async {
    storeTheme = GetStorage();

    String? getTheme = storeTheme.read("theme");

    if (getTheme != null) {
      _themeMode.value = parseThemeMode(getTheme);
    }
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
}
