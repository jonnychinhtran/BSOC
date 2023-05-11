import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://103.77.166.202/api/quiz/subject-info";

Map<String, dynamic>? headquestions;

Future<void> getSubject2(int? total) async {
  String? token;
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  final box = GetStorage();
  bool isLoggedIn = box.read('isLoggedIn');
  if (isLoggedIn) {
    token = box.read('accessToken');
  }

  String url = "$baseUrl/$total";
  final response = await Dio().get(
    url,
    options: isLoggedIn
        ? Options(headers: {'Authorization': 'Bearer $token'})
        : null,
  );
  headquestions = response.data;
}
