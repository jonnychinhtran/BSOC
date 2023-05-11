import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangepassConntroller extends GetxController {
  final box = GetStorage();
  String? token;
  String? username;
  TextEditingController usernameController = TextEditingController();
  TextEditingController currentpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();

  Future<void> changepassUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = box.read('accessToken');
    username = prefs.getString('username');

    final formData = {
      "username": username,
      "currPassword": currentpasswordController.text,
      "newPassword": newpasswordController.text,
    };

    try {
      var response =
          await Dio().post('http://103.77.166.202/api/user/changepass',
              data: formData,
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              }));
      print(response);
      if (response.statusCode == 200) {
        // final jsondata = response.data;

        Get.snackbar("Thành công", "Thay đổi mật khẩu thành công.");
        usernameController.clear();
        currentpasswordController.clear();
        newpasswordController.clear();
      } else {
        Get.snackbar("Lỗi", "Thay đổi thất bại. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }
}
