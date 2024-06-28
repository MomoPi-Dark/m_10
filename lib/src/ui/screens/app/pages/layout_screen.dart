import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({
    super.key,
    required this.title,
    required this.bodyChild,
    this.centerTitle,
    this.bottom,
    this.leading,
    this.actions,
  });

  final Widget bodyChild;
  final PreferredSize? bottom;

  final Widget title;
  final bool? centerTitle;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  State<LayoutScreen> createState() => _TopLayout();
}

class _TopLayout extends State<LayoutScreen> {
  final themeData = Get.find<ThemeController>();
  final User? user = AuthService().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        centerTitle: widget.centerTitle,
        toolbarHeight: 85.0,
        actions: widget.actions,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: defaultPaddingHorizontal.add(
            const EdgeInsets.only(top: defaultPadding),
          ),
          child: widget.bodyChild,
        ),
      ),
    );
  }
}
