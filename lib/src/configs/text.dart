import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get subHeadingTextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.grey[700] : Colors.grey,
    ),
  );
}

TextStyle get headingTextStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get titleTextStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get subTitleTextStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get titleAppBarStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
  );
}

String truncateName(String name, int maxLength) {
  return name.length <= maxLength ? name : "${name.substring(0, maxLength)}...";
}
