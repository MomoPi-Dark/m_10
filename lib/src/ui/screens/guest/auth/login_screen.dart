import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/ui/screens/_layout/title_app.dart';
import 'package:menejemen_waktu/src/ui/widgets/custom_button.dart';
import 'package:menejemen_waktu/src/ui/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final themeData = Get.find<ThemeController>();
  final formKey = GlobalKey<FormState>();

  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _user = Get.find<UserController>();

  bool _showPassword = true;
  bool _isPasswordNotValid = false;
  bool _isEmailNotValid = false;

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isEmailNotValid = false;
      _isPasswordNotValid = false;
    });

    if (_email.text.isEmpty || _password.text.isEmpty) {
      Get.snackbar("Login Errors", "Email or Password is empty",
          backgroundColor: Colors.red);
      return;
    }

    try {
      await _user.login(_email.text, _password.text);
    } catch (e) {
      setState(() {
        _isEmailNotValid = true;
        _isPasswordNotValid = true;
      });

      _email.clear();
      _password.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const TitleApp(),
      ),
      body: FormField(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  CustomTextField(
                    prefixIcon: const Icon(
                      Iconsax.user_tag,
                      color: Colors.grey,
                    ),
                    hint: "Enter Email",
                    label: "Email",
                    controller: _email,
                    errorText: _isEmailNotValid ? "Email is not valid" : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    prefixIcon: const Icon(
                      Iconsax.lock,
                      color: Colors.grey,
                    ),
                    hint: "Enter Password",
                    label: "Password",
                    controller: _password,
                    isPassword: _showPassword,
                    errorText:
                        _isPasswordNotValid ? "Password is not valid" : null,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword ? Iconsax.eye_slash : Iconsax.eye,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(label: "Login", onPressed: _login),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("You don't have an account? "),
                      InkWell(
                        onTap: () => Get.toNamed("/signup"),
                        child: const Text(
                          "Signup",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
