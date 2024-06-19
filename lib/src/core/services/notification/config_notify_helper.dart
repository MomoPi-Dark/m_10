import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

// Notification ID \\
const basicId = 1111;
const scheduleId = 1112;

// Action button ID \\
const buttonId = 2111;

const appName = "clockproject";

String Function(List<String>) createKey = (List<String> keys) =>
    "com.${appName.toLowerCase().splitMapJoin(" ", onMatch: (_) => "_")}.${keys.join(".")}";

String channelGlobalKey = createKey(["channel", "basic"]);
String channelGroupGlobalKey = createKey(["channel", "group"]);

const String _channelGroupName = "Basic notification group";
const String _channelScheduleGroupName = "Scheduled notification group";

const String _basicChannelName = "Basic notifications";
const String _basicChannelDescription = "Notification channel for basic tests";

const String _channelScheduleName = "Scheduled notifications";
const String _channelScheduleDescription =
    "Notification channel for scheduled tests";

// Notification Group \\

final basicGroup = NotificationChannelGroup(
  channelGroupKey: channelGroupGlobalKey,
  channelGroupName: _channelGroupName,
);

// Scheduled Notification Group \\
String channelScheduleGroupKey = createKey(["channel", "group", "schedule"]);
String scheduleGroupKey = createKey(["group", "schedule"]);

final scheduleGroup = NotificationChannelGroup(
  channelGroupKey: channelScheduleGroupKey,
  channelGroupName: _channelScheduleGroupName,
);

// Exported Groups \\
final groups = [basicGroup, scheduleGroup];

// ====================================================================== \\

// Notification Channel \\
final basicChannel = NotificationChannel(
  channelKey: channelGlobalKey,
  channelName: _basicChannelName,
  channelDescription: _basicChannelDescription,
  defaultColor: const Color(0xFF9D50DD),
  importance: NotificationImportance.High,
);

// Scheduled Notification Channel \\
String channelScheduleKey = createKey(["channel", "schedule"]);

final scheduleChannel = NotificationChannel(
  channelKey: channelScheduleKey,
  channelName: _channelScheduleName,
  channelDescription: _channelScheduleDescription,
  defaultColor: const Color(0xFF9D50DD),
  importance: NotificationImportance.High,
);

// Exported Channels \\
final channels = [basicChannel, scheduleChannel];
