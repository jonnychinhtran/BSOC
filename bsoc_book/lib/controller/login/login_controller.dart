import 'dart:convert';
import 'package:bsoc_book/data/network/api_client.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> loginWithUsername() async {
    var headers = {'content-type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginUser);
      Map body = {
        'username': usernameController.text,
        'password': passwordController.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var token = json['data']['accessToken'];
        var user = json['data']['username'];
        var email = json['data']['email'];
        var idUser = json['data']['id'].toString();
        print(response.body);
        // print(token);
        final SharedPreferences? prefs = await _prefs;

        await prefs?.setString('accessToken', token);
        await prefs?.setString('username', user);
        await prefs?.setString('idInforUser', idUser);
        await prefs?.setString('emailuser', email);

        Get.snackbar("Thành công", "Đăng nhập thành công.");
        Get.offAll(HomePage());
        usernameController.clear();
        passwordController.clear();
      } else {
        throw jsonDecode(response.body)["Thông báo"] ?? "Vui lòng đăng nhập";
      }
    } catch (e) {
      Get.snackbar("Lỗi đăng nhập", "Không có tài khoản này");
      print(e);
    }
  }
}
