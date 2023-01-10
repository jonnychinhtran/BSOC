import 'dart:convert';
import 'package:bsoc_book/data/model/books/book_model.dart'
    show Content, BookModel;
import 'package:bsoc_book/view/user/book/book_detail_page.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Map? bookSearch;
List? listSearch;
// List<Map<String, dynamic>>? listSearch;

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

  BookModel? bookModel;

  void _getAllBooks() async {
    String? token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    var url = Uri.parse('http://103.77.166.202/api/book/all-book');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      setState(() {
        bookModel = BookModel.fromJson(
            jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
        isLoading = false;
      });
    } else {
      throw Exception('Lỗi tải hệ thống');
    }
  }

  @override
  void initState() {
    _getAllBooks();
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
              child: Autocomplete<Content>(
                optionsBuilder: (TextEditingValue value) {
                  if (value.text.isEmpty) {
                    return List.empty();
                  }
                  return bookModel!.content!
                      .where((element) =>
                          '${removeDiacritics(element.bookName!)} ${removeDiacritics(element.author!)} ${removeDiacritics(element.description!)} ${element.bookName} ${element.author} ${element.description}'
                              .toLowerCase()
                              .contains(value.text.toLowerCase()))
                      .toList();
                },
                fieldViewBuilder: (BuildContext context,
                        TextEditingController controller,
                        FocusNode node,
                        Function onSubmit) =>
                    TextField(
                  controller: controller,
                  focusNode: node,
                  decoration:
                      InputDecoration(hintText: 'Nhập tên sách tại đây...'),
                ),
                displayStringForOption: (Content d) =>
                    '${d.bookName} ${d.author} ${d.description}',
                onSelected: (value) => print(value.bookName),
                optionsViewBuilder: (BuildContext context, Function onSelect,
                    Iterable<Content> contentList) {
                  return Material(
                    child: ListView.builder(
                      itemCount: contentList.length,
                      itemBuilder: ((context, index) {
                        Content d = contentList.elementAt(index);
                        return InkWell(
                          onTap: () async {
                            final SharedPreferences? prefs = await _prefs;
                            await prefs?.setString('idbook', d.id!.toString());

                            print('idBook: ${d.id.toString()}');

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailBookPage(id: d.id!.toString())));
                          },
                          child: ListTile(
                            leading: Image.network(
                              'http://103.77.166.202' + d.image!,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                            title: Text(d.bookName!),
                            subtitle: Text(d.author!),
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
