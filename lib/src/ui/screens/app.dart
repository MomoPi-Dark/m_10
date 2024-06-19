
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/routes.dart';
import 'package:menejemen_waktu/src/core/controllers/nav_select_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final navData = Get.find<NavSelectController>();
  final taskData = Get.find<TaskController>();
  final themeData = Get.find<ThemeController>();

  final AuthService _auth = AuthService();
  final UserController _user = Get.find<UserController>();

  @override
  void initState() {
    if (_auth.currentUser == null) {
      Get.snackbar("Error messages", "You are not logged in!");
      Get.offAllNamed(initialRoute);
    }
    super.initState();
  }

  // Start: Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: customPrimaryLayoutColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(child: _buildDrawerHeader()),
          const Divider(
            color: Colors.black,
          ),
          Expanded(
            child: _buildDrawerItems(),
          ),
          _buildDarkModeSwitch(),
          _buildSignOutButton(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
    );
  }

  Widget _buildDrawerItems() {
    return ListView(
      children: [
        _buildDrawerItem(
          icon: const Icon(FontAwesomeIcons.user),
          label: const Text("Profile"),
          onTap: () {
            Get.back();
          },
        ),
        _buildDrawerItem(
          icon: const Icon(FontAwesomeIcons.gear),
          label: const Text("Settings"),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required Widget icon,
    required Widget label,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: icon,
      title: label,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDarkModeSwitch() {
    return _buildDrawerItem(
      icon: const Icon(Icons.dark_mode),
      label: const Text("Dark Mode"),
      trailing: Transform.scale(
        scale: 0.8,
        child: Switch(
          value: themeData.isDarkMode(),
          onChanged: (value) {
            themeData.setThemeData(value ? ThemeMode.dark : ThemeMode.light);
          },
          activeTrackColor: light2,
          activeColor: dark2,
          inactiveTrackColor: dark2,
          inactiveThumbColor: light2,
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildSignOutButton() {
    return _buildDrawerItem(
        icon: const Icon(FontAwesomeIcons.rightFromBracket),
        label: const Text("Sign Out"),
        onTap: () async {
          _user.logout();
        });
  }

  // End: Drawer

  // Start: Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: themeData.currentTheme().colorScheme.primary,
        indicatorColor: customBottomNavbarIndicatorLayoutColor,
        height: 100,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return navBarTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              );
            }
            return navBarTextStyle.copyWith(
              fontWeight: FontWeight.w100,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(
                color: customBottomNavbarIconSelectedLayoutColor,
              );
            }

            return IconThemeData(
              color: customBottomNavbarIconUnSelectedLayoutColor,
            );
          },
        ),
      ),
      child: NavigationBar(
        destinations: _buildNavigationDestinations(),
        onDestinationSelected: _onSelected,
        selectedIndex: navData.selectedIndex,
        animationDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  List<NavigationDestination> _buildNavigationDestinations() {
    return navData.destinations.map((destination) {
      return NavigationDestination(
        icon: _buildIcon(destination.icon),
        label: destination.label,
        selectedIcon: _buildIcon(destination.selectedIcon ?? destination.icon),
      );
    }).toList();
  }

  Widget _buildIcon(Widget icon) {
    return Transform.scale(
      scale: 1.0,
      alignment: Alignment.center,
      child: icon,
    );
  }

  // End: Bottom Navigation Bar

  void _onSelected(int index) {
    setState(() {
      navData.changeDestination(index);
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: customPrimaryLayoutColor,
      enableDrag: true,
      showDragHandle: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      elevation: 5,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.8,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                children: const [
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: customSecondaryLayoutColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showBottomSheet(context);
          },
          child: Icon(
            Icons.add,
            color: customAppBarTextLayoutColor,
          ),
        ),
        drawer: _buildDrawer(context),
        bottomNavigationBar: _buildBottomNavigationBar(),
        resizeToAvoidBottomInset: false,
        body: navData.getScreen(),
      );
    });
  }
}
