import 'package:bsoc_book/data/model/quiz/question2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const String baseUrl = "http://103.77.166.202/api/quiz/subject-info";

// const String baseUrl = "http://103.77.166.202/api/quiz/list-question";

Map<String, dynamic>? headquestions;

Future<void> getSubject2(int? total) async {
  String url = "$baseUrl/$total";
  final response = await Dio().get(url);
  headquestions = response.data;
  // final questions = List<Map<String, dynamic>>.from(response.data);
  // debugPrint(questions.toString(), wrapWidth: 1024);
  // return Question2.fromData(questions);
}
