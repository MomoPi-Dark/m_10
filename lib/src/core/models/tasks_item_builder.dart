import 'dart:convert';

// Fungsi untuk mengubah JSON string menjadi objek TaskItemBuilder
TaskItemBuilder taskItemBuilderFromJson(String str) =>
    TaskItemBuilder.fromJson(json.decode(str));

// Fungsi untuk mengubah objek TaskItemBuilder menjadi JSON string
String taskItemBuilderToJson(TaskItemBuilder data) =>
    json.encode(data.toJson());

class TaskItemBuilder {
  TaskItemBuilder({
    this.id = "",
    required this.userId,
    required this.label,
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.remind,
    required this.repeat,
    required this.color,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
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
      isCompleted: json['isCompleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  int color;
  String createdAt;
  String date;
  String endTime;
  String id;
  int isCompleted;
  String label;
  String note;
  int remind;
  String repeat;
  String startTime;
  String title;
  String updatedAt;
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
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
