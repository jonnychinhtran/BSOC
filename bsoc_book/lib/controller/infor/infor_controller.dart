import 'dart:convert';

import 'package:bsoc_book/data/network/api_client.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../data/model/infor/infor_model.dart';

class InforUserController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var inforUser = <Infor>[].obs;
  Future<void> getInforuser() async {
    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.inforUser);
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      return;
    }
  }
}
