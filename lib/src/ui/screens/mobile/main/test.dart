import 'package:flutter/material.dart';
import 'package:menejemen_waktu/src/ui/screens/mobile/layout/layout_screen.dart';

class TestW extends StatefulWidget {
  const TestW({super.key});

  @override
  State<TestW> createState() => _TestWState();
}

class _TestWState extends State<TestW> {
  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      bodyChild: Container(),
    );
  }
}
