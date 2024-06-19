import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/nav_select_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/ui/screens/app.dart';
import 'package:menejemen_waktu/src/ui/screens/mobile/auth/welcome_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _taskData = Get.find<TaskController>();
  final _userData = Get.find<UserController>();
  final _navData = Get.find<NavSelectController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      extendBody: true,
      body: StreamBuilder<User?>(
        initialData: AuthService().currentUser,
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );

            case ConnectionState.active:
            case ConnectionState.done:
              _navData.init();

              if (snapshot.hasData) {
                return FutureBuilder(
                  future: _userData.initScreen(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      _taskData.initScreen();
                      return const AppScreen();
                    }
                  },
                );
              } else {
                return FutureBuilder(
                  future: _userData.initCloseScreen(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      _taskData.initCloseScreen();
                      return const WelcomeScreen();
                    }
                  },
                );
              }

            default:
              return const Center(
                child: Text('An error occurred'),
              );
          }
        },
      ),
    );
  }
}
