import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class BuildFieldText extends StatefulWidget {
  final String labelText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String placeholder;
  final Icon? prefix;
  final bool readOnly;
  final Function(String) onSubmit;

  const BuildFieldText({
    super.key,
    required this.labelText,
    required this.placeholder,
    required this.keyboardType,
    required this.controller,
    required this.onSubmit,
    this.readOnly = false,
    this.prefix,
  });

  @override
  State<BuildFieldText> createState() => _BuildFieldTextState();
}

class _BuildFieldTextState extends State<BuildFieldText> {
  final _formKey = GlobalKey<FormState>();

  bool editable = false;

  @override
  void initState() {
    super.initState();
    editable = widget.placeholder.isNotEmpty;
  }

  InputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding - 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              readOnly: widget.readOnly,
              controller: widget.controller,
              cursorColor: customSecondaryTextColor,
              decoration: InputDecoration(
                fillColor: defaultContainerSecondaryLayoutColor,
                filled: true,
                prefixIcon: widget.prefix,
                border: _buildBorder(),
                focusedBorder: _buildBorder(),
                enabledBorder: _buildBorder(),
                errorBorder: _buildBorder(),
                hintText: widget.placeholder,
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Form(
                            key: _formKey,
                            child: AlertDialog(
                              title: Text(
                                editable
                                    ? "Edit ${widget.labelText}"
                                    : "Add ${widget.labelText}",
                                style: TextStyle(
                                  color: defaultTextPrimaryLayoutColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              content: TextFormField(
                                cursorColor: customPrimaryTextColor,
                                controller: widget.controller,
                                keyboardType: widget.keyboardType,
                                decoration: InputDecoration(
                                  hintText: widget.placeholder,
                                  border: _buildBorder(),
                                  focusedBorder: _buildBorder(),
                                  enabledBorder: _buildBorder(),
                                  errorBorder: _buildBorder(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _formKey.currentState!.reset();
                                    Get.back();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: defaultTextPrimaryLayoutColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final value = widget.controller.text;
                                    if (value.isNotEmpty) {
                                      widget.onSubmit(value);
                                    }
                                    _formKey.currentState!.reset();
                                    Get.back();
                                  },
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      color: defaultTextPrimaryLayoutColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Text(
                      editable ? "Edit" : "Add ${widget.labelText}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
