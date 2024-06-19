import 'package:flutter/material.dart';

import '/src/utils/contants/colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final Function() onPressed;
  final String label;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            yellow3,
            orange,
            Color(0xFFFF5F00),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });

            try {
              await widget.onPressed();
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _isLoading
              ? CircularProgressIndicator(
                  color: customPrimaryTextColor,
                )
              : Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 18,
                    color: customPrimaryTextColor,
                  ),
                )),
    );
  }
}
