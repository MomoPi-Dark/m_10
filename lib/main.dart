import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:menejemen_waktu/configs/config.dart';
import 'package:menejemen_waktu/configs/routes.dart';
import 'package:menejemen_waktu/configs/widgettree.dart';
import 'package:menejemen_waktu/src/controllers/theme_controller.dart';
import 'package:menejemen_waktu/src/service/config_notify_helper.dart';

import 'configs/firebase_options.dart';
import 'src/service/notify_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeComponents();
  final themeData = Get.find<ThemeController>();

  SystemChrome.setSystemUIOverlayStyle(
    themeData.isDarkMode.value
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light,
  );

  if (onlyMobile) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

Future<void> initializeComponents() async {
  await NotificationHelper().initialize(
    null,
    channels,
    channelGroups: groups,
    debug: true,
  );

  await AwesomeNotifications().setListeners(
    onNotificationDisplayedMethod:
        NotificationHelper.onNotificationDisplayedMethod,
    onActionReceivedMethod: NotificationHelper.onActionReceivedMethod,
    onDismissActionReceivedMethod:
        NotificationHelper.onDismissActionReceivedMethod,
    onNotificationCreatedMethod: NotificationHelper.onNotificationCreatedMethod,
  );

  await GetStorage.init();

  Get.put(ThemeController());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeProvider = Get.find<ThemeController>();
      return GetMaterialApp(
        title: 'App Time Management',
        initialRoute: initialRoute,
        getPages: getPages,
        theme: themeProvider.lightMode,
        darkTheme: themeProvider.darkMode,
        themeMode: themeProvider.themeMode.value,
        home: const WidgetThree(),
      );
    });
  }
}
