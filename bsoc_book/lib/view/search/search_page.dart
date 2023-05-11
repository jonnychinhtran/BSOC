import 'dart:convert';
import 'package:bsoc_book/data/model/books/allbook_model.dart';
import 'package:bsoc_book/data/model/books/book_model.dart'
    show Content, BookModel;
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/user/book/book_detail_page.dart';
import 'package:diacritic/diacritic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Map? bookSearch;
List? listSearch;
// List<dynamic>? data2;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final controller = TextEditingController();
  bool isLoading = true;
  String? token;
  List<Content> books = [];
  // BookModel? bookModel;

  static Future<List<Content>> getAllBooks(String value) async {
    String? token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    var url = Uri.parse('http://103.77.166.202/api/book/all-book');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> bookModel =
          jsonDecode(Utf8Decoder().convert(response.bodyBytes));

      List<Content> books = bookModel["content"];
      print(books);
      return books
          .where((element) =>
              '${removeDiacritics(element.bookName!)} ${removeDiacritics(element.author!)} ${element.bookName} ${element.author}'
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
    } else {
      throw Exception('Lỗi tải hệ thống');
    }
  }

  @override
  void initState() {
    // InternetPopup().initialize(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 175, 52),
          centerTitle: true,
          title: Text('Tìm kiếm sách'),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: TypeAheadField(
                  hideSuggestionsOnKeyboardHide: false,
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: 'Tìm kiếm sách',
                    ),
                  ),
                  suggestionsCallback: (value) async {
                    String? token;
                    final prefs = await SharedPreferences.getInstance();
                    token = prefs.getString('accessToken');
                    var url =
                        Uri.parse('http://103.77.166.202/api/book/all-book');
                    http.Response response = await http.get(url, headers: {
                      'Authorization': 'Bearer $token',
                    });
                    if (response.statusCode == 200) {
                      Map<String, dynamic> bookModel =
                          jsonDecode(Utf8Decoder().convert(response.bodyBytes));

                      List<dynamic> books = bookModel["content"];
                      print(books);
                      return books
                          .map((json) => Content.fromJson(json))
                          .where((user) =>
                              '${removeDiacritics(user.bookName!)} ${removeDiacritics(user.author!)}'
                                  .toLowerCase()
                                  .contains(
                                      removeDiacritics(value).toLowerCase()))
                          .toList();
                    } else {
                      throw Exception('Lỗi tải hệ thống');
                    }
                  },
                  itemBuilder: (context, Content? suggestion) {
                    final book = suggestion!;
                    print(book);
                    return ListTile(
                      leading: Image.network(
                        'http://103.77.166.202' + book.image!,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(book.bookName!),
                      subtitle: Text(book.author!),
                    );
                  },
                  noItemsFoundBuilder: (context) => Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        'Không tìm thấy sách',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  onSuggestionSelected: (Content? suggestion) {
                    final book = suggestion!;
                    print(book);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailBookPage(id: book.id!.toString())));
                  },
                ),
              ),
            )
          ],
        ));
  }
}
