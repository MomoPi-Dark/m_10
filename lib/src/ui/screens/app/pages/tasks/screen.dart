import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/models/tasks_item_builder.dart';
import 'package:menejemen_waktu/src/core/services/notification/notify_helper.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/tasks//Components/colorform.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/tasks//Components/textform.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/tasks//components/addbutton.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/tasks/components/dropdown.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

final timeFormat = DateFormat('hh:mm a');

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    super.key,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final arguments = Get.arguments;

  late final TaskItemBuilder? existingTask;
  TaskController taskController = Get.put(TaskController());
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskNoteController = TextEditingController();

  TimeOfDay _endTime =
      TimeOfDay.now().replacing(minute: TimeOfDay.now().minute + 1);

  int _selectedColor = 0;
  DateTime _selectedDate = DateTime.now();
  int _selectedLabel = 0;
  TimeOfDay _startTime = TimeOfDay.now();

  @override
  void dispose() {
    taskNameController.dispose();
    taskNoteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    existingTask = arguments;

    if (arguments != null) {
      taskNameController.text = existingTask!.title;
      taskNoteController.text = existingTask!.note;
      _selectedLabel = existingTask!.label;
      _selectedDate = DateFormat(dateTaskFormat).parse(existingTask!.date);
      _startTime = _parseTimeOfDay(existingTask!.startTime);
      _endTime = _parseTimeOfDay(existingTask!.endTime);
      _selectedColor = existingTask!.color;
    }
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final dateTime = DateFormat(dateTimeTaskFormat).parse(time);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  String _formatTimeOfStringDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat(dateTimeTaskFormat).format(dt);
  }

  Future<TaskItemBuilder> _saveTask() async {
    var task = TaskItemBuilder(
      id: existingTask?.id ?? "",
      userId: existingTask?.userId ?? "",
      title: taskNameController.text,
      label: _selectedLabel,
      note: taskNoteController.text,
      date: DateFormat(dateTaskFormat).format(_selectedDate),
      startTime: _formatTimeOfStringDay(_startTime),
      endTime: _formatTimeOfStringDay(_endTime),
      color: _selectedColor,
      isTimeExceeded: 0,
      remind: 0,
      repeat: "None",
      createdAt: existingTask?.createdAt ?? "",
      updatedAt: DateFormat(dateTaskFormat).format(DateTime.now()),
    );

    if (existingTask == null) {
      await taskController.addTask(task);
      await NotificationHelper.createScheduledNotification(
        task,
      );
    } else {
      await taskController.updateTask(task);
    }

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
      final DateTime startDateFormat = DateFormat(dateTimeTaskFormat)
          .parse(_formatTimeOfStringDay(_startTime));
      final DateTime endDateFormat = DateFormat(dateTimeTaskFormat)
          .parse(_formatTimeOfStringDay(_endTime));

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
      // log("Error parsing time: $e");

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          existingTask == null ? "Add Task" : "Edit Task",
          style: appBarTitleStyle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: defaultPaddingHorizontal.add(
              const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    AddTaskDropdown(
                      labelText: "Label",
                      hintText: "Enter label",
                      selectedLabel: _selectedLabel.toString(),
                      items: labelItem
                          .asMap()
                          .map((index, value) {
                            return MapEntry(
                              index.toString(),
                              DropdownMenuItem<String>(
                                value: index.toString(),
                                child: Text(value),
                              ),
                            );
                          })
                          .values
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLabel = int.parse(value!);
                        });
                      },
                    ),
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
                      hintText:
                          DateFormat(dateTaskFormat).format(_selectedDate),
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
                            hintText: timeFormat.format(DateTime(
                              _selectedDate.year,
                              _selectedDate.month,
                              _selectedDate.day,
                              _startTime.hour,
                              _startTime.minute,
                            )),
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            sufficIcon: IconButton(
                              onPressed: () async {
                                var picker = await showTimePicker(
                                  context: context,
                                  initialEntryMode: TimePickerEntryMode.input,
                                  initialTime: _startTime,
                                );

                                if (picker != null) {
                                  setState(() {
                                    _startTime = picker;
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
                            hintText: timeFormat.format(DateTime(
                              _selectedDate.year,
                              _selectedDate.month,
                              _selectedDate.day,
                              _endTime.hour,
                              _endTime.minute,
                            )),
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                            sufficIcon: IconButton(
                              onPressed: () async {
                                var picker = await showTimePicker(
                                  context: context,
                                  initialEntryMode: TimePickerEntryMode.input,
                                  initialTime: _endTime,
                                );

                                if (picker != null) {
                                  setState(() {
                                    _endTime = picker;
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
                const SizedBox(height: 50),
                AddButton(
                  height: 45,
                  onPressed: () async {
                    if (_validate()) return;

                    try {
                      await _saveTask();
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Failed to create task",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } finally {
                      Get.back();

                      Get.snackbar(
                        "Success",
                        existingTask == null
                            ? "Task Created Successfully"
                            : "Task Updated Successfully",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    }
                  },
                  text: Text(
                    existingTask == null ? "Create Task" : "Update Task",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
