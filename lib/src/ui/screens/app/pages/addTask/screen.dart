import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/models/tasks_item_builder.dart';
import 'package:menejemen_waktu/src/core/services/notification/notify_helper.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/AddTask/Components/colorform.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/AddTask/Components/textform.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/addTask/components/addbutton.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

final timeFormat = DateFormat('hh:mm a');

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    super.key,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TaskController taskController = Get.put(TaskController());
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskNoteController = TextEditingController();

  String _endTime = DateFormat(dateTimeTaskFormat)
      .format(
        DateTime.now().add(
          const Duration(minutes: 5),
        ),
      )
      .toString();

  int _selectedColor = 0;
  DateTime _selectedDate = DateTime.now();
  String _startTime =
      DateFormat(dateTimeTaskFormat).format(DateTime.now()).toString();

  @override
  void dispose() {
    taskNameController.dispose();
    taskNoteController.dispose();
    super.dispose();
  }

  Future<TaskItemBuilder> _addTaskDB() async {
    var task = TaskItemBuilder(
      title: taskNameController.text,
      label: taskNameController.text,
      note: taskNoteController.text,
      date: DateFormat(dateTaskFormat).format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      isTimeExceeded: 0,
      remind: 0,
      repeat: "None",
    );

    await taskController.addTask(task);

    return task;
  }

  bool _validate() {
    if (taskNameController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Task Name is required",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return true;
    }

    if (taskNoteController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Task Note is required",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return true;
    }

    try {
      final DateTime startDateFormat =
          DateFormat(dateTimeTaskFormat).parse(_startTime);
      final DateTime endDateFormat =
          DateFormat(dateTimeTaskFormat).parse(_endTime);

      if (endDateFormat.isBefore(startDateFormat)) {
        Get.snackbar(
          "Error",
          "End Time must be greater than Start Time",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return true;
      }
    } catch (e) {
      log("Error parsing time: $e");

      Get.snackbar(
        "Error",
        "Invalid time format",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    DateTime startTimeFormat;
    DateTime endTimeFormat;

    try {
      startTimeFormat = DateFormat(dateTimeTaskFormat).parse(_startTime);
      endTimeFormat = DateFormat(dateTimeTaskFormat).parse(_endTime);
    } catch (e) {
      log("Error parsing time on build: $e");
      startTimeFormat = DateTime.now();
      endTimeFormat = DateTime.now().add(const Duration(minutes: 5));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Task",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: defaultPaddingHorizontal,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  AddTaskTextForm(
                    labelText: "Title",
                    hintText: "Enter Task Name",
                    keyboardType: TextInputType.text,
                    controller: taskNameController,
                  ),
                  AddTaskTextForm(
                    labelText: "Note",
                    hintText: "Enter Note",
                    keyboardType: TextInputType.text,
                    controller: taskNoteController,
                  ),
                  AddTaskTextForm(
                    labelText: "Date",
                    hintText: DateFormat(dateTaskFormat).format(_selectedDate),
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    sufficIcon: IconButton(
                      onPressed: () async {
                        final pickerDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        setState(() {
                          if (pickerDate != null) _selectedDate = pickerDate;
                        });
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AddTaskTextForm(
                          labelText: "Start Time",
                          hintText: timeFormat.format(startTimeFormat),
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          sufficIcon: IconButton(
                            onPressed: () async {
                              var picker = await showTimePicker(
                                context: context,
                                initialEntryMode: TimePickerEntryMode.input,
                                initialTime: TimeOfDay.now(),
                              );

                              if (picker != null) {
                                setState(() {
                                  _startTime = DateFormat(dateTimeTaskFormat)
                                      .format(
                                        DateTime(
                                          _selectedDate.year,
                                          _selectedDate.month,
                                          _selectedDate.day,
                                          picker.hour,
                                          picker.minute,
                                        ),
                                      )
                                      .toString();
                                });
                              }
                            },
                            icon: const Icon(Icons.access_time_rounded),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AddTaskTextForm(
                          labelText: "End Time",
                          hintText: timeFormat.format(endTimeFormat),
                          keyboardType: TextInputType.datetime,
                          readOnly: true,
                          sufficIcon: IconButton(
                            onPressed: () async {
                              var picker = await showTimePicker(
                                context: context,
                                initialEntryMode: TimePickerEntryMode.input,
                                initialTime: TimeOfDay.fromDateTime(
                                  DateFormat(dateTimeTaskFormat)
                                      .parse(_endTime),
                                ),
                              );

                              if (picker != null) {
                                setState(() {
                                  _endTime = DateFormat(dateTimeTaskFormat)
                                      .format(
                                        DateTime(
                                          _selectedDate.year,
                                          _selectedDate.month,
                                          _selectedDate.day,
                                          picker.hour,
                                          picker.minute,
                                        ),
                                      )
                                      .toString();
                                });
                              }
                            },
                            icon: const Icon(Icons.access_time_rounded),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ColorForm(
                selectedColor: _selectedColor,
                onColorSelected: (index) {
                  setState(() {
                    _selectedColor = index;
                  });
                },
              ),
              const SizedBox(height: 20),
              AddButton(
                height: 45,
                onPressed: () async {
                  if (_validate()) return;

                  final task = await _addTaskDB();

                  await NotificationHelper.createScheduledNotification(
                    task,
                  );

                  await Future.delayed(const Duration(milliseconds: 200));

                  Get.back();

                  Get.snackbar(
                    "Success",
                    "Task Created Successfully",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                text: const Text(
                  "Create Task",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
