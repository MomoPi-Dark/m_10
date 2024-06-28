import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';

const fontFamily = "SF Pro Display";
const fontFamilyFallback = ["SF Pro Display", "SF Pro Text"];

class ThemeController extends GetxController {
  late final GetStorage storeTheme;

  final _themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    storeTheme = GetStorage();

    String? getTheme = storeTheme.read("theme");

    if (getTheme != null) {
      setThemeData(parseThemeMode("light"));
    }
  }

  ThemeData get darkMode => ThemeData(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        scaffoldBackgroundColor: DarkColor.primary(),
        primaryColor: DarkColor.primary(),
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
    _setUIColor();
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

  void _setUIColor() {
    ThemeData theme = currentTheme();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: theme.appBarTheme.backgroundColor,
        statusBarIconBrightness:
            isDarkMode() ? Brightness.light : Brightness.dark,
        statusBarBrightness: theme.brightness,
        systemNavigationBarColor:
            theme.bottomNavigationBarTheme.backgroundColor,
        systemNavigationBarIconBrightness:
            isDarkMode() ? Brightness.light : Brightness.dark,
      ),
    );
  }

  void _setStoreTheme(ThemeMode themeMode) {
    storeTheme.write("theme", themeMode.toString().split('.').last);
  }
}
