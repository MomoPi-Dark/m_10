import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({
    super.key,
  });

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final items = Get.find<TaskController>();
  DateTime today = DateTime.now();

  // _showBottom() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         height: 200,
  //         color: Colors.white,
  //         child: Column(
  //           children: [
  //             ListTile(
  //               title: const Text("Add Task"),
  //               onTap: () {
  //                 // items.addTask("Task");
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             ListTile(
  //               title: const Text("Add Event"),
  //               onTap: () {
  //                 // items.addTask("Event");
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Item", style: appBarTitleStyle),
      ),
      // body: AnimatedPhysicalModel(
      //   elevation: 0,
      //   color: Colors.transparent,
      //   shadowColor: Colors.transparent,
      //   curve: Curves.easeInOut,
      //   shape: BoxShape.rectangle,
      //   duration: const Duration(milliseconds: 500),
      //   child: Container(),
      // ),
    );
  }
}
