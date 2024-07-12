import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
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

  // final _formKey = GlobalKey<FormState>();

  final _userData = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    final user = _userData.currentUser!;
    _nameController.text = user.displayName;
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber;
  }

  @override
  void dispose() {
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
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/person2.jpg"),
            ),
            const SizedBox(height: 20),
            BuildFieldText(
              prefix: const Icon(Iconsax.user),
              readOnly: true,
              labelText: "Name",
              placeholder: "Enter your name",
              keyboardType: TextInputType.text,
              controller: _nameController,
              setMethod: (_) {},
            ),
            BuildFieldText(
              readOnly: true,
              labelText: "Email",
              placeholder: "Enter your email",
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              setMethod: (_) {},
            ),
            BuildFieldText(
              readOnly: true,
              labelText: "Phone",
              placeholder: "Enter your phone number",
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              setMethod: (_) {},
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
