import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';

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
    String? createdAt,
    String? updatedAt,
  })  : createdAt =
            createdAt ?? DateFormat(dateTaskFormat).format(DateTime.now()),
        updatedAt =
            updatedAt ?? DateFormat(dateTaskFormat).format(DateTime.now());

  factory TaskItemBuilder.fromJson(Map<String, dynamic> json) {
    return TaskItemBuilder(
      id: json['id'] ?? "",
      userId: json['userId'] ?? "",
      label: json['label'] ?? 0,
      title: json['title'] ?? "",
      note: json['note'] ?? "",
      date: json['date'] ?? "",
      startTime: json['startTime'] ?? "",
      endTime: json['endTime'] ?? "",
      remind: json['remind'] ?? 0,
      repeat: json['repeat'] ?? "",
      color: json['color'] ?? 0,
      isTimeExceeded: json['isTimeExceeded'] ?? 0,
      createdAt: json['createdAt'] ??
          DateFormat(dateTaskFormat).format(DateTime.now()),
      updatedAt: json['updatedAt'] ??
          DateFormat(dateTaskFormat).format(DateTime.now()),
    );
  }

  int color;
  String createdAt;
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
  String updatedAt;
  String userId;

  String get createdTimestamp =>
      DateFormat.yMMMMEEEEd().format(DateTime.parse(createdAt));

  String get updatedTimestamp =>
      DateFormat.yMMMMEEEEd().format(DateTime.parse(updatedAt));

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

  void setTitle(String title) {
    this.title = title;
  }

  void setNote(String note) {
    this.note = note;
  }

  void setLabel(int label) {
    this.label = label;
  }

  void setDate(String date) {
    this.date = date;
  }

  void setStartTime(String time) {
    startTime = time;
  }

  void setEndTime(String time) {
    endTime = time;
  }

  void setRemind(int remind) {
    this.remind = remind;
  }

  void setRepeat(String repeat) {
    this.repeat = repeat;
  }

  void setColor(int color) {
    this.color = color;
  }

  void setIsTimeExceeded(int status) {
    isTimeExceeded = status;
  }

  void setCreatedAt(String time) {
    createdAt = time;
  }

  void setUpdatedAt(String time) {
    updatedAt = time;
  }
}

// Fungsi untuk mengubah JSON string menjadi objek TaskItemBuilder
TaskItemBuilder taskItemBuilderFromJson(String str) =>
    TaskItemBuilder.fromJson(json.decode(str));

// Fungsi untuk mengubah objek TaskItemBuilder menjadi JSON string
String taskItemBuilderToJson(TaskItemBuilder data) =>
    json.encode(data.toJson());
