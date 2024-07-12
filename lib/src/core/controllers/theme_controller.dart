import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';

const fontFamily = "SF Pro Display";
const fontFamilyFallback = ["SF Pro Display", "SF Pro Text"];

class ThemeController extends GetxController {
  final GetStorage storeTheme = GetStorage();

  final _themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    String? getTheme = storeTheme.read("theme");

    if (getTheme != null) {
      setThemeData(parseThemeMode(getTheme));
    } else {
      setThemeData(ThemeMode.system);
    }
  }

  ThemeData get darkMode => ThemeData(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        scaffoldBackgroundColor: DarkColor.primary(),
        primaryColor: DarkColor.primary(),
        colorScheme: ColorScheme.dark(
          brightness: Brightness.light,
          primary: DarkColor.primary(),
          secondary: DarkColor.secondary(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: DarkColor.primary(),
          iconTheme: IconThemeData(color: LightColor.primary()),
        ),
      );

  ThemeData get lightMode => ThemeData(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        scaffoldBackgroundColor: LightColor.primary(),
        primaryColor: LightColor.primary(),
        colorScheme: ColorScheme.light(
          brightness: Brightness.dark,
          primary: LightColor.primary(),
          secondary: LightColor.secondary(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: LightColor.primary(),
          iconTheme: IconThemeData(color: DarkColor.primary()),
        ),
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
    setUIColor(currentTheme.value);
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

  void setUIColor(ThemeData theme) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: theme.colorScheme.brightness,
        statusBarBrightness: theme.colorScheme.brightness,
        systemNavigationBarIconBrightness: theme.colorScheme.brightness,
        statusBarColor: theme.colorScheme.primary,
        systemNavigationBarColor: theme.colorScheme.secondary,
        systemNavigationBarDividerColor: theme.colorScheme.secondary,
      ),
    );
  }

  void _setStoreTheme(ThemeMode themeMode) {
    storeTheme.write("theme", themeMode.toString().split('.').last);
  }
}
