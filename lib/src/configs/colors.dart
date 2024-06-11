import 'dart:ui';

import 'package:get/get.dart';
import 'package:menejemen_waktu/src/controllers/theme_controller.dart';

class BlueLightColors {
  static get color1 => const Color(0xFFF0F3FA);
  static get color2 => const Color(0xFFD5DEEF);
  static get color3 => const Color(0xFFB1C9EF);
  static get color4 => const Color(0xFF8AAEE0);
  static get color5 => const Color(0xFF638ECB);
  static get color6 => const Color(0xFF395886);
}

class BlueDarkColors {
  static get color1 => const Color(0xFF032030);
  static get color2 => const Color(0xFF022B42);
  static get color3 => const Color(0xFF003554);
  static get color4 => const Color(0xFF004D74);
  static get color5 => const Color(0xFF006494);
  static get color6 => const Color(0xFF006DA4);
}

const Color primaryContainerColor = Color(0xFFd95639);
const Color foregroundContainerColor = Color(0xFFF8F8F8);
const Color secondaryContainerColor = Color(0xFFfcd36a);

const Color primaryBackgroundColor = Color(0xFFF8F8F8);
const Color secondaryBackgroundColor = Color(0xFF212121);

get colorAppBar => Get.find<ThemeController>().isDarkMode()
    ? BlueDarkColors.color4
    : BlueLightColors.color4;
