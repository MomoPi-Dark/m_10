import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/routes.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/core/models/user_builder.dart';
import 'package:menejemen_waktu/src/ui/screens/_layout/title_app.dart';
import 'package:menejemen_waktu/src/ui/widgets/custom_button.dart';
import 'package:menejemen_waktu/src/ui/widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _user = Get.find<UserController>();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  void _signup() async {
    var displayName = _name.text;
    var email = _email.text;
    var password = _password.text;

    if (displayName.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Signup Errors",
        "Name, Email or Password is empty",
        backgroundColor: Colors.red,
      );
      return;
    }

    final userCreate = UserBuilder(
      email: email,
      displayName: displayName,
    );

    await _user.signup(userCreate, password);

    Get.toNamed(cr("login"));

    Get.snackbar(
      "Signup Success",
      "You have successfully signed up!",
      backgroundColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleApp(),
      ),
      body: FormField(
        key: formKey,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  CustomTextField(
                    hint: "Enter Name",
                    label: "Name",
                    controller: _name,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hint: "Enter Email",
                    label: "Email",
                    controller: _email,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hint: "Enter Password",
                    label: "Password",
                    isPassword: true,
                    controller: _password,
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    label: "Signup",
                    onPressed: _signup,
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      InkWell(
                        onTap: () => Get.toNamed(cr('login')),
                        child: const Text(
                          "Signin",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
