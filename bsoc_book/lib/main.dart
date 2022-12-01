import 'package:app_version_update/app_version_update.dart';
import 'package:bsoc_book/provider/bookmark_provider.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:update_handler/update_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
  UpdateHandler.androidAppId = "com.b4usolution.b4u_bsoc";
  UpdateHandler.iosAppId = "6444538062";
  final appleId =
      '6444538062'; // If this value is null, its packagename will be considered
  final playStoreId =
      'com.b4usolution.b4u_bsoc'; // If this value is null, its packagename will be considered
  final country = ''; // If this value is null 'us' will be the default value
  await AppVersionUpdate.checkForUpdates(
          appleId: appleId, playStoreId: playStoreId, country: country)
      .then((data) async {
    print(data.storeUrl);
    print(data.storeVersion);
    if (data.canUpdate!) {
      AppVersionUpdate.showAlertUpdate(appVersionResult: data);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookmarkProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'B4U BSOC',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CheckPage(),
        // initialRoute: Routes.login,
        // getPages: PageRoutes.pages,
      ),
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
