import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/controller/authen/authen_controller.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'resource/values/app_colors.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await GetStorage.init();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://7aa1ca68e853ae9aa6edd85d7e7410b6@o4504015220965376.ingest.sentry.io/4505819997274112';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );

  // runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final AuthController authController = Get.put(AuthController());

  _MyAppState() {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
    AppDataGlobal();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'B4U BSOC',
        theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.PRIMARY_COLOR,
          ),
        ),
        initialRoute: "/",
        onGenerateRoute: Application.router.generator);
    return app;
  }
}

// class CheckPage extends StatefulWidget {
//   const CheckPage({super.key});

//   @override
//   State<CheckPage> createState() => _CheckPageState();
// }

// class _CheckPageState extends State<CheckPage> {
//   final box = GetStorage();
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//   final AuthController authController = Get.put(AuthController());
//   @override
//   void initState() {
//     super.initState();
//     box.writeIfNull('isLoggedIn', false);

//     Future.delayed(Duration.zero, () async {
//       bool isLoggedIn = box.read('isLoggedIn');
//       print(isLoggedIn);
//       final token = box.read('accessToken');
//       print('Token: $token');
//       if (token != null) {
//         DateTime? expiryDate = Jwt.getExpiryDate(token);
//         print(expiryDate);
//         // To check if token is expired
//         bool isExpired = Jwt.isExpired(token);
//         print(!isExpired);
//         if (!isExpired && isLoggedIn) {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => HomePage()));
//         } else {
//           // Token is expired
//           authController.logout();
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Thông báo'),
//                 content: Text('Phiên làm việc hết hạn, đăng nhập lại'),
//                 actions: <Widget>[
//                   TextButton(
//                     child: Text('Đồng ý'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => HomePage()));
//         }
//       } else {
//         // Token is null
//         authController.logout();
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => HomePage()));
//       }
//     });
//   }

//   // void checkiflogged() async {

//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Center(
//         child: CircularProgressIndicator(),
//       )),
//     );
//   }
// }
