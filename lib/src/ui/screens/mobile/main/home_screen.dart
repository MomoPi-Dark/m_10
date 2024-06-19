import 'dart:async';

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:menejemen_waktu/src/core/controllers/nav_select_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/core/models/tasks_item_builder.dart';
import 'package:menejemen_waktu/src/ui/custom/create_bar.dart';
import 'package:menejemen_waktu/src/ui/screens/mobile/layout/layout_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/mobile/layout/loadtasks_layout.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final navData = Get.find<NavSelectController>();
  final taskData = Get.find<TaskController>();
  final userData = Get.find<UserController>();
  final themeData = Get.find<ThemeController>();

  final int _countNotif = 500;
  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();

  late String _timeFormat;
  late Timer _timer;

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initTitleUpdate();
  }

  Future<String?> getOldestTask() async {
    final List<TaskItemBuilder> tasks = taskData.tasks;
    if (tasks.isEmpty) return DateFormat.yMd().format(DateTime.now());

    // Sort tasks by date
    tasks.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    // Return the oldest task
    return tasks.first.date;
  }

  Widget _buildBody() {
    return Container(
      padding: defaultPaddingHorizontal,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Today Task",
                    style: bodyTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  navData.changeDestination(1);
                },
                icon: Text(
                  "View All",
                  style: bodyTextStyle.copyWith(
                    fontSize: 13,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: _showTaskFilter()),
        ],
      ),
    );
  }

  Widget _showTaskFilter() {
    return Obx(() {
      return LoadTasksLayout(
        doneChild: _buildTaskList(),
      );
    });
  }

  Widget _buildTaskList() {
    final tasks = taskData.tasks;

    if (tasks.isEmpty) {
      return Center(
        child: Text(
          "No task available",
          style: bodyTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Text(task.title);
      },
    );
  }

  void _initTitleUpdate() {
    _updateTime();

    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);
    _timer = Timer(durationUntilMidnight, _scheduleDailyUpdate);
  }

  void _scheduleDailyUpdate() {
    _updateTime();
    _timer =
        Timer.periodic(const Duration(days: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      _timeFormat = DateFormat("E, MMM dd").format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return LayoutScreen(
        title: Text(
          _timeFormat,
          style: appBarTitleStyle,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: createIconNotif(
              right: 11,
              top: 10,
              icon: IconButton(
                onPressed: () {},
                icon: Icon(
                  EneftyIcons.notification_outline,
                  size: defaultSizeIconAppBar,
                  color: customAppBarIconLayoutColor,
                ),
              ),
              countNotif: _countNotif,
            ),
          )
        ],
        bodyChild: _buildBody(),
      );
    });
  }
}
