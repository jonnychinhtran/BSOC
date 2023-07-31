import 'package:bsoc_book/controller/authen/authen_controller.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final AuthController authController = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    box.writeIfNull('isLoggedIn', false);

    Future.delayed(Duration.zero, () async {
      bool isLoggedIn = box.read('isLoggedIn');
      print(isLoggedIn);
      final token = box.read('accessToken');
      print('Token: $token');
      if (token != null) {
        DateTime? expiryDate = Jwt.getExpiryDate(token);
        print(expiryDate);
        // To check if token is expired
        bool isExpired = Jwt.isExpired(token);
        print(!isExpired);
        if (!isExpired && isLoggedIn) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          // Token is expired
          authController.logout();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Thông báo'),
                content: Text('Phiên làm việc hết hạn, đăng nhập lại'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Đồng ý'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      } else {
        // Token is null
        authController.logout();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  // void checkiflogged() async {

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}
