import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class ResetController extends GetxController {
  TextEditingController emailController = TextEditingController();

  Future<void> Resetpassword() async {
    try {
      var response = await Dio()
          .post('http://103.77.166.202/api/user/resetpass', queryParameters: {
        "email": emailController.text,
      });
      if (response.statusCode == 200) {
        final json = response.data;
        print(json);
        Get.snackbar("Thành công", "Email đã gửi thành công.");
        emailController.clear();
        Get.offNamed(Routes.login);
      } else {
        Get.snackbar("lỗi", "Email Không gửi được. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }
}
