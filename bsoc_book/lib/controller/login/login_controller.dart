import 'dart:convert';

import 'package:bsoc_book/data/network/api_client.dart';
import 'package:bsoc_book/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        var idUser = json['data']['id'].toString();
        print(response.body);
        // print(token);
        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('accessToken', token);
        await prefs?.setString('username', user);
        await prefs?.setString('idInforUser', idUser);
        var hoang = await prefs?.getString('accessToken');
        print(hoang);
        Get.snackbar("Thành công", "Đăng nhập thành công.");
        Get.offNamed(Routes.main);
        usernameController.clear();
        passwordController.clear();
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Vui lòng đăng nhập";
      }
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }

  //save token
  // Future<void> saveToken(String token) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('accessToken');
  //   prefs.setString('accessToken', token);
  // }

  // //get token
  // Future<String> getToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('accessToken') ?? '';
  // }

  // Future<void> saveUserId(int id) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('userId');
  //   prefs.setInt('userId', id);
  // }

  // Future<bool> logout() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return await prefs.remove('accessToken');
  // }
}
