import 'package:flutter/material.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class AddTaskTextForm extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Widget? sufficIcon;
  final Widget? prefixIcon;
  final IconData? icon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AddTaskTextForm({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    this.sufficIcon,
    this.prefixIcon,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.icon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
          ),
          const SizedBox(height: 10),
          TextFormField(
            readOnly: readOnly,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            enableSuggestions: true,
            decoration: InputDecoration(
              hintText: hintText,
              prefix: prefixIcon,
              suffixIcon: sufficIcon,
              prefixIcon: icon != null ? Icon(icon) : null,
              border: _buildBorder(),
              focusedBorder: _buildBorder(),
              enabledBorder: _buildBorder(),
            ),
            validator: validator,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }

  InputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
