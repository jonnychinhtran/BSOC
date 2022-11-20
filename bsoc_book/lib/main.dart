import 'package:bsoc_book/routes/app_pages.dart';
import 'package:bsoc_book/routes/app_routes.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'B4U BSOC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckPage(),
      // initialRoute: Routes.login,
      // getPages: PageRoutes.pages,
    );
  }
}

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final userdate = GetStorage();
  @override
  void initState() {
    super.initState();
    userdate.writeIfNull('isLogged', false);

    Future.delayed(Duration.zero, () async {
      checkiflogged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }

  void checkiflogged() {
    userdate.read('isLogged')
        ? Get.offAll(HomePage())
        : Get.offAll(LoginPage());
  }
}
