import 'package:flutter/material.dart';

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
          foregroundColor: Colors.black,
          animationDuration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          splashFactory: InkRipple.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            text,
          ],
        ));
  }
}
