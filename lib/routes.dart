import 'package:get/get.dart';
import 'package:menejemen_waktu/src/ui/screens/mobile/auth/welcome_screen.dart';

import 'src/ui/screens/app.dart';
import 'src/ui/screens/mobile/add_item_screen.dart';
import 'src/ui/screens/mobile/auth/login_screen.dart';
import 'src/ui/screens/mobile/auth/signup_screen.dart';

const initialRoute = "/";

Function(String) cr = (String route) => "$initialRoute$route";

List<GetPage<dynamic>> get getPages => [
      GetPage(name: initialRoute, page: () => const WelcomeScreen()),
      GetPage(name: cr("app"), page: () => const AppScreen()),
      GetPage(name: cr("addTask"), page: () => const AddItemScreen()),
      GetPage(name: cr("login"), page: () => const LoginScreen()),
      GetPage(name: cr("signup"), page: () => const SignupScreen())
    ];
