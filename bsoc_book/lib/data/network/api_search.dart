import 'package:bsoc_book/data/model/books/book_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BackendService {
  // BookModel? bookModel;

  // Future<void> _getAllBooks() async {
  //   String? token;
  //   final prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('accessToken');

  //   var url = Uri.parse('http://103.77.166.202/api/book/all-book');
  //   http.Response response = await http.get(url, headers: {
  //     'Authorization': 'Bearer $token',
  //   });
  //   if (response.statusCode == 200) {
  //     bookModel = BookModel.fromJson(
  //         jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
  //   } else {
  //     throw Exception('Lỗi tải hệ thống');
  //   }
  // }

  static Future<List<Content>> getSuggestions(String pattern) async {
    String? token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    var url = Uri.parse('http://103.77.166.202/api/book/all-book');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final List books = json.decode(response.body);
      print(books);
      return books.map((json) => Content.fromJson(json)).where((book) {
        final nameLower = book.bookName!.toLowerCase();
        final queryLower = pattern.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
