import 'package:flutter/material.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class BuildFieldText extends StatefulWidget {
  final String labelText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String placeholder;
  final Icon? prefix;
  final bool readOnly;
  final Function(String) setMethod;

  const BuildFieldText({
    super.key,
    required this.labelText,
    required this.placeholder,
    required this.keyboardType,
    required this.controller,
    required this.setMethod,
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
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  InputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: createThemeColorSchema(
          lightColor: Colors.black,
          darkColor: Colors.white,
        ),
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      editable = widget.placeholder.isNotEmpty;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding - 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: customSecondaryTextColor,
              decoration: InputDecoration(
                prefixIcon: widget.prefix,
                border: _buildBorder(),
                focusedBorder: _buildBorder(),
                enabledBorder: _buildBorder(),
                errorBorder: _buildBorder(),
                hintText: widget.placeholder,
              ),
            ),
          )
          // Expanded(
          //   flex: 20,
          //   child: TextField(
          //     readOnly: widget.readOnly,
          //     canRequestFocus: false,
          //     keyboardType: widget.keyboardType,
          //     decoration: InputDecoration(
          //       border: const UnderlineInputBorder(
          //         borderRadius: BorderRadius.all(
          //           Radius.elliptical(10, 6.6),
          //         ),
          //         borderSide: BorderSide(
          //           width: 2.0,
          //         ),
          //       ),
          //       hintText: widget.placeholder,
          //       labelText: widget.labelText,
          //       floatingLabelBehavior: FloatingLabelBehavior.always,
          //       hintStyle: const TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black,
          //       ),
          //       prefixIcon: Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 20),
          //         child: widget.prefix,
          //       ),
          //       suffixIcon: Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 10),
          //         child: IconButton(
          //           onPressed: () {
          //             showDialog(
          //               context: context,
          //               builder: (builder) {
          //                 return Form(
          //                   key: _formKey,
          //                   child: AlertDialog(
          //                     title: editable
          //                         ? Text("Edit ${widget.labelText}")
          //                         : Text("Add ${widget.labelText}"),
          //                     content: TextFormField(
          //                       controller: widget.controller,
          //                       keyboardType: widget.keyboardType,
          //                       decoration: InputDecoration(
          //                         hintText: widget.placeholder,
          //                         border: const UnderlineInputBorder(
          //                           borderRadius: BorderRadius.all(
          //                             Radius.elliptical(10, 6.6),
          //                           ),
          //                           borderSide: BorderSide(
          //                             width: 2.0,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     actions: [
          //                       TextButton(
          //                         onPressed: () {
          //                           setState(() {
          //                             _formKey.currentState!.reset();
          //                             Navigator.of(context).pop();
          //                           });
          //                         },
          //                         child: const Text("Cancel"),
          //                       ),
          //                       TextButton(
          //                         onPressed: () {
          //                           final value1 = widget.controller.text;

          //                           setState(() {
          //                             if (value1.isNotEmpty) {
          //                               widget.setMethod(value1);
          //                             }

          //                             _formKey.currentState!.reset();
          //                             Navigator.of(context).pop();
          //                           });
          //                         },
          //                         child: const Text("Save"),
          //                       ),
          //                     ],
          //                   ),
          //                 );
          //               },
          //             );
          //           },
          //           icon: Text(
          //             editable ? "Edit" : "Add ${widget.labelText}",
          //             style: const TextStyle(
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           padding: const EdgeInsets.symmetric(
          //             horizontal: 16.0,
          //             vertical: 16.0,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
