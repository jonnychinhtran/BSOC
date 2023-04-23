import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const String baseUrl = "http://103.77.166.202/api/quiz/list-question";

Map<String, dynamic>? headquestion;

Future<List<Question>> getQuestions(int? total) async {
  String url = "$baseUrl/$total";
  final response = await Dio().get(url);
  headquestion = response.data;
  final questions =
      List<Map<String, dynamic>>.from(response.data["listQuestion"]);
  debugPrint(questions.toString(), wrapWidth: 1024);
  return Question.fromData(questions);
}
