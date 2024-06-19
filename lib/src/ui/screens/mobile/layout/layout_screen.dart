import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({
    super.key,
    required this.bodyChild,
    this.title,
    this.bottom,
    this.leading,
    this.actions,
  });

  final List<Widget>? actions;
  final Widget bodyChild;
  final PreferredSize? bottom;
  final Widget? leading;
  // Deprecated: Use HeaderLayout instead
  final Widget? title;

  @override
  State<LayoutScreen> createState() => _TopLayout();
}

class _TopLayout extends State<LayoutScreen> {
  final themeData = Get.find<ThemeController>();
  final User? user = AuthService().currentUser;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: themeData.currentTheme().colorScheme.primary,
          title: SafeArea(
            child: widget.title ?? Container(),
          ),
          centerTitle: true,
          toolbarHeight: 85.0,
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.barsStaggered,
              size: defaultSizeIconAppBar - 2,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          actions: widget.actions,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        extendBody: false,
        body: SafeArea(
          child: Container(
            color: themeData.currentTheme().colorScheme.secondary,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: widget.bodyChild,
          ),
        ),
      );
    });
  }
}
