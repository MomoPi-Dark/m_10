import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/ui/screens/_layout/title_app.dart';

AppBar appCustom() {
  final theme = Get.find<ThemeController>();

  return AppBar(
    title: const TitleApp(),
    actions: [
      Obx(() {
        return Container(
          margin: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              theme.setThemeData(
                  theme.isDarkMode() ? ThemeMode.light : ThemeMode.dark);
            },
            icon: Icon(
                theme.isDarkMode() ? Icons.brightness_7 : Icons.brightness_4),
          ),
        );
      }),
    ],
  );
}
