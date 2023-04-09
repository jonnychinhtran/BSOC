import 'package:bsoc_book/controller/authen/authen_controller.dart';
import 'package:bsoc_book/routes/app_pages.dart';
import 'package:bsoc_book/routes/app_routes.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AuthController authController = Get.put(AuthController());
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
    );
  }
}

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    box.writeIfNull('isLoggedIn', false);

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
    box.read('isLoggedIn')
        ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false)
        : Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
  }
}
