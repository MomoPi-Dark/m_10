import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final _taskData = Get.find<TaskController>();
  final _userData = Get.find<UserController>();
  final _themeData = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    _navData.init();
  }

  Widget _buildLoading() {
    return Container(
      color: _themeData.currentTheme.value.primaryColor,
    );
  }

  Widget _buildUserContent() {
    return FutureBuilder(
      future: _userData.initScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }

        if (snapshot.hasError) {
          return _buildError();
        }

        _taskData.initScreen();
        return const AppScreen();
      },
    );
  }

  Widget _buildGuestContent() {
    return FutureBuilder(
      future: _userData.initCloseScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }

        if (snapshot.hasError) {
          return _buildError();
        }

        _taskData.initCloseScreen();
        return const GuestScreen();
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
      body: StreamBuilder<User?>(
        initialData: AuthService().currentUser,
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildError();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
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
