import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menejemen_waktu/routes.dart';
import 'package:menejemen_waktu/src/core/controllers/nav_select_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/ui/screens/_layout/loadtasks_layout.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/layout_screen.dart';
import 'package:menejemen_waktu/src/ui/widgets/taskcard.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.2.0.dart';
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
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchItem(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Upcoming Schedule",
                  style: bodyTitleTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {
                    navData.changeDestination(1);
                  },
                  icon: Text(
                    "View All",
                    style: bodyTitleTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _buildItems(),
          ),
        ],
      ),
    );
  }

  Widget _buildItems() {
    return LoadTasks(
      buildDoneChild: () {
        final tasks = taskData.getTasks();

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
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: TaskCard(
                task: task,
              ),
            );
          },
        );
      },
    );
  }

  Widget _searchItem() {
    return Obx(() {
      return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: TextField(
          readOnly: true,
          keyboardType: TextInputType.text,
          onTap: () {
            setState(() {
              Get.toNamed(cr("search"));
            });
          },
          cursorColor: customSecondaryTextColor,
          decoration: InputDecoration(
            fillColor: defaultContainerSecondaryLayoutColor,
            filled: true,
            prefixIcon: Icon(
              Icons.search_rounded,
              color: defaultTextPrimaryLayoutColor,
            ),
            hintText: "Search...",
            hintStyle: GoogleFonts.karla(
              color: defaultTextPrimaryLayoutColor,
              fontWeight: FontWeight.w500,
            ),
            hoverColor: customSecondaryLayoutColor,
            border: _buildBorder(),
            enabledBorder: _buildBorder(),
            disabledBorder: _buildBorder(),
            suffixIconColor: defaultTextPrimaryLayoutColor,
            prefixIconColor: defaultTextPrimaryLayoutColor,
            counterStyle: TextStyle(color: customSecondaryTextColor),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      title: _buildTitle(),
      toolbarHeight: 85.0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              "assets/images/person2.jpg",
            ),
          ),
        ),
      ],
      bodyChild: _buildBody(),
    );
  }
}
