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

  Widget _buildLoading() {
    return widget.loading ??
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (_taskData.connectionState()) {
        case StateLoad.waiting:
          return _buildLoading();

        case StateLoad.loading:
          return _buildLoading();

        case StateLoad.done:
          return widget.buildDoneChild();

        default:
          return const Center(
            child: Text('Error loading tasks'),
          );
      }
    });
  }
}
