import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menejemen_waktu/src/core/models/tasks_item_builder.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/core/services/database_service.dart';

class TaskItemService {
  final AuthService _auth = AuthService();
  final String _collectionName = 'tasks';
  final DatabaseService _db = DatabaseService();
  final String _requiredField = 'id';

  Future<TaskItemBuilder?> getTaskItem(String id) async {
    try {
      if (_auth.currentUser == null) {
        return null;
      }

      final data = await _db.findOne(
        _collectionName,
        field: _requiredField,
        isEqualTo: id,
      );

      if (data == null) {
        return null;
      }

      return TaskItemBuilder.fromJson(data.data());
    } catch (e) {
      // Handle exceptions here, e.g., log the error
      // log('Error in getTaskItem: $e');
      throw Exception(e); // Return null or throw the error as needed
    }
  }

  Future<List<TaskItemBuilder>> getTaskItems() async {
    try {
      if (_auth.currentUser == null) {
        return [];
      }

      final data = await _db
          .find(
            _collectionName,
            limit: 100,
          )
          .then((value) => value.get());

      return data.docs.map((e) => TaskItemBuilder.fromJson(e.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<TaskItemBuilder?> updateTaskItem(TaskItemBuilder task) async {
    try {
      if (_auth.currentUser == null) {
        return null;
      }

      final data = await _db.findOneAndUpdate(
        _collectionName,
        field: _requiredField,
        isEqualTo: task.id,
        data: task.toJson(),
      );

      if (data == null) {
        return null;
      }

      return TaskItemBuilder.fromJson(data.data());
    } catch (e) {
      // Handle exceptions here, e.g., log the error
      // log('Error in updateTaskItem: $e');
      throw Exception(e); // Return null or throw the error as needed
    }
  }

  Future<TaskItemBuilder> createTaskItem(TaskItemBuilder task) async {
    try {
      DocumentReference docRef =
          await _db.addData(_collectionName, task.toJson());

      String documentId = docRef.id;
      task.id = documentId;

      await docRef.update({
        _requiredField: documentId,
      });

      return task;
    } catch (e) {
      // log('Error in createTaskItem: $e');
      throw Exception(e);
    }
  }

  Future<void> deleteTaskItem(String id) async {
    try {
      if (_auth.currentUser == null) {
        return;
      }

      await _db.findOneAndDelete(
        _collectionName,
        field: _requiredField,
        isEqualTo: id,
      );
    } catch (e) {
      // Handle exceptions here, e.g., log the error
      // log('Error in deleteTaskItem: $e');
      throw Exception(e); // Rethrow the error to propagate it further if needed
    }
  }
}
