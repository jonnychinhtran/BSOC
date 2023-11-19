import 'dart:convert';
import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/view/home/home_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage(
      {super.key,
      required this.bookModel,
      required this.homeViewModel,
      required this.parentViewState});

  final List<BookModel> bookModel;
  final HomeViewModel homeViewModel;
  final HomeViewState parentViewState;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  bool isLoading = true;
  String? token;
  List<BookModel> _books = [];

  @override
  void initState() {
    _books = widget.bookModel;
    super.initState();
  }

  static Future<List<BookModel>> getAllBooks(dynamic value) async {
    var url = Uri.parse('http://103.77.166.202/api/book/all-book');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> bookModel =
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      List<BookModel> books = (bookModel["content"] as List)
          .map((item) => BookModel.fromJson(item))
          .toList();

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 175, 52),
          centerTitle: true,
          title: const Text('Tìm kiếm sách'),
        ),
        body: Column(children: [
          Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: TypeAheadField(
                  hideSuggestionsOnKeyboardHide: false,
                  textFieldConfiguration: const TextFieldConfiguration(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: 'Tìm kiếm sách',
                    ),
                  ),
                  suggestionsCallback: (dynamic value) async {
                    var url =
                        Uri.parse('http://103.77.166.202/api/book/all-book');
                    http.Response response = await http.get(url);
                    if (response.statusCode == 200) {
                      Map<String, dynamic> bookModel = jsonDecode(
                          const Utf8Decoder().convert(response.bodyBytes));
                      List<BookModel> books = (bookModel["content"] as List)
                          .map((item) => BookModel.fromJson(item))
                          .toList();

                      return books
                          .where((book) =>
                              '${removeDiacritics(book.bookName!)} ${removeDiacritics(book.author!)}'
                                  .toLowerCase()
                                  .contains(
                                      removeDiacritics(value).toLowerCase()))
                          .toList();
                    } else {
                      throw Exception('Lỗi tải hệ thống');
                    }
                  },
                  itemBuilder: (context, BookModel suggestion) {
                    final book = suggestion;

                    return ListTile(
                      leading: Image.network(
                        AppDataGlobal().domain + book.image!,
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
                    child: const Center(
                      child: Text(
                        'Không tìm thấy sách',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  onSuggestionSelected: (BookModel suggestion) async {
                    final book = suggestion;
                    widget.homeViewModel.bookId = book.id!;
                    widget.homeViewModel.getBookDetailPage().then((value) {
                      if (value != null) {
                        widget.parentViewState.jumpPageBookDetailPage();
                      }
                    });
                  },
                ),
              ))
        ]));
  }
}
