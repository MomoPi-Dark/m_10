import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/models/tasks_item_builder.dart';
import 'package:menejemen_waktu/src/utils/contants/colors.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TaskController taskData = Get.find<TaskController>();

  final TextEditingController _searchController = TextEditingController();
  final UndoHistoryController _undoController = UndoHistoryController();

  @override
  void dispose() {
    _searchController.dispose();
    _undoController.dispose();
    super.dispose();
  }

  Future<List<TaskItemBuilder>> updateItems() async {
    String searchText = _searchController.text.toLowerCase();
    List<TaskItemBuilder> tasks = taskData.tasks
        .where((task) =>
            task.title.toLowerCase().contains(searchText) ||
            task.label.toLowerCase().contains(searchText))
        .toList();
    await Future.delayed(const Duration(seconds: 2));
    return tasks;
  }

  Widget _buildBody() {
    return Padding(
      padding: defaultPaddingHorizontal,
      child: FutureBuilder<List<TaskItemBuilder>>(
        future: updateItems(),
        builder: (context, snapshot) {
          if (_searchController.text.isEmpty) {
            return Center(
              child: Text(
                "Enter a search term",
                style: bodyTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: Heading.h4,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<TaskItemBuilder> tasks = snapshot.data ?? [];

            if (_searchController.text.isEmpty || tasks.isEmpty) {
              return Center(
                child: Text(
                  "No data found",
                  style: bodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: Heading.h4,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.label),
                );
              },
            );
          }
        },
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  Widget _buildTitle() {
    return TextField(
      autofocus: true,
      controller: _searchController,
      keyboardType: TextInputType.text,
      onChanged: (_) => setState(() {}),
      cursorColor: customSecondaryTextColor,
      decoration: InputDecoration(
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(),
        errorBorder: _buildBorder(),
        counterStyle: TextStyle(
          color: customSecondaryTextColor,
        ),
        hintText: "Search schedule...",
        hintStyle: GoogleFonts.karla(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        suffixIconColor: Colors.grey,
        focusColor: customSecondaryTextColor,
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  size: 20,
                ),
                iconSize: 20,
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Container(
            color: customSecondaryTextColor.withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }
}
