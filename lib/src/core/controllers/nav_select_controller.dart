import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/ui/custom/create_bar.dart';
import 'package:menejemen_waktu/src/ui/screens/mobile/main/calendar_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/mobile/main/home_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/mobile/main/search_screen.dart';

class NavSelectController extends GetxController {
  final RxInt _selectedIndex = (0).obs;

  int get selectedIndex => _selectedIndex.value;

  Future<void> init() async {
    _selectedIndex.value = 0;
  }

  void changeDestination(int index) async {
    await Future.delayed(const Duration(milliseconds: 1));
    _selectedIndex.value = index;
  }

  Widget getScreen() {
    switch (selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CalendarScreen();
      case 2:
        return const SearchScreen();
      default:
        return const Scaffold(
          body: SafeArea(
            child: Center(
              child: Text("Error: Screen not found"),
            ),
          ),
        );
    }
  }

  RxList<NavigationDestination> get destinations => [
        createNavDestination(
          icon: EneftyIcons.home_2_outline,
          selectedIcon: EneftyIcons.home_2_bold,
          label: 'Home',
        ),
        createNavDestination(
          icon: EneftyIcons.calendar_2_outline,
          selectedIcon: EneftyIcons.calendar_2_bold,
          label: 'Calendar',
        ),
        createNavDestination(
          icon: EneftyIcons.search_normal_2_outline,
          selectedIcon: EneftyIcons.search_status_2_bold,
          label: 'Search',
        ),
        createNavDestination(
          icon: EneftyIcons.more_circle_outline,
          selectedIcon: EneftyIcons.more_circle_bold,
          label: "More",
        ),
      ].obs;
}
