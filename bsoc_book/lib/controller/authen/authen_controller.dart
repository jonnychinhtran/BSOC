import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    checkIsLoggedIn();
  }

  void checkIsLoggedIn() {
    bool loggedIn = box.read('isLoggedIn') ?? false;
    isLoggedIn.value = loggedIn;
  }
}
