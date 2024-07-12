import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menejemen_waktu/routes.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/ui/screens/_components/welcome_image.dart';
import 'package:menejemen_waktu/src/ui/screens/_layout/title_app.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> with WidgetsBindingObserver {
  final themeData = Get.find<ThemeController>();
  final userData = Get.find<UserController>();

  @override
  void initState() {
    if (userData.currentUser != null) {
      Get.offNamed("/app");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleApp(),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Column(
              children: [
                const WelcomeImage(),
                Text(
                  "GET YOUR ORGANIZED YOUR TIME",
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Planify is a powerful and intuitive app designed to help you manage your tasks and organize your schedule efficiently.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
            const Spacer(
              flex: 4,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    yellow3,
                    orange,
                    Color(0xFFFF5F00),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(cr('login'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Get Started",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: customSecondaryTextColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
