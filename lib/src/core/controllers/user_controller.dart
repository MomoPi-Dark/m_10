import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/core/models/user_builder.dart';
import 'package:menejemen_waktu/src/core/services/auth_service.dart';
import 'package:menejemen_waktu/src/core/services/database_service.dart';
import 'package:menejemen_waktu/src/utils/contants/contants.dart';

class UserController extends GetxController {
  final AuthService _auth = AuthService();
  final AuthService _authData = AuthService();
  final DatabaseService _db = DatabaseService();
  final String _requiredField = 'userId';
  final String _tableName = 'users';

  final Rx<UserBuilder?> _user = Rx<UserBuilder?>(null);
  UserBuilder? get currentUser => _user.value;

  final Rx<StateLoadItems> _connectionState = StateLoadItems.none.obs;
  Rx<StateLoadItems> get connectionState => _connectionState;

  StreamSubscription<DocumentSnapshot>? _userSubscription;

  Future<void> initScreen() async {
    if (_authData.currentUser == null ||
        _connectionState.value == StateLoadItems.done) {
      return;
    }

    await _initState(() async {
      var user = await getUser(_authData.currentUser!.uid);

      if (user == null) {
        return;
      }

      _subscribeToUser(user.id);
    });

    log('User screen initialized');
  }

  Future<void> initCloseScreen() async {
    if (_authData.currentUser != null ||
        _connectionState.value == StateLoadItems.none) {
      return;
    }

    await _initState(() async {
      _userSubscription?.cancel();
      _user.value = null;
    });

    _setStateLoad(StateLoadItems.none);

    log('User screen closed');
  }

  Future<UserBuilder?> updateUser(UserBuilder user) async {
    if (_authData.currentUser == null) {
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

    _user.value = UserBuilder.fromJson(data.data());
    return _user.value;
  }

  Future<UserBuilder?> signup(UserBuilder user, String password) async {
    try {
      return await createUser(user, password: password);
    } catch (e) {
      log('Error in createUser: $e');
      throw Exception(e);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _authData.loginUserWithEmailAndPassword(email, password);
      Get.offAllNamed("/app");
    } catch (e) {
      log('Error in login: $e');
      throw Exception(e);
    }
  }

  Future<void> logout() async {
    try {
      await _authData.signOut(redirect: '/');
      await _userSubscription?.cancel();
    } catch (e) {
      log('Error in logout: $e');
      throw Exception(e);
    }
  }

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

      await docRef.update({
        _requiredField: documentId,
        "userId": authCreate.uid,
        "isEmailVerified": authCreate.emailVerified,
        "createdAt": creationTime,
        "updatedAt": creationTime,
      });

      return user;
    } catch (e) {
      log('Error in createUser: $e');
      throw Exception(e);
    }
  }

  Future<void> _subscribeToUser(String userId) async {
    if (_userSubscription != null) await _userSubscription?.cancel();

    _userSubscription =
        _db.getDocumentStream(_tableName, userId, limit: 1).listen(
      (documentSnapshot) async {
        if (documentSnapshot.exists) {
          final userData = documentSnapshot.data();

          if (userData != null) {
            _user.value = UserBuilder.fromJson(userData);
            log('User data updated: ${_user.value?.displayName}');
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

  Future<void> _initState(Function action) async {
    await _setStateLoad(StateLoadItems.loading);

    try {
      await action();
    } catch (e) {
      await _setStateLoad(StateLoadItems.error);
      log('Error in _initState: $e');
      rethrow;
    }

    await _setStateLoad(StateLoadItems.done);
  }

  Future<void> _setStateLoad(StateLoadItems value) async {
    await Future.delayed(const Duration(milliseconds: 2));
    _connectionState.value = value;
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    super.onClose();
  }
}
