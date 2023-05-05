import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  Map? datauser;
  bool isLoading = true;
  String? token;

  Future<void> getUserDetail() async {
    try {
      isLoading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio().get(
        'http://103.77.166.202/api/user/profile',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        datauser = response.data;
        await prefs.setString('username', datauser!['username']);
        await prefs.setString('avatar', datauser!['avatar']);
        isLoading = false;
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
    } catch (e) {
      print(e);
    }
    update();
  }
}
