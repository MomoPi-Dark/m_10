import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/nav_select_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/ui/screens/app/app.dart';
import 'package:menejemen_waktu/src/ui/screens/guest/guest.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _navData = Get.find<NavSelectController>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final _taskData = Get.find<TaskController>();
  final _themeData = Get.find<ThemeController>();
  final _userData = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _themeData.setUIColor();
    _navData.init();
  }

  Widget _blankScreen() {
    final themeData = Get.find<ThemeController>();

    return Obx(() {
      // // Set the status bar to be invisible when this screen is displayed
      // SystemChrome.setSystemUIOverlayStyle(
      //   SystemUiOverlayStyle.dark.copyWith(
      //     statusBarColor: Colors.transparent,
      //     statusBarIconBrightness: Brightness.light,
      //   ),
      // );

      return Scaffold(
        backgroundColor: themeData.currentTheme().primaryColor,
        body: Center(
          child: Image.asset(
            'assets/images/pp.jpg', // Replace with your image asset path
            fit: BoxFit.contain,
          ),
        ),
      );
    });
  }

  Widget _buildUserContent() {
    return FutureBuilder(
      future: _userData.initUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildError();
        }

        return Obx(() {
          if (!_userData.isLoggedIn()) return _blankScreen();

          _taskData.initScreen();
          return const AppScreen();
        });
      },
    );
  }

  Widget _buildGuestContent() {
    return FutureBuilder(
      future: _userData.initCloseUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildError();
        }

        return Obx(() {
          if (_userData.isLoggedIn()) return _blankScreen();

          return const GuestScreen();
        });
      },
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text('An error occurred'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: _themeData.currentTheme().colorScheme.primary,
      body: StreamBuilder<User?>(
        key: _navigatorKey,
        initialData: AuthService().currentUser,
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log('Error: ${snapshot.error}');
            return _buildError();
          }

          if (snapshot.hasData) {
            return _buildUserContent();
          } else {
            return _buildGuestContent();
          }
        },
      ),
    );
  }
}
