import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menejemen_waktu/src/app.dart';
import 'package:menejemen_waktu/src/screen/pages/home.dart';

const initialRoute = "/";
Function(String) cr = (String route) => "$initialRoute$route";

Map<String, WidgetBuilder> routes = {};

List<GetPage<dynamic>> getPages = [
  GetPage(name: cr("app"), page: () => const AppScreen()),
  GetPage(name: cr("home"), page: () => const HomeScreen())
];
