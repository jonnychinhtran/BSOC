import 'dart:convert';
import 'package:bsoc_book/data/network/api_client.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InforUserController extends GetxController {
  Future<void> getInforUser() async {
    String? token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.inforUser);
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['results'];

      print(response.body);
    } else {
      throw Exception('Lỗi tải dữ liệu');
    }
  }
}
