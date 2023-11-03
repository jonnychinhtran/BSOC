import 'package:bsoc_book/app/view/contact/contact_page.dart';
import 'package:bsoc_book/app/view/infor/infor_page.dart';
import 'package:bsoc_book/app/view/login/login_page.dart';
import 'package:bsoc_book/app/view/register/register_page.dart';
import 'package:bsoc_book/app/view/resetpassword/reset_pass_page.dart';
import 'package:bsoc_book/app/view/user/home/home_page.dart';
import 'package:get/route_manager.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'app_routes.dart';

class PageRoutes {
  static var pages = [
    // GetPage(name: Routes.home, page: () => HomePage()),
    GetPage(name: Routes.contact, page: () => const ContactPage()),
    GetPage(name: Routes.login, page: () => const LoginPage()),
    GetPage(name: Routes.reset, page: () => ResetPassPage()),
    GetPage(name: Routes.register, page: () => const RegisterPage()),
    GetPage(name: Routes.infor, page: () => const InforPage()),
  ];
}
