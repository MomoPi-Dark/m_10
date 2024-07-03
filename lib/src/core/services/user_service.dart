import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:menejemen_waktu/src/core/models/user_builder.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/core/services/database_service.dart';

class UserService {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  final String _requiredField = 'userId';
  final String _tableName = 'users';

  Future<UserBuilder?> getUser(String userId) async {
    final data = await _db.findOne(
      _tableName,
      field: _requiredField,
      isEqualTo: userId,
    );

    if (data == null) {
      return null;
    }

    return UserBuilder.fromJson(data.data());
  }

  Future<UserBuilder?> updateUser(UserBuilder user) async {
    if (_auth.currentUser == null) {
      return null;
    }

    final data = await _db.findOneAndUpdate(
      _tableName,
      field: _requiredField,
      isEqualTo: _auth.currentUser!.uid,
      data: user.toJson(),
    );

    if (data == null) {
      return null;
    }

    return UserBuilder.fromJson(data.data());
  }

  Future<UserBuilder?> createUser(
    UserBuilder user, {
    required String password,
  }) async {
    try {
      var authCreate = await _auth.createUserWithEmailAndPassword(
        user.displayName,
        user.email,
        password,
      );
      DocumentReference docRef = await _db.addData(_tableName, user.toJson());

      String documentId = docRef.id;
      String creationTime = authCreate!.metadata.creationTime.toString();

      user.id = documentId;
      user.userId = authCreate.uid;
      user.isEmailVerified = authCreate.emailVerified;
      user.createdAt = creationTime.toString();
      user.updatedAt = creationTime.toString();

      await docRef.update({
        "id": documentId,
        _requiredField: authCreate.uid,
        "isEmailVerified": authCreate.emailVerified,
        "createdAt": creationTime,
        "updatedAt": creationTime,
      });

      return user;
    } catch (e) {
      // log('Error in createUser: $e');
      throw Exception(e);
    }
  }
}
