import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UpdateUserController extends GetxController {
  final box = GetStorage();
  final TextEditingController fullnameController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void updateUser() async {
    final String? token = box.read('accessToken');

    if (token == null) {
      // Handle token not found scenario
      return;
    }

    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    final String url = 'http://103.77.166.202/api/user/update';

    try {
      final formData = {
        'fullname': fullnameController.text,
        // 'email': emailController.text,
        'phone': phoneController.text,
      };
      print(formData);
      final response = await dio.post(
        url,
        data: formData,
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'User information updated successfully');
        // Perform any necessary actions upon successful update
      } else {
        Get.snackbar('Error', 'Failed to update user information');
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'An error occurred while updating user information');
      print(e);
    }
  }

  @override
  void onClose() {
    fullnameController.dispose();
    // emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
