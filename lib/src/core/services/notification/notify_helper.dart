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
    print('Notification created');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    print('Notification displayed');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    print('Notification dismissed');
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    print('Notification action received');
  }

  static Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  static Future checkNotificationPermission(String key) async {
    // final bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    // log('Notification permission: $isAllowed');

    await AwesomeNotifications().requestPermissionToSendNotifications(
      channelKey: key,
      permissions: [
        NotificationPermission.Alert,
        NotificationPermission.Badge,
        NotificationPermission.Sound,
      ],
    );
  }

  static Future<void> createScheduledNotification(
    TaskItemBuilder taskBuilder,
  ) async {
    await configureLocalTimeZone();

    final location = tz.local;

    final DateFormat dateFormat = DateFormat(dateTaskFormat);
    final DateTime scheduleDate = dateFormat.parse(taskBuilder.date);

    final DateFormat timeFormat = DateFormat(dateTimeTaskFormat);
    final DateTime scheduleTimeWithTime = timeFormat.parse(taskBuilder.endTime);

    final scheduleTime = tz.TZDateTime(
      location,
      scheduleDate.year,
      scheduleDate.month,
      scheduleDate.day,
      scheduleTimeWithTime.hour,
      scheduleTimeWithTime.minute,
    );

    // final payload = {
    //   'id': taskBuilder.id,
    //   'data': taskBuilder.toString(),
    // };

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: scheduleId,
        channelKey: channelGlobalKey,
        title: taskBuilder.label,
        body: taskBuilder.note,
        actionType: ActionType.SilentBackgroundAction,
        // payload: payload as Map<String, String>,
      ),
      schedule: NotificationCalendar.fromDate(
        date: scheduleTime,
        allowWhileIdle: true,
        preciseAlarm: true,
      ),
    );

    print('Scheduled notification created');
  }
}
