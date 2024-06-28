import 'package:get/get.dart';
import 'package:menejemen_waktu/src/ui/screens/app/app.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/sub/item_info_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/app/pages/sub/search_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/guest/auth/login_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/guest/auth/signup_screen.dart';
import 'package:menejemen_waktu/src/ui/screens/guest/guest.dart';

const initialRoute = "/";

String Function(String) cr = (String route) => "$initialRoute$route";

List<GetPage<dynamic>> get getPages => [
      GetPage(name: initialRoute, page: () => const GuestScreen()),
      GetPage(name: cr("app"), page: () => const AppScreen()),
      GetPage(name: cr("login"), page: () => const LoginScreen()),
      GetPage(name: cr("signup"), page: () => const SignupScreen()),
      GetPage(name: cr("search"), page: () => const SearchScreen()),
      GetPage(name: cr("getinfo"), page: () => const ItemInfoScreen())
    ];
