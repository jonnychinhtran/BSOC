import 'package:bsoc_book/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteUserController extends GetxController {
  Future<void> deleteUser() async {
    try {
      String? token;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');

      var response = await Dio().post('http://103.77.166.202/api/user/delete',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        Get.offNamed(Routes.login);
      } else {
        Get.snackbar("lỗi", "Xóa tải khoản lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }
}
