import 'package:bsoc_book/view/contact/contact_page.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/main_page.dart';
import 'package:bsoc_book/view/register/register_page.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:get/route_manager.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'app_routes.dart';

class PageRoutes {
  static var pages = [
    GetPage(name: Routes.main, page: () => const MainIndexPage()),
    GetPage(name: Routes.home, page: () => const HomePage()),
    GetPage(name: Routes.contact, page: () => const ContactPage()),
    GetPage(name: Routes.login, page: () => const LoginPage()),
    GetPage(name: Routes.reset, page: () => const RegisterPage()),
    GetPage(name: Routes.register, page: () => const RegisterPage()),
  ];
}
