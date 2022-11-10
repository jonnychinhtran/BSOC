import 'dart:convert';
import 'package:bsoc_book/data/network/api_client.dart';
import 'package:bsoc_book/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterationController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithUser() async {
    // try {
    var headers = {'content-type': 'application/json'};
    var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerUser);
    Map body = {
      "username": usernameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "phone": phoneController.text,
    };

    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // var token = int.parse(json['data']['accessToken']).toString();
      // final SharedPreferences prefs = await _prefs;
      // await prefs.setString('accessToken', token);
      Get.offAndToNamed(Routes.login);
    } else {
      throw jsonDecode(response.body)["Message"] ??
          "Liên kết API không chính xác";
    }
    // } catch (e) {
    // Get.back();
    // showDialog(
    //     context: Get.context!,
    //     builder: (context) {
    //       return SimpleDialog(
    //         title: const Text('Error'),
    //         contentPadding: const EdgeInsets.all(20),
    //         children: [Text(e.toString())],
    //       );
    //     });
    // }
  }
}
