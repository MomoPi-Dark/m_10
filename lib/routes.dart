import 'package:get/get.dart';
import 'package:menejemen_waktu/src/ui/screens/app/app.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/sub/item_info_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/sub/profile/profile_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/sub/search_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/tasks/screen.dart';
import 'package:menejemen_waktu/src/ui/screens/guest/auth/login_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/guest/auth/signup_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/guest/guest.dart';

const initialRoute = "/";

String Function(
  String, {
  String? route,
  List<String>? anyRoute,
}) cr = (
  String path, {
  String? route = '/',
  List<String>? anyRoute,
}) =>
    "$route$path${anyRoute != null ? anyRoute.map((e) => '$route$e').join('') : ""}";

Duration transitionDuration = const Duration(milliseconds: 700);

List<GetPage<dynamic>> get getPages => [
      GetPage(
        name: initialRoute,
        page: () => const GuestScreen(),
        transition: Transition.cupertinoDialog,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: cr("app"),
        page: () => const AppScreen(),
        transition: Transition.cupertinoDialog,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: cr("login"),
        page: () => const LoginScreen(),
        transition: Transition.cupertinoDialog,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: cr("signup"),
        page: () => const SignupScreen(),
        transition: Transition.cupertinoDialog,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: cr("search"),
        page: () => const SearchScreen(),
        transition: Transition.cupertinoDialog,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: cr("getinfo"),
        page: () => const ItemInfoScreen(),
        transition: Transition.cupertinoDialog,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: cr("addtask"),
        page: () => const TaskScreen(),
        transition: Transition.cupertinoDialog,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: cr("edittask"),
        page: () => const TaskScreen(),
        transition: Transition.cupertinoDialog,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: cr("profile"),
        page: () => const ProfileScreen(),
        transition: Transition.cupertinoDialog,
        transitionDuration: transitionDuration,
      )
    ];
