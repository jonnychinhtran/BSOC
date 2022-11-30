import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

String? demo;
Map? mapDemo;
Map? demoReponse;
List? listReponse;

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  String? token;
  String? path;
  void getItemBooks() async {
    String? token;
    String? id;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    id = prefs.getString('idbook');

    var url = Uri.parse('http://103.77.166.202/api/book/$id');
    http.Response response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      await prefs.setString('token', response.body);
      print(prefs.getString('token'));
      mapDemo = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      listReponse = mapDemo!['chapters'];
      print(listReponse);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Lỗi tải hệ thống');
    }
  }

  // Future<void> openFile() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? namesave;
  //   namesave = mapDemo!['chapters']['filePath'];
  //   Directory? dir = Platform.isAndroid
  //       ? await getExternalStorageDirectory()
  //       : await getApplicationDocumentsDirectory();
  //   await OpenFilex.open('${dir?.path}/$namesave');
  // }

  @override
  void initState() {
    getItemBooks();
    // openFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 175, 52),
          centerTitle: true,
          title: Text('Danh sách đã tải'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: ListView.builder(
            itemCount: listReponse == null ? 0 : listReponse!.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  String? namesave;
                  namesave = listReponse![index]['filePath'].toString();
                  Directory? dir = await getApplicationDocumentsDirectory();
                  print('${dir.path}/$namesave');
                  listReponse![index]['downloaded'] == true
                      ? await OpenFilex.open('${dir.path}/$namesave')
                      : 'abc';

                  // '${dir?.path}/$namesave' == ''
                  //     ? ''
                  //     : showDialog(
                  //         context: context,
                  //         builder: (context) => AlertDialog(
                  //               title: Text("Thông báo"),
                  //               content: Column(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 children: [
                  //                   Text(
                  //                       'Tập tin pdf bị mất hoặc trùng tên vui lòng tải lại trong phần chương sách!')
                  //                 ],
                  //               ),
                  //             ));
                },
                child: Column(
                  children: [
                    ListTile(
                      title: Text(listReponse![index]['downloaded'] == true
                          ? listReponse![index]['filePath'].toString()
                          : ''),
                      subtitle: Text(
                        listReponse![index]['downloaded'] == true
                            ? listReponse![index]['chapterTitle'].toString()
                            : '',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 91, 91),
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              );
            }));
  }
}
