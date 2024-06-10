import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/screen/pages/Home/screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final themeData = Get.find<ThemeController>();

  int _bottomNavIndex = 0;

  final List<IconData> iconList = [
    FontAwesomeIcons.clipboardCheck,
    Icons.calendar_today,
    Icons.info,
    Icons.settings,
  ];

  final itemList = [
    SalomonBottomBarItem(
      icon: const Icon(FontAwesomeIcons.clipboardCheck),
      title: const Text("Todo"),
      selectedColor: Colors.purple,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.calendar_today),
      title: const Text("Calendar"),
      selectedColor: Colors.orange,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.info),
      title: const Text("Info"),
      selectedColor: Colors.red,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.settings),
      title: const Text("Settings"),
      selectedColor: Colors.blue,
    ),
  ];

  final List<Widget> _screens = [
    HomeScreen(),
    Container(),
    Container(),
    Container(),
  ];

  late Widget currentScreen;

  void _onScreenTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
      currentScreen = _screens[index];
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeData.isDarkMode() ? Colors.black : Colors.white,
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
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheet(context),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        itemPadding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 800),
        currentIndex: _bottomNavIndex,
        onTap: _onScreenTapped,
        items: itemList,
        unselectedItemColor: Colors.grey,
      ),
      body: _screens[_bottomNavIndex],
    );
  }
}
