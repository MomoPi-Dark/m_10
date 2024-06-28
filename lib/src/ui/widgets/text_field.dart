import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.isPassword = false,
  });

  final TextEditingController? controller;
  final String hint;
  final bool isPassword;
  final String? label;
  final Function(String) onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextStyle get defaultTextStyle => GoogleFonts.nunito();

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: primaryGrey,
      ),
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: defaultTextStyle.copyWith(
              color: primaryGrey,
              fontSize: 16,
            ),
          ),
        const SizedBox(height: 10),
        TextField(
          onChanged: widget.onChanged,
          style: defaultTextStyle.copyWith(
            color: defaultTextPrimaryLayoutColor,
          ),
          obscureText: widget.isPassword,
          controller: widget.controller,
          cursorColor: defaultTextPrimaryLayoutColor,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            hintText: widget.hint,
            hintStyle: GoogleFonts.nunito(
              color: defaultTextPrimaryLayoutColor,
            ),
            fillColor: fieldCostumColor,
            filled: true,
            border: _buildBorder(),
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
        )
      ],
    );
  }
}
