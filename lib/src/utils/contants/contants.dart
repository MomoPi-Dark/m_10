import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';

const double defaultPadding = 24;

const int defaultDelayLoading = 1;

enum StateLoadItems {
  none,
  loading,
  done,
  error,
}

const EdgeInsetsGeometry defaultPaddingHorizontal =
    EdgeInsets.symmetric(horizontal: defaultPadding);

const double defaultSizeIconAppBar = 23;

String truncateName(String name, int maxLength) {
  return name.length <= maxLength ? name : "${name.substring(0, maxLength)}...";
}

class Heading {
  static const double h1 = 32.0;
  static const double h2 = 28.0;
  static const double h3 = 24.0;
  static const double h4 = 20.0;
  static const double h5 = 18.0;
  static const double h6 = 16.0;
  static const double bodyText = 16.0;
  static const double caption = 12.0;
}

TextStyle get headerText {
  return GoogleFonts.lato(
    textStyle: const TextStyle(),
  );
}

// ======== APPBAR ======== \\

TextStyle get appBarTopDescriptionStyle {
  return GoogleFonts.figtree(
    textStyle: TextStyle(
      color: customAppBarTextLayoutColor,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  );
}

TextStyle get appBarBottomDescriptionStyle {
  return GoogleFonts.figtree(
    textStyle: TextStyle(
      color: customAppBarTextLayoutColor,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
  );
}

TextStyle get appBarTitleStyle {
  return GoogleFonts.figtree(
    textStyle: TextStyle(
      color: customAppBarTextLayoutColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

// ======== BODY ======== \\

TextStyle get bodyTextStyle {
  return GoogleFonts.figtree(
    textStyle: const TextStyle(
      fontSize: Heading.bodyText,
    ),
  );
}

// ======== NAVBAR ======== \\
TextStyle get navBarTextStyle {
  return GoogleFonts.figtree(
    textStyle: const TextStyle(
      fontSize: 13.5,
    ),
  );
}
