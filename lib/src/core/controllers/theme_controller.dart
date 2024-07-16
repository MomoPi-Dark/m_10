
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';

const fontFamily = "SF Pro Display";
const fontFamilyFallback = ["SF Pro Display", "SF Pro Text"];

class ThemeController extends GetxController {
  final GetStorage storeTheme = GetStorage();

  final _currentTheme = ThemeData().obs;
  final _themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() {
    String? getTheme = storeTheme.read("theme");

    if (getTheme != null) {
      setThemeData(parseThemeMode(getTheme));
    } else {
      setThemeData(ThemeMode.light);
    }
  }

  ThemeData get darkMode => ThemeData(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        scaffoldBackgroundColor: DarkColor.primary(),
        primaryColor: DarkColor.primary(),
        colorScheme: ColorScheme.dark(
          primary: DarkColor.primary(),
          secondary: DarkColor.secondary(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: DarkColor.primary(),
          iconTheme: IconThemeData(color: LightColor.primary()),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: DarkColor.primary(),
          titleTextStyle: TextStyle(color: LightColor.primary()),
          contentTextStyle: TextStyle(color: LightColor.primary()),
        ),
      );

  ThemeData get lightMode => ThemeData(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        scaffoldBackgroundColor: LightColor.primary(),
        primaryColor: LightColor.primary(),
        colorScheme: ColorScheme.light(
          primary: LightColor.primary(),
          secondary: LightColor.secondary(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: LightColor.primary(),
          iconTheme: IconThemeData(color: DarkColor.primary()),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: LightColor.primary(),
          titleTextStyle: TextStyle(color: DarkColor.primary()),
          contentTextStyle: TextStyle(color: DarkColor.primary()),
        ),
      );

  Rx<ThemeMode> get themeMode => _themeMode;

  Rx<ThemeData> get currentTheme => _currentTheme;

  RxBool get isDarkMode => (_themeMode.value == ThemeMode.dark).obs;

  void setThemeData(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    _updateCurrentTheme();
    _setStoreTheme(themeMode);
    setUIColor();
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

  void setUIColor() {
    ThemeData theme = currentTheme.value;
    Brightness brightness =
        isDarkMode.value ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        systemNavigationBarIconBrightness: brightness,
        statusBarColor: theme.colorScheme.primary,
        systemNavigationBarColor: theme.colorScheme.secondary,
        systemNavigationBarDividerColor: theme.colorScheme.secondary,
      ),
    );
  }

  void _updateCurrentTheme() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        _currentTheme.value = lightMode;
        break;
      case ThemeMode.dark:
        _currentTheme.value = darkMode;
        break;
      default:
        _currentTheme.value = lightMode;
        break;
    }
  }

  void _setStoreTheme(ThemeMode themeMode) {
    storeTheme.write("theme", themeMode.toString().split('.').last);
  }
}
