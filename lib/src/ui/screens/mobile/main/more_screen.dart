import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/ui/screens/mobile/layout/layout_screen.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LayoutScreen(
        title: Text(
          "More",
          style: appBarTitleStyle,
        ),
        bodyChild: const Text("More Screen"),
      );
    });
  }
}
