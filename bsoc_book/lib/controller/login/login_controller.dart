import 'dart:convert';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final box = GetStorage();
  RxBool isLoggedIn = false.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void onInit() {
    super.onInit();
    checkLoggedIn();
  }

  Future<void> checkLoggedIn() async {
    final SharedPreferences prefs = await _prefs;
    final bool? loggedIn = prefs.getBool('isLoggedIn');
    if (loggedIn != null && loggedIn) {
      isLoggedIn.value = true;
      Get.to(HomePage());
    }
  }

  Future<void> loginWithUsername() async {
    final formData = {
      'username': usernameController.text,
      'password': passwordController.text
    };

    try {
      Dio().options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      var response = await Dio().post('http://103.77.166.202/api/auth/login',
          data: json.encode(formData));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.data);
        var token = json['data']['accessToken'];
        var user = json['data']['username'];
        var email = json['data']['email'];
        var idUser = json['data']['id'].toString();
        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('accessToken', token);
        await prefs?.setString('username', user);
        await prefs?.setString('idInforUser', idUser);
        await prefs?.setString('emailuser', email);
        Get.snackbar("Thành công", "Đăng nhập thành công.");
        box.write('isLoggedIn', true);
        isLoggedIn.value = true;
        usernameController.clear();
        passwordController.clear();
        Get.to(HomePage());
      } else {
        throw Error();
      }
    } on DioError catch (e) {
      print(e.response!.data);
      if (e.response!.data['data'] == 'Error: Username is already taken!') {
        Get.snackbar("Lỗi đăng ký", "Tên người dùng đã được sử dụng!");
      } else if (e.response!.data['data'] ==
          'Error: Email is already in use!') {
        Get.snackbar("Lỗi đăng ký", "Email đã được sử dụng!");
      } else {
        return e.response!.data;
      }
    }
  }
}
