import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

String? demo;
Map? mapDemo;
Map? demoReponse;
List? listReponse;

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key, required this.id});
  final String id;

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ConnectivityResult connectivity = ConnectivityResult.none;
  bool isLoading = true;
  String? token;
  String? path;
  void getItemBooks() async {
    String? token;
    // String? id;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    // id = prefs.getString('idbook');

    var url = Uri.parse('http://103.77.166.202/api/book/${widget.id}');
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

  void _openFile(PlatformFile file) {
    OpenFilex.open(file.path);
  }

  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {
      getItemBooks();
    }
  }

  @override
  void initState() {
    getItemBooks();
    callback();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 175, 52),
          centerTitle: true,
          title: Text('Danh sách tải về'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.folder),
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result == null) return;
                final file = result.files.first;
                _openFile(file);
                setState(() {});
              },
            ),
          ],
        ),
        body:
            // OfflineBuilder(
            //     connectivityBuilder: (
            //       BuildContext context,
            //       ConnectivityResult connectivity,
            //       Widget child,
            //     ) {
            //       if (connectivity == ConnectivityResult.none) {
            //         return Container(
            //           color: Colors.white70,
            //           child: Center(
            //             child: Padding(
            //               padding: const EdgeInsets.all(16.0),
            //               child: Column(
            //                 children: [
            //                   Image.asset('assets/images/wifi.png'),
            //                   Text(
            //                     'Không có kết nối Internet',
            //                     style: TextStyle(
            //                         color: Colors.black,
            //                         fontWeight: FontWeight.bold),
            //                   ),
            //                   Text(
            //                     'Vui lòng kiểm tra kết nối internet và thử lại',
            //                     style: TextStyle(color: Colors.black),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //       } else {
            //         return child;
            //       }
            //     },
            //     child:
            isLoading
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                    color: Color.fromARGB(255, 138, 175, 52),
                    secondRingColor: Colors.black,
                    thirdRingColor: Colors.purple,
                    size: 30,
                  ))
                : ListView.builder(
                    itemCount: listReponse == null ? 0 : listReponse!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return listReponse![index]['allow'] == true
                          ? GestureDetector(
                              onTap: () async {
                                String? namesave;
                                namesave =
                                    listReponse![index]['filePath'].toString();
                                Directory? dir = Platform.isAndroid
                                    ? await getExternalStorageDirectory()
                                    : await getApplicationDocumentsDirectory();

                                listReponse![index]['downloaded'] == true
                                    ? await OpenFilex.open(
                                        '${dir?.path}/$namesave')
                                    : Get.snackbar("Thông báo",
                                        "File chưa tải hoặc mất file lưu, vui lòng tải lại");

                                // showDialog(
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
                                    title: listReponse![index]['downloaded'] ==
                                            true
                                        ? Text(listReponse![index]['filePath']
                                            .toString())
                                        : Text(
                                            listReponse![index]['filePath']
                                                    .toString() +
                                                '- File chưa tải về',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                    subtitle: listReponse![index]
                                                ['downloaded'] ==
                                            true
                                        ? Text(
                                            listReponse![index]['chapterTitle']
                                                .toString(),
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 91, 91),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          )
                                        : Text(
                                            listReponse![index]['chapterTitle']
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                  ),
                                  Divider(
                                    height: 2,
                                    endIndent: 0,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            )
                          : Container();
                    })
        // )
        );
  }
}
