import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:menejemen_waktu/src/Layout/profile_layout.dart';
import 'package:menejemen_waktu/src/controllers/theme_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  final themeData = Get.find<ThemeController>();

  @override
  void dispose() {
    draggableScrollableController.dispose();
    super.dispose();
    print('HomeScreen is disposed');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: profileLayout(
            topDescription: "Hi,",
            bottomDescription: "Iqbal Afnan",
          ),
          actions: [_buildThemeToggleButton()],
          titleSpacing: 16,
          elevation: 0,
        ),
        body: Container(
          color: themeData.themeDataNow().colorScheme.primary,
          child: Column(
            children: [
              _buildTaskHeader(themeData),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildThemeToggleButton() {
    return IconButton(
      onPressed: () {
        themeData.setThemeData(
          themeData.isDarkMode.value ? ThemeMode.light : ThemeMode.dark,
        );
      },
      icon: Icon(
        themeData.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
        size: 26,
      ),
    );
  }

  // Widget _showTaskFilter(List<TaskBuilder> tasks) {
  //   if (tasks.isEmpty) {
  //     return Align(
  //       alignment: Alignment.center,
  //       child: Text(
  //         "No Task",
  //         style: subHeadingTextStyle,
  //       ),
  //     );
  //   }

  //   return ListView.builder(
  //     itemCount: tasks.length,
  //     itemBuilder: (context, index) {
  //       final TaskBuilder task = tasks[index];
  //       return Container(
  //         padding: const EdgeInsets.all(2),
  //         child: _buildCard(task),
  //       );
  //     },
  //   );
  // }

  // Widget _buildCard(TaskBuilder task) {
  //   return Container(
  //     margin: const EdgeInsets.all(10),
  //     child: TaskCard(task: task),
  //   );
  // }

  Widget _buildTaskHeader(ThemeController themeData) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Today Task",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Text(
          //   taskData.taskList.isEmpty
          //       ? "No task for today"
          //       : "You have ${_filterByDate().toList().length} task for today",
          //   style: GoogleFonts.lato(
          //     textStyle: const TextStyle(
          //       fontSize: 14,
          //       fontWeight: FontWeight.w400,
          //       color: foregroundContainerColor,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

// Function to get the oldest task
  // Future<String?> getOldestTask() async {
  //   final List<TaskBuilder> tasks = taskData.taskList;
  //   if (tasks.isEmpty) return DateFormat.yMd().format(DateTime.now());

  //   // Sort tasks by date
  //   tasks.sort(
  //       (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

  //   // Return the oldest task
  //   return tasks.first.date;
  // }
}
