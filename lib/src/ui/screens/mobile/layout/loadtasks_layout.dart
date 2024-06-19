
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class LoadTasksLayout extends StatefulWidget {
  const LoadTasksLayout({
    super.key,
    required this.doneChild,
    this.loading,
  });

  final Widget doneChild;
  final Widget? loading;

  @override
  State<LoadTasksLayout> createState() => _LoadTasksLayoutState();
}

class _LoadTasksLayoutState extends State<LoadTasksLayout> {
  final _taskData = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_taskData.connectionState() == StateLoadItems.loading) {
        return widget.loading ??
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
      } else if (_taskData.connectionState() == StateLoadItems.done) {
        return widget.doneChild;
      } else {
        return const Center(
          child: Text('Error loading tasks'),
        );
      }
    });
  }
}
