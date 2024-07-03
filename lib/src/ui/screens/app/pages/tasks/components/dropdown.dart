import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class AddTaskDropdown extends StatefulWidget {
  const AddTaskDropdown({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.selectedLabel,
    required this.items,
    required this.onChanged,
    this.sufficIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.icon,
  });

  final void Function(String?) onChanged;
  final List<DropdownMenuItem<String>>? items;
  final String hintText;
  final IconData? icon;
  final String labelText;
  final bool obscureText;
  final Widget? prefixIcon;
  final bool readOnly;
  final String selectedLabel;
  final Widget? sufficIcon;

  @override
  State<AddTaskDropdown> createState() => _AddTaskDropdownState();
}

class _AddTaskDropdownState extends State<AddTaskDropdown> {
  InputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: createThemeColorSchema2(
          lightColor: Colors.black,
          darkColor: Colors.white,
        ),
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: GoogleFonts.inter(
              color: createThemeColorSchema2(
                lightColor: Colors.black,
                darkColor: Colors.white,
              ),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            return DropdownButtonFormField<String>(
              value: widget.selectedLabel,
              items: widget.items,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                suffixIcon: widget.sufficIcon,
                prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
                enabledBorder: _buildBorder(),
                focusedBorder: _buildBorder(),
                errorBorder: _buildBorder(),
                border: _buildBorder(),
              ),
            );
          })
        ],
      ),
    );
  }
}
