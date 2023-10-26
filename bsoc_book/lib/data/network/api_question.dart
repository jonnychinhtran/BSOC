import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://103.77.166.202/api/quiz/list-question";

Map<String, dynamic>? data2;
String? token;

Future<List<Question>> getQuestions(int? total) => NetworkUtil2()
        .get(
            url:
                '${NetworkEndpoints.GET_CHECK_IN_LIST}?date=$date&type=$type&page=$page&per-page=10')
        .then((dynamic response) {
      final responseModel = ResponseModel.fromJson(response);
      if (responseModel.status == NetworkConfig.STATUS_OK) {
        final resultModel = responseModel.result;
        if (resultModel!.status == NetworkConfig.STATUS_OK) {
          final data = resultModel.data;
          // CheckInListModel checkInListModel = CheckInListModel.fromJson(data);
          // return checkInListModel;
          final items = data['items'];
          List<CheckInModel> list = [];
          for (int i = 0; i < items.length; i++) {
            CheckInModel checkInModel = CheckInModel.fromJson(items[i]);
            list.add(checkInModel);
          }
          return list;
        }
      }
      return [];
    });

Future<List<Question>> getQuestions(int? total) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  final box = GetStorage();
  token = box.read('accessToken');
  print('Token Question: $token');
  String url = "$baseUrl/$total";
  final response = await Dio().get(
    url,
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
  print('Get Question: $response');
  data2 = response.data;
  final questions =
      List<Map<String, dynamic>>.from(response.data["listQuestion"]);
  debugPrint(questions.toString(), wrapWidth: 1024);
  return Question.add(questions);
}
