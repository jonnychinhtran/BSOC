import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final box = GetStorage();
  Map? datauser;
  RxBool isLoading = RxBool(false);
  String? token;

  getUserDetail() async {
    final SharedPreferences prefs = await _prefs;
    token = box.read('accessToken');
    print('token user get - $token');
    try {
      isLoading.value = true;
      var response = await Dio().get(
        'http://103.77.166.202/api/user/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        datauser = response.data;
        await prefs.setString('username', datauser!['username']);
        await prefs.setString('avatar', datauser!['avatar']);
        isLoading.value = false;
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
    } catch (e) {
      print(e);
    }
  }
}
