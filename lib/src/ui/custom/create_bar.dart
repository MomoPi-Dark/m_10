import 'package:flutter/material.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';

/// Creates a widget with an icon and a notification badge.
///
/// [icon] is the main icon widget.
/// [countNotif] is the number of notifications to display.
/// [crycleColor] is the background color of the notification badge (default is red).
/// [textColor] is the color of the notification text (default is white).
/// [right], [top], [left], [bottom] are the positioning parameters for the badge.
/// [height] and [width] are the dimensions of the badge.
Widget createIconNotif({
  required Widget icon,
  required int countNotif,
  Color crycleColor = Colors.red,
  Color? textColor,
  double right = 0,
  double top = 0,
  double? left,
  double? bottom,
  double? height,
  double? width,
}) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: icon,
      ),
      if (countNotif > 0)
        Positioned(
          right: right,
          top: top,
          left: left,
          bottom: bottom,
          height: height,
          width: width,
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 16,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: crycleColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              countNotif > 99 ? '99+' : countNotif.toString(),
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
    ],
  );
}

NavigationDestination createNavDestination({
  required IconData icon,
  required IconData selectedIcon,
  required String label,
  int countNotif = 0,
}) {
  Color barColor =
      createThemeColorSchema(lightColor: yellow3, darkColor: yellow2);

  return NavigationDestination(
    icon: createIconNotif(
      right: 0,
      top: 0,
      countNotif: countNotif,
      crycleColor: barColor,
      icon: Icon(
        icon,
        size: 24,
      ),
    ),
    selectedIcon: createIconNotif(
      right: 0,
      top: 0,
      countNotif: countNotif,
      crycleColor: barColor,
      icon: Icon(
        selectedIcon,
        size: 24,
      ),
    ),
    label: label,
    tooltip: label,
  );
}
