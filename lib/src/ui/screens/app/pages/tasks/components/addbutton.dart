import 'package:flutter/material.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';

class AddButton extends StatelessWidget {
  final Icon? icon;
  final Text text;
  final Function() onPressed;
  final double? height;
  final double? width;

  const AddButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.height = 38,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        animationDuration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        splashFactory: InkRipple.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: defaultTextSecondaryLayoutColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          text,
        ],
      ),
    );
  }
}
