import 'dart:convert';
import 'package:bsoc_book/routes/app_routes.dart';
import 'package:bsoc_book/view/user/book/book_detail_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentController extends GetxController {
  TextEditingController ratingController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> commentUserBook() async {
    String? token;
    String? idUser;
    String? idBook;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idBook = prefs.getString('idbook');
    idUser = prefs.getString('idInforUser');

    int value1 = int.parse(ratingController.text);
    final formData = {
      "userId": idUser,
      "bookId": idBook,
      "rating": value1,
      "content": contentController.text,
    };

    try {
      var response = await Dio().post('http://103.77.166.202/api/book/comment',
          data: json.encode(formData),
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final jsondata = response.data;
        print(jsondata);
        Get.snackbar("Thành công", "Bình luận thành công.");
        ratingController.clear();
        contentController.clear();
        Get.to(DetailBookPage());
      } else {
        Get.snackbar("Lỗi", "Bình luận thất bại. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }
}