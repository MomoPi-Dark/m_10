import 'package:flutter/material.dart';

class BuildFieldTextAddList extends StatefulWidget {
  const BuildFieldTextAddList({
    super.key,
    this.formKey,
    required this.placeholder,
    required this.keyboardType,
    required this.controller,
    this.prefixIcon,
    this.sufficIcon,
  });

  final TextEditingController controller;
  final GlobalKey<FormState>? formKey;
  final TextInputType keyboardType;
  final String? placeholder;
  final Widget? prefixIcon;
  final Widget? sufficIcon;

  @override
  State<BuildFieldTextAddList> createState() => _BuildFieldTextAddListState();
}

class _BuildFieldTextAddListState extends State<BuildFieldTextAddList> {
  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.formKey != null) {
        _formKey = widget.formKey!;
      }
    });

    return Padding(
      key: _formKey,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.placeholder,
          border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.elliptical(10, 6.6),
            ),
            borderSide: BorderSide(
              width: 2.0,
            ),
          ),
          suffixIcon: widget.sufficIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: widget.sufficIcon,
                )
              : null,
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: widget.prefixIcon,
                )
              : null,
        ),
      ),
    );
  }
}
