import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({
    super.key,
    required this.title,
    required this.bodyChild,
    this.centerTitle,
    this.bottom,
    this.toolbarHeight = 70.0,
    this.leading,
    this.actions,
  });

  final Widget bodyChild;
  final PreferredSize? bottom;
  final double toolbarHeight;
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
        title: SafeArea(child: widget.title),
        centerTitle: widget.centerTitle,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Obx(() {
            return Container(
              color: createThemeColorSchema(
                lightColor: DarkColor.secondary().withOpacity(0.2),
                darkColor: LightColor.secondary().withOpacity(0.2),
              ),
              height: 1.0,
            );
          }),
        ),
        toolbarHeight: widget.toolbarHeight,
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
            const EdgeInsets.only(top: 20),
          ),
          child: widget.bodyChild,
        ),
      ),
    );
  }
}
