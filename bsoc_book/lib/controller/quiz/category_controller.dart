import 'dart:convert';

import 'package:bsoc_book/data/model/quiz/category.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var selectedCategory = "".obs;
  String? token;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio().get(
          'http://103.77.166.202:9999/api/quiz/list-subject',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.data);
        categories.value =
            data.map((category) => Category.fromJson(category)).toList();
        print(data);
      } else {
        Get.snackbar("Lỗi", "Lấy dữ liệu thất bại. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }
}
