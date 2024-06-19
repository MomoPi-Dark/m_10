import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Get.offAllNamed("/login");
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
          ),
          child: Text(
            "Login".toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Get.offAllNamed("/signup");
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
          ),
          child: Text(
            "Sign Up".toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
