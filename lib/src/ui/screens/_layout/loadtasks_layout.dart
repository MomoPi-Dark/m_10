import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class LoadTasks extends StatefulWidget {
  const LoadTasks({
    super.key,
    required this.buildDoneChild,
    this.loading,
  });

  final Widget Function() buildDoneChild;
  final Widget? loading;

  @override
  State<LoadTasks> createState() => _LoadTasksState();
}

class _LoadTasksState extends State<LoadTasks> {
  final _taskData = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // if (_taskData.connectionState() == StateLoadItems.loading) {
      //   return widget.loading ??
      //       const Center(
      //         child: CircularProgressIndicator(
      //           valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      //         ),
      //       );
      // } else if (_taskData.connectionState() == StateLoadItems.done) {
      //   return widget.buildDoneChild();
      // } else {
      //   return const Center(
      //     child: Text('Error loading tasks'),
      //   );
      // }

      switch (_taskData.connectionState()) {
        case StateLoadItems.loading:
          return widget.loading ??
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );

        case StateLoadItems.done:
          return widget.buildDoneChild();

        default:
          return const Center(
            child: Text('Error loading tasks'),
          );
      }
    });
  }
}
