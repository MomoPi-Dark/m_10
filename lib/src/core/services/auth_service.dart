import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  String? get currentUserName =>
      _auth.currentUser?.displayName ??
      _auth.currentUser?.email?.split("@").first ??
      "Unknown User";

  Future<void> signOut() async {
    if (_auth.currentUser == null) {
      throw "User not login yet!";
    }

    try {
      await _auth.signOut();
    } catch (e) {
      // log("Something went wrong with signout: error $e");
      throw Exception(e);
    }
  }

  Future<User?> createUserWithEmailAndPassword(
    String displayName,
    String email,
    String password,
  ) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return cred.user;
    } catch (e) {
      String errorCode;
      if (e is FirebaseAuthException) {
        errorCode = e.code;
      } else {
        errorCode = "unknown";
      }

      Get.snackbar("Error", getErrorMessage(errorCode));

      throw Exception(e);
    }
  }

  Future<User?> loginUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      if (_auth.currentUser != null) {
        // log("User already login: ${_auth.currentUser!.email}");
        return _auth.currentUser;
      }

      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user != null) {
        log("User logged in: ${cred.user!.email}");
      }

      return cred.user;
    } catch (e) {
      String errorCode;
      if (e is FirebaseAuthException) {
        errorCode = e.code;
      } else {
        errorCode = "unknown";
      }

      Get.snackbar("Error", getErrorMessage(errorCode));
      throw Exception(e);
    }
  }

  String getErrorMessage(String errorCode) {
    // log("Error code: $errorCode");

    switch (errorCode) {
      case "invalid-email":
        return "Your email address appears to be malformed.";
      case "wrong-password":
        return "Your password is wrong.";
      case "user-not-found":
        return "User with this email doesn't exist.";
      case "user-disabled":
        return "User with this email has been disabled.";
      case "too-many-requests":
        return "Too many requests. Try again later.";
      case "operation-not-allowed":
        return "Signing in with Email and Password is not enabled.";
      case "email-already-in-use":
        return "The email has already been registered. Please login.";
      case "invalid-credential":
        return "The email address is badly formatted.";
      default:
        return "An undefined Error happened.";
    }
  }
}
