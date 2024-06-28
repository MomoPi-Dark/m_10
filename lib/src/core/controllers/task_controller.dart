import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/models/tasks_item_builder.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/core/services/database_service.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

const String dateTimeTaskFormat = "hh:mm:ss:SSS";
const String dateTaskFormat = "yyyy-MM-dd";
const int taskLimit = 20;

class TaskController extends GetxController {
  final AuthService _auth = AuthService();
  final String _collectionName = 'tasks';
  final Rx<StateLoadItems> _connectionState = StateLoadItems.loading.obs;
  final DatabaseService _db = DatabaseService();
  DocumentSnapshot? _lastDocument;
  String? _recordId;
  final String _requiredField = 'userId';
  final RxList<TaskItemBuilder> _taskCache = <TaskItemBuilder>[].obs;

  RxList<TaskItemBuilder> get tasks => _taskCache;

  Rx<StateLoadItems> get connectionState => _connectionState;

  List<TaskItemBuilder> getTasks({int? limit}) {
    return _taskCache.take(limit ?? taskLimit).toList();
  }

  TaskItemBuilder getTask({String? id, TaskItemBuilder? task}) {
    if (id != null && task != null) {
      throw Exception('You can only pass one argument, either id or task.');
    }

    if (id != null) {
      return _taskCache.firstWhere((t) => t.id == id);
    }

    if (task != null) {
      return _taskCache.firstWhere((t) => t == task);
    }

    throw Exception('You must pass either id or task.');
  }

  Future<List<TaskItemBuilder>> initScreen() async {
    if (_auth.currentUser == null ||
        _taskCache.isNotEmpty ||
        _connectionState.value == StateLoadItems.done) {
      return _taskCache;
    }

    await _setStateLoad(StateLoadItems.loading);

    try {
      _recordId ??= _auth.currentUser!.uid;
      await loadTasks(limit: taskLimit);
    } catch (e) {
      log('Error initializing task screen: $e');
    }

    await _setStateLoad(StateLoadItems.done);

    return _taskCache;
  }

  Future<void> initCloseScreen() async {
    if (_auth.currentUser != null ||
        _connectionState.value == StateLoadItems.none) {
      return;
    }

    await _setStateLoad(
      StateLoadItems.loading,
    );

    if (_taskCache.isNotEmpty) {
      _taskCache.clear();
    }

    _lastDocument = null;
    _recordId = null;

    await _setStateLoad(
      StateLoadItems.none,
    );

    log('Task screen closed');
  }

  Future<void> loadTasks({bool loadMore = false, int? limit}) async {
    if (!await _db.hasCollection(_collectionName) ||
        _auth.currentUser == null ||
        _recordId == null ||
        _taskCache.isNotEmpty) {
      return;
    }

    try {
      var querySnapshot = await _db.find(
        _collectionName,
        field: _requiredField,
        isEqualTo: _auth.currentUser!.uid,
        limit: limit,
        startAfter: loadMore && _lastDocument != null ? _lastDocument : null,
      );

      if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;

        List<TaskItemBuilder> loadedTasks = querySnapshot.docs
            .map((e) => TaskItemBuilder.fromJson(e.data()))
            .toList();

        if (loadMore) {
          _taskCache.addAll(loadedTasks);
        } else {
          _taskCache.assignAll(loadedTasks);
        }
      }

      log('Tasks successfully loaded: ${_taskCache.length} tasks');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addTask(TaskItemBuilder task) async {
    if (_recordId == null) {
      return;
    }

    try {
      DocumentReference docRef =
          await _db.addData(_collectionName, task.toJson());
      task.userId = _auth.currentUser!.uid;
      task.id = docRef.id;
      _taskCache.add(task);

      docRef.update({
        'id': docRef.id,
        'userId': _auth.currentUser!.uid,
      });

      log('Task successfully added: ${task.id}');
    } catch (e) {
      log('Error adding task: $e');
      throw Exception(e);
    }
  }

  Future<void> updateTask(TaskItemBuilder task) async {
    if (!await _db.hasCollection(_collectionName) || _recordId == null) {
      return;
    }

    try {
      task.updatedAt = DateTime.now().toString();

      await _db.findOneAndUpdate(
        _collectionName,
        field: "id",
        isEqualTo: task.id,
        data: task.toJson(),
      );

      int index = _taskCache.indexWhere((t) => t.id == task.id);

      if (index != -1) {
        _taskCache[index] = task;
        log('Task successfully updated: ${task.id}');
      } else {
        log('Task not found: ${task.id}');
      }
    } catch (e) {
      log('Error updating task: $e');
      throw Exception(e);
    }
  }

  Future<void> deleteTask(TaskItemBuilder task) async {
    if (!await _db.hasCollection(_collectionName) || _recordId == null) {
      return;
    }

    try {
      await _db.findOneAndDelete(
        _collectionName,
        field: 'id',
        isEqualTo: task.id,
      );

      _taskCache.removeWhere((t) => t.id == task.id);

      log('Task successfully deleted: ${task.id}');
    } catch (e) {
      log("Error deleting task: $e");
      throw Exception(e);
    }
  }

  Future<TaskItemBuilder?> _getTask(String id) async {
    try {
      if (_auth.currentUser == null) return null;

      final data = await _db.findOne(
        _collectionName,
        field: _requiredField,
        isEqualTo: id,
      );

      if (data == null) return null;

      return TaskItemBuilder.fromJson(data.data());
    } catch (e) {
      log('Error getting task: $e');
      throw Exception(e);
    }
  }

  Future<void> _setStateLoad(StateLoadItems value, {int delay = 1}) async {
    await Future.delayed(Duration(milliseconds: delay));
    _connectionState.value = value;
  }
}
