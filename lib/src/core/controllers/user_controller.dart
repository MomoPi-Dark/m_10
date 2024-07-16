import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/models/user_builder.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/core/services/database_service.dart';

class UserController extends GetxController {
  final AuthService _auth = AuthService();
  final AuthService _authData = AuthService();
  final DatabaseService _db = DatabaseService();
  final String _requiredField = 'userId';
  final String _tableName = 'users';
  final Rx<UserBuilder?> _user = Rx<UserBuilder?>(null);
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  RxBool get isLoggedIn => (_user.value != null).obs;

  UserBuilder? get currentUser => _user.value;
  String get currentUsername => _auth.currentUserName;

  Future<UserBuilder?> initUser() async {
    if (_authData.currentUser == null || _user.value != null) {
      return null;
    }

    var user = await getUser(_authData.currentUser!.uid);

    if (user == null) {
      return null;
    }

    _user.value = user;
    _subscribeToUser(user.id);

    log('User screen initialized ${_user.value?.displayName}');
    return user;
  }

  Future<void> initCloseUser() async {
    if (_authData.currentUser != null || _user.value == null) {
      return;
    }

    _user.value = null;

    if (_userSubscription != null) {
      await _userSubscription?.cancel();
      _userSubscription = null;
    }

    log('User screen closed');
  }

  Future<UserBuilder?> updateUser(UserBuilder user) async {
    if (_authData.currentUser == null) return null;

    final data = await _db.findOneAndUpdate(
      _tableName,
      field: _requiredField,
      isEqualTo: _auth.currentUser!.uid,
      data: user.toJson(),
    );

    if (data == null) return null;

    _user.value = UserBuilder.fromJson(data.data());
    return _user.value;
  }

  Future<UserBuilder?> signup(UserBuilder user, String password) async {
    try {
      return await createUser(user, password: password);
    } catch (e) {
      // log('Error in createUser: $e');
      throw Exception(e);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _authData.loginUserWithEmailAndPassword(
        email,
        password,
      );

      await initUser();

      Get.offAllNamed(
        "/app",
      );
    } catch (e) {
      log('Error in initUser: $e');
      throw Exception(e);
    }

    log('User logged in');
  }

  Future<void> logout() async {
    try {
      Get.offAllNamed(
        "/",
      );
      await _authData.signOut();
    } catch (e) {
      // log('Error in logout: $e');
      throw Exception(e);
    } finally {
      await initCloseUser();
    }

    // log('User logged out');
  }

  Future<UserBuilder?> getUser(String userId) async {
    final data = await _db.findOne(
      _tableName,
      field: _requiredField,
      isEqualTo: userId,
    );

    if (data == null) return null;

    return UserBuilder.fromJson(data.data());
  }

  Future<UserBuilder?> createUser(UserBuilder user,
      {required String password}) async {
    try {
      var authCreate = await _auth.createUserWithEmailAndPassword(
        user.displayName,
        user.email,
        password,
      );
      DocumentReference docRef = await _db.addData(_tableName, user.toJson());

      String documentId = docRef.id;
      String creationTime = authCreate!.metadata.creationTime.toString();

      user
        ..id = documentId
        ..userId = authCreate.uid
        ..isEmailVerified = authCreate.emailVerified
        ..createdAt = creationTime
        ..updatedAt = creationTime;

      await docRef.update(user.toJson());

      return user;
    } catch (e) {
      // log('Error in createUser: $e');
      throw Exception(e);
    }
  }

  Future<void> _setDelay({required Duration durations}) {
    return Future.delayed(durations);
  }

  Future<void> _subscribeToUser(String userId) async {
    if (_userSubscription != null) await _userSubscription?.cancel();

    _userSubscription =
        _db.getDocumentStream(_tableName, userId, limit: 1).listen(
      (documentSnapshot) async {
        if (documentSnapshot.exists) {
          final userData = documentSnapshot.data();
          if (userData != null) {
            await _setDelay(durations: const Duration(milliseconds: 500));
            _user.value = UserBuilder.fromJson(userData);
            // log('User data updated: ${_user.value?.displayName}');
          } else {
            throw Exception('Document data is null for user with id: $userId');
          }
        } else {
          throw Exception('User document does not exist for id: $userId');
        }
      },
      onError: (e) {
        throw Exception('Error subscribing to user data: $e');
      },
    );
  }
}
