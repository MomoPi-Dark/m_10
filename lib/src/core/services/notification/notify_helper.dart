import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:menejemen_waktu/src/core/controllers/task_controller.dart';
import 'package:menejemen_waktu/src/core/models/tasks_item_builder.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'config_notify_helper.dart';

class NotificationHelper with AwesomeNotifications {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // log('Notification created, n: $receivedNotification');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // log('Notification displayed, n: $receivedNotification');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // log('Notification dismissed, n: $receivedAction');
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // log('Notification action received, n: $receivedAction');
  }

  static Future checkNotificationPermission(String key) async {
    final bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (isAllowed) {
      return;
    }

    await AwesomeNotifications().requestPermissionToSendNotifications(
      channelKey: key,
      permissions: [
        NotificationPermission.Alert,
        NotificationPermission.Badge,
        NotificationPermission.Sound,
        NotificationPermission.Vibration,
      ],
    );
  }

  static Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  static Future<void> createScheduledNotification(
    TaskItemBuilder taskBuilder,
  ) async {
    await checkNotificationPermission(channelScheduleKey);
    await configureLocalTimeZone();

    final location = tz.local;
    final now = tz.TZDateTime.now(location).add(const Duration(minutes: 1));

    final DateFormat dateFormat = DateFormat(dateTaskFormat);
    final DateFormat timeFormat = DateFormat(dateTimeTaskFormat);

    final DateTime scheduleDate = dateFormat.parse(taskBuilder.date);
    final DateTime scheduleStartTime = timeFormat.parse(taskBuilder.startTime);
    final DateTime scheduleEndTime = timeFormat.parse(taskBuilder.endTime);

    final scheduleTzStartTime = tz.TZDateTime(
      location,
      scheduleDate.year,
      scheduleDate.month,
      scheduleDate.day,
      scheduleStartTime.hour,
      scheduleStartTime.minute,
    );

    // final scheduleTzEndTime = tz.TZDateTime(
    //   location,
    //   scheduleDate.year,
    //   scheduleDate.month,
    //   scheduleDate.day,
    //   scheduleEndTime.hour,
    //   scheduleEndTime.minute,
    // );

    // if (scheduleTzStartTime.isBefore(now)) {
    //   // log('Error: Scheduled time is in the past');
    //   return;
    // }

    final payload = {
      'id': taskBuilder.id,
      'userId': taskBuilder.userId,
    };

    int uniqueId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    try {
      // Add notification to the schedule \\

      final notification = NotificationContent(
        id: uniqueId,
        channelKey: channelScheduleKey,
        title: "Task Reminder",
        body: "Task ${taskBuilder.title} is scheduled to start now!",
        payload: payload,
      );

      final schedule = NotificationCalendar.fromDate(
        date: scheduleTzStartTime,
        allowWhileIdle: true,
        repeats: true,
        preciseAlarm: true,
      );

      await AwesomeNotifications().createNotification(
        content: notification,
        schedule: schedule,
      );

      // log('Scheduled notification created with ID: $uniqueId');
    } catch (e) {
      // log('Error creating notification: $e');
    }
  }
}
