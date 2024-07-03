import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/core/models/tasks_item_builder.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

import '../../../routes.dart';

final timeFormat = DateFormat('hh:mm a');

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.width,
    this.height,
  });

  final double? height;
  final TaskItemBuilder task;
  final double? width;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final _themeData = Get.find<ThemeController>();

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 20,
            decoration: BoxDecoration(
              color: colorList[widget.task.color],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            labelItem[widget.task.label],
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              color: colorList[widget.task.color],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPopupMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: _themeData.isDarkMode() ? Colors.white : Colors.grey[700],
      ),
      onSelected: (result) async {
        if (result == "edit") {
          Get.toNamed(cr("edittask"), arguments: widget.task);
        } else if (result == "delete") {
          try {
            await Get.find<TaskController>().deleteTask(widget.task);

            Get.snackbar(
              "Task deleted",
              "Task ${widget.task.title} deleted",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } catch (e) {
            // log("Error deleting task: $e");

            Get.snackbar(
              "Error deleting task",
              "Error deleting task: $e",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: Text(
              'Edit',
              style: TextStyle(
                color: _themeData.isDarkMode() ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: const Icon(Icons.delete),
            title: Text(
              'Delete',
              style: TextStyle(
                color: _themeData.isDarkMode() ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final startTimeStr = widget.task.startTime;
    final endTimeStr = widget.task.endTime;

    final format = DateFormat(dateTimeTaskFormat);
    DateTime startTime = format.parse(startTimeStr);
    DateTime endTime = format.parse(endTimeStr);

    return Obx(() {
      return Container(
        padding: const EdgeInsets.only(
          left: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                color:
                    _themeData.isDarkMode() ? Colors.white : Colors.grey[700],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 18, right: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${timeFormat.format(startTime)} - ${timeFormat.format(endTime)}",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      color: _themeData.isDarkMode()
                          ? Colors.white
                          : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: widget.width ?? MediaQuery.of(context).size.width - 120,
        height: widget.height ?? MediaQuery.of(context).size.height / 6.5,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          color: _themeData.currentTheme().colorScheme.secondary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  _buildPopupMenuButton(),
                ],
              ),
            ),
            ListBody(
              children: [
                _buildContent(),
              ],
            )
          ],
        ),
      );
    });
  }
}
