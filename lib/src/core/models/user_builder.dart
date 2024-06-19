import 'dart:convert';

import 'package:intl/intl.dart';

UserBuilder userBuilderFromJson(String str) =>
    UserBuilder.fromJson(json.decode(str));

String userBuilderToJson(UserBuilder data) => json.encode(data.toJson());

class UserBuilder {
  UserBuilder({
    required this.email,
    required this.displayName,
    this.id = "",
    this.userId = "",
    this.isEmailVerified = false,
    this.createdAt = "",
    this.updatedAt = "",
    this.phoneNumber = "",
    this.photoURL = "",
  });

  factory UserBuilder.fromJson(Map<String, dynamic> json) => UserBuilder(
        id: json["id"],
        userId: json["userId"],
        email: json["email"],
        displayName: json["displayName"],
        isEmailVerified: json["isEmailVerified"],
        phoneNumber: json["phoneNumber"],
        photoURL: json["photoURL"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  String createdAt;
  String displayName;
  String email;
  String id;
  bool isEmailVerified;
  String phoneNumber;
  String photoURL;
  String updatedAt;
  String userId;

  String get createdTimestamp =>
      DateFormat.yMMMMEEEEd().format(DateTime.parse(createdAt));

  String get updatedTimestamp =>
      DateFormat.yMMMMEEEEd().format(DateTime.parse(updatedAt));

  void changeUpdateTime(DateTime time) {
    updatedAt = time.toIso8601String();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "email": email,
        "displayName": displayName,
        "isEmailVerified": isEmailVerified,
        "phoneNumber": phoneNumber,
        "photoURL": photoURL,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
