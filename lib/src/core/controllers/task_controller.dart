import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/controllers/user_controller.dart';
import 'package:menejemen_waktu/src/core/models/tasks_item_builder.dart';
import 'package:menejemen_waktu/src/core/services/database_service.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

const String dateTimeTaskFormat = "hh:mm:ss:SSS";
const String dateTaskFormat = "yyyy-MM-dd";
const int taskLimit = 20;

class TaskController extends GetxController {
  final UserController _auth = Get.find<UserController>();
  final String _collectionName = 'users';
  final Rx<StateLoad> _connectionState = StateLoad.waiting.obs;
  final DatabaseService _db = DatabaseService();
  DocumentSnapshot? _lastDocument;
  String? _recordId;

  final String _subcollectionName = 'tasks';
  final RxList<TaskItemBuilder> _taskCache = <TaskItemBuilder>[].obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _taskSubscription;

  @override
  void onClose() {
    initCloseScreen();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    if (_auth.isLoggedIn()) {
      initScreen();
    }
  }

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

  RxList<TaskItemBuilder> get tasks => _taskCache;

  Rx<StateLoad> get connectionState => _connectionState;

  Future<void> initScreen() async {
    if (_auth.currentUser == null ||
        _connectionState.value == StateLoad.loading ||
        _connectionState.value == StateLoad.done) {
      return;
    }

    await _setStateLoad(StateLoad.loading);

    try {
      _recordId ??= _auth.currentUser!.id;
      await loadTasks(loadMore: true);
      await _subscribeToTasks();
    } catch (e) {
      log('Error initializing task screen: $e');
    }

    await _setStateLoad(StateLoad.done);

    log('Task screen initialized');
  }

  Future<void> initCloseScreen() async {
    if (_auth.currentUser != null ||
        _connectionState.value == StateLoad.loading ||
        _connectionState.value == StateLoad.none) {
      return;
    }

    _setStateLoad(
      StateLoad.loading,
    );

    _taskSubscription?.cancel();
    _taskSubscription = null;
    _taskCache.clear();
    _lastDocument = null;
    _recordId = null;

    _setStateLoad(
      StateLoad.none,
    );

    if (_auth.currentUser == null) {
      _connectionState.value = StateLoad.waiting;
    }

    log('Task screen closed');
  }

  Future<void> loadTasks({bool loadMore = false, int? limit}) async {
    if (_auth.currentUser == null || _recordId == null) {
      return;
    }

    if (!await _db.hasSubDocument(
      _collectionName,
      _recordId!,
      _subcollectionName,
    )) {
      return;
    }

    try {
      var querySnapshot = await _db
          .findSubcollection(
            _collectionName,
            _recordId!,
            _subcollectionName,
            limit: limit ?? taskLimit,
            lastDocument: loadMore ? _lastDocument : null,
          )
          .then(
            (value) => value.get(),
          );

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;

        List<TaskItemBuilder> loadedTasks = querySnapshot.docs
            .map((e) => TaskItemBuilder.fromJson(e.data()))
            .toList();

        if (loadMore) {
          _taskCache.addAll(loadedTasks);
        } else {
          _taskCache.assignAll(loadedTasks);
        }

        log('Task data loaded: ${loadedTasks.length} tasks');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addTask(TaskItemBuilder task) async {
    if (_recordId == null) {
      return;
    }

    try {
      var docRef = await _db.addDataToSubcollection(
        _collectionName,
        _recordId!,
        _subcollectionName,
        task.toJson(),
      );

      task.id = docRef.id;
      task.userId = _recordId!;

      task.createdAt = DateTime.now().toString();
      task.updatedAt = DateTime.now().toString();

      await docRef.update(task.toJson());

      log('Task successfully added: ${task.id}');
    } catch (e) {
      // log('Error adding task: $e');
      throw Exception(e);
    }
  }

  Future<void> updateTask(TaskItemBuilder task) async {
    if (_recordId == null ||
        !await _db.hasSubDocument(
            _collectionName, _recordId!, _subcollectionName)) {
      return;
    }

    try {
      var tk = _getTaskCache(task.id);

      task.id = tk.id;
      task.userId = tk.userId;
      task.createdAt = tk.createdAt;
      task.setUpdatedAt(DateTime.now().toString());

      await _db.findOneAndUpdateSubcollection(
        _collectionName,
        _recordId!,
        _subcollectionName,
        field: "id",
        isEqualTo: task.id,
        data: task.toJson(),
      );

      int index = _taskCache.indexWhere((t) => t.id == task.id);

      if (index != -1) {
        _taskCache[index] = task;
        log('Task successfully updated: ${task.toJson()}');
      } else {
        log('Task not found in cache: ${task.id}');
      }
    } catch (e) {
      // log('Error updating task: $e');
      throw Exception('Error updating task: $e');
    }
  }

  Future<void> deleteTask(TaskItemBuilder task) async {
    if (!await _db.hasSubDocument(
          _collectionName,
          _recordId!,
          _subcollectionName,
        ) ||
        _recordId == null) {
      return;
    }

    try {
      await _db.findOneAndDeleteSubcollection(
        _collectionName,
        _recordId!,
        _subcollectionName,
        field: 'id',
        isEqualTo: task.id,
      );

      _taskCache.removeWhere((t) => t.id == task.id);

      // log('Task successfully deleted: ${task.id}');
    } catch (e) {
      // log("Error deleting task: $e");
      throw Exception(e);
    }
  }

  Future<void> _subscribeToTasks() async {
    if (_taskSubscription != null) await _taskSubscription?.cancel();

    _taskSubscription = _db
        .getSubCollectionsStream(
      _collectionName,
      _recordId!,
      _subcollectionName,
    )
        .listen(
      (querySnapshot) async {
        List<TaskItemBuilder> loadedTasks = querySnapshot.docs
            .map((e) => TaskItemBuilder.fromJson(e.data()))
            .toList();

        await _setDelay(milliseconds: 1);
        _taskCache.value = loadedTasks;

        log("Task data updated: ${_taskCache.length} tasks");
      },
      onError: (e) {
        throw Exception('Error subscribing to task data: $e');
      },
      onDone: () {
        log('Task data subscription done');
      },
    );
  }

  Future<void> _setStateLoad(StateLoad value, {int delay = 1}) async {
    await _setDelay(milliseconds: delay);
    _connectionState.value = value;
  }

  Future<void> _setDelay({required int milliseconds}) {
    return Future.delayed(Duration(milliseconds: milliseconds));
  }

  TaskItemBuilder _getTaskCache(String id) {
    return _taskCache.firstWhere((t) => t.id == id);
  }
}
