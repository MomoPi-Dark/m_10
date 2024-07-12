import 'package:flutter/material.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class HeaderLayout extends StatelessWidget {
  const HeaderLayout({
    super.key,
    required this.bodyChild,
    this.headerChild,
    this.padding,
    this.showAppBar = false,
  });

  final Widget bodyChild;
  final Widget? headerChild;
  final EdgeInsetsGeometry? padding;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headerChild != null)
          Container(
            padding: defaultPaddingHorizontal,
            decoration: BoxDecoration(
              color: customHeaderLayoutColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: headerChild,
          ),
        bodyChild
      ],
    );
  }
}
