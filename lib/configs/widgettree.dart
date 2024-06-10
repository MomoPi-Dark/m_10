import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:menejemen_waktu/src/app.dart';
import 'package:menejemen_waktu/src/screen/pages/Login/login_screen.dart';

class WidgetThree extends StatefulWidget {
  const WidgetThree({super.key});

  @override
  State<WidgetThree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const LoginScreen();
          } else {
            return const AppScreen();
          }
        },
      ),
    );
  }
}
