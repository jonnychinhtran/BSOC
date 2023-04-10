import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentController extends GetxController {
  TextEditingController ratingController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String? token;
  String? idUser;
  String? idbooks;
  double? rating;

  // getIdbook() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   idbooks = prefs.getString('idbook');
  //   print(idbooks);
  //   token = prefs.getString('accessToken');
  // }

  Future<void> commentUserBook() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idbooks = prefs.getString('idbook');
    idUser = prefs.getString('idInforUser');
    rating = prefs.getDouble('rating');
    int min = rating!.toInt();
    print(token);
    print(idUser);

    print(rating);
    // int value1 = int.parse(ratingController.text);
    final formData = {
      "userId": idUser,
      "bookId": idbooks,
      "rating": min,
      "content": contentController.text,
    };
    try {
      var response = await Dio().post('http://103.77.166.202/api/book/comment',
          data: json.encode(formData),
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final jsondata = response.data;
        print(jsondata);
        ratingController.clear();
        contentController.clear();
        Get.snackbar("Thành công", "Đánh giá thành công.");
      } else {
        Get.snackbar("Lỗi", "Đánh giá thất bại. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }
}
