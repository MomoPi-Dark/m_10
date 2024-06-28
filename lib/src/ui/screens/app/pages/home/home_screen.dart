import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:menejemen_waktu/src/core/controllers/nav_select_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/ui/screens/_layout/loadtasks_layout.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/layout_screen.dart';
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
  final themeData = Get.find<ThemeController>();
  final userData = Get.find<UserController>();

  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    log("HomeScreen initialized");
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();

    log("HomeScreen disposed");
  }

  OutlineInputBorder _buildBorder({
    Color? color,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color ?? defaultCustomPrimaryLayoutColor,
      ),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Good Morning,",
          style: bodyTextStyle.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          userData.currentUser!.displayName,
          style: bodyTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _searchItem(),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Schedule Today",
            style: GoogleFonts.varelaRound().copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: _buildItems(),
        ),
      ],
    );
  }

  Widget _buildItems() {
    return LoadTasks(
      buildDoneChild: () {
        final tasks = taskData.getTasks(
          limit: 5,
        );

        if (tasks.isEmpty) {
          return Center(
            child: Text(
              "No tasks found",
              style: bodyTextStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            var task = tasks[index];

            return ListTile(
              title: Text(
                task.title,
                style: bodyTextStyle.copyWith(),
              ),
              onTap: () {
                Get.toNamed(
                  "/getinfo",
                  arguments: task.toJson(),
                );
              },
              leading: Checkbox(
                fillColor: WidgetStateProperty.all<Color>(Colors.blue),
                value: task.isCompleted == 1 ? true : false,
                onChanged: (value) {
                  setState(() {
                    task.isCompleted = value == true ? 1 : 0;
                    taskData.updateTask(task);
                    log("Task is completed: $value");
                  });
                },
              ),
              subtitle: Text(
                task.note,
                style: bodyTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _searchItem() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextField(
        readOnly: true,
        keyboardType: TextInputType.text,
        onTap: () {
          setState(() {
            Get.toNamed("/search");
          });
        },
        cursorColor: customSecondaryTextColor,
        decoration: InputDecoration(
          fillColor: defaultCustomPrimaryLayoutColor,
          filled: true,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Colors.grey,
          ),
          hintText: "Search...",
          hintStyle: GoogleFonts.karla(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          hoverColor: customSecondaryLayoutColor,
          border: _buildBorder(),
          enabledBorder: _buildBorder(),
          disabledBorder: _buildBorder(),
          suffixIconColor: Colors.grey,
          prefixIconColor: Colors.grey,
          counterStyle: TextStyle(color: customSecondaryTextColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      title: _buildTitle(),
      actions: [
        IconButton(
            onPressed: () async {
              await userData.logout();
            },
            icon: Icon(Iconsax.logout)),
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: const CircleAvatar(
            backgroundImage: AssetImage("assets/images/person2.jpg"),
            radius: 25,
          ),
        ),
      ],
      bodyChild: _buildBody(),
    );
  }
}
