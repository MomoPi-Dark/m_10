import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/sub/profile/components/profile_avatar.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/sub/profile/components/textfield.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  final _userData = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    final user = _userData.currentUser;

    if (user != null) {
      _nameController.text = user.displayName;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: appBarTitleStyle,
        ),
      ),
      body: Container(
        padding: defaultPaddingHorizontal,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const ProfileAvatar(),
            const SizedBox(height: 40),
            BuildFieldText(
              prefix: const Icon(Iconsax.user),
              readOnly: true,
              labelText: "Name",
              placeholder: "Enter your name",
              keyboardType: TextInputType.text,
              controller: _nameController,
              onSubmit: (_) {},
            ),
            BuildFieldText(
              readOnly: true,
              prefix: const Icon(Icons.mail_outline),
              labelText: "Email",
              placeholder: "Enter your email",
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              onSubmit: (_) {},
            ),
            BuildFieldText(
              readOnly: true,
              prefix: const Icon(Icons.phone_in_talk),
              labelText: "Phone",
              placeholder: "Enter your phone number",
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              onSubmit: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
