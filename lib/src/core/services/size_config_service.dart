import 'package:flutter/material.dart';

class AppSizes {
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double screenHeight;
  static late double screenWidth;

  static late MediaQueryData _mediaQueryData;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}
