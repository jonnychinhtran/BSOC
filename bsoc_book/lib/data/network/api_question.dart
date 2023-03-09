import 'dart:convert';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "https://opentdb.com/api.php";

Future<List<Question>> getQuestions() async {
  String url = "$baseUrl?amount=10";
  http.Response res = await http.get(Uri.parse(url));
  List<Map<String, dynamic>> questions =
      List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
  return Question.fromData(questions);
}
