import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/routes.dart';
import 'package:menejemen_waktu/src/core/controllers/nav_select_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> with WidgetsBindingObserver {
  final navData = Get.find<NavSelectController>();
  final taskData = Get.find<TaskController>();
  final themeData = Get.find<ThemeController>();
  final userData = Get.find<UserController>();

  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser == null) {
      Get.snackbar("Error messages", "You are not logged in!");
      Get.offAllNamed(initialRoute);
    }
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() {
      return NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: themeData.currentTheme().colorScheme.secondary,
          indicatorColor: customBottomNavbarIndicatorLayoutColor,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return navBarTextStyle.copyWith(
                  color: customBottomNavbarIconSelectedLayoutColor,
                );
              }
              return navBarTextStyle;
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
        child: Container(
          color: themeData.currentTheme().colorScheme.primary,
          child: NavigationBar(
            destinations: navData.destinations,
            onDestinationSelected: (i) {
              navData.changeDestination(i);
            },
            selectedIndex: navData.selectedIndex,
            animationDuration: const Duration(milliseconds: 200),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
        child: Scaffold(
          backgroundColor: themeData.currentTheme().colorScheme.primary,
          bottomNavigationBar: _buildBottomNavigationBar(),
          floatingActionButton: Obx(() {
            return FloatingActionButton(
              backgroundColor: defaultContainerSecondaryLayoutColor,
              onPressed: () {
                Get.toNamed(
                  '/addtask',
                );
              },
              child: Icon(
                FontAwesomeIcons.plus,
                color: customPrimaryTextColor,
                size: 20,
              ),
            );
          }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          body: PageTransitionSwitcher(
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.vertical,
                child: child,
              );
            },
            duration: const Duration(seconds: 1),
            child: Container(
              key: ValueKey(navData.selectedIndex),
              color: themeData.currentTheme().colorScheme.secondary,
              child: navData.getScreen(),
            ),
          ),
        ),
      );
    });
  }
}
