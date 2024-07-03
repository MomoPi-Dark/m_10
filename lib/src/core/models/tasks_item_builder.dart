import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';

// Fungsi untuk mengubah JSON string menjadi objek TaskItemBuilder
TaskItemBuilder taskItemBuilderFromJson(String str) =>
    TaskItemBuilder.fromJson(json.decode(str));

// Fungsi untuk mengubah objek TaskItemBuilder menjadi JSON string
String taskItemBuilderToJson(TaskItemBuilder data) =>
    json.encode(data.toJson());

class TaskItemBuilder {
  TaskItemBuilder({
    this.id = "",
    this.userId = "",
    this.label = 0,
    this.title = "",
    this.note = "",
    this.date = "",
    this.startTime = "",
    this.endTime = "",
    this.remind = 0,
    this.repeat = "",
    this.color = 0,
    this.isTimeExceeded = 0,
    this.createdAt = "",
    this.updatedAt = "",
  });

  factory TaskItemBuilder.fromJson(Map<String, dynamic> json) {
    return TaskItemBuilder(
      id: json['id'],
      userId: json['userId'],
      label: json['label'],
      title: json['title'],
      note: json['note'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      remind: json['remind'],
      repeat: json['repeat'],
      color: json['color'],
      isTimeExceeded: json['isTimeExceeded'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  int color;
  String createdAt = DateFormat(dateTaskFormat).format(DateTime.now());
  String date;
  String endTime;
  String id;
  int isTimeExceeded;
  int label;
  String note;
  int remind;
  String repeat;
  String startTime;
  String title;
  String updatedAt = DateFormat(dateTaskFormat).format(DateTime.now());
  String userId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'label': label,
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'repeat': repeat,
      'color': color,
      'isTimeExceeded': isTimeExceeded,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  TaskItemBuilder copyWith({
    String? id,
    String? userId,
    int? label,
    String? title,
    String? note,
    String? date,
    String? startTime,
    String? endTime,
    int? remind,
    String? repeat,
    int? color,
    int? isTimeExceeded,
    String? createdAt,
    String? updatedAt,
  }) {
    return TaskItemBuilder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      title: title ?? this.title,
      note: note ?? this.note,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      remind: remind ?? this.remind,
      repeat: repeat ?? this.repeat,
      color: color ?? this.color,
      isTimeExceeded: isTimeExceeded ?? this.isTimeExceeded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
