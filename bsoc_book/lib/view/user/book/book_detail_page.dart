import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String? demo;
Map? mapDemo;
Map? demoReponse;
List? listReponse;
Map? viewbook;
String? ipchapter;
String? datapdf;

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage>
    with TickerProviderStateMixin {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;

  void getItemBooks() async {
    String? token;
    String? id;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    id = prefs.getString('idbook');
    print('Token: $token');
    print('ID Book: $id');

    var url = Uri.parse(
        'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/book/$id');
    http.Response response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      await prefs.setString('token', response.body);
      print(prefs.getString('token'));
      mapDemo = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      listReponse = mapDemo!['chapters'];
      // ipchapter = listReponse['chapterId'].toString();
      // print('ChapterID: $ipchapter');
      setState(() {
        // print(listReponse);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Infor');
    }
  }

  @override
  void initState() {
    getItemBooks();
    // getDownloadBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Center(child: Text('Detail Book')),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'cover',
                        child: Container(
                            height: 200,
                            width: 150,
                            child: Material(
                              child: mapDemo == null
                                  ? Text('Data is loading')
                                  : Image.network(
                                      'http://ec2-54-172-194-31.compute-1.amazonaws.com' +
                                          mapDemo?['image'],
                                      fit: BoxFit.fill,
                                    ),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Hero(
                        tag: 'title',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(mapDemo?['bookName'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              mapDemo?['author'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(
                          text: "Mô tả",
                        ),
                        Tab(
                          text: "Chương",
                        ),
                        Tab(
                          text: "Đánh giá",
                        ),
                      ]),
                ),
                Container(
                  width: double.maxFinite,
                  height: 320,
                  constraints: BoxConstraints(maxHeight: double.infinity),
                  child: TabBarView(controller: _tabController, children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: mapDemo == null
                          ? Text('Data is loading')
                          : Text(
                              mapDemo?['description'],
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount:
                            listReponse == null ? 0 : listReponse?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              final SharedPreferences? prefs = await _prefs;
                              await prefs?.setString('idchapter',
                                  listReponse![index]['id'].toString());
                              await prefs?.setString(
                                  'titleChapter',
                                  listReponse![index]['chapterTitle']
                                      .toString());
                              print(
                                  'ChapterID Click: ${listReponse![index]['id'].toString()}');
                              Navigator.push(
                                context,
                                MaterialPageRoute<dynamic>(
                                    builder: (_) => PdfViewerPage()),
                              );
                            },
                            child: Card(
                              color: Colors.purple,
                              child: Row(children: [
                                Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Chương: ' +
                                                listReponse![index]['chapterId']
                                                    .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                listReponse?[index]
                                                    ['chapterTitle'],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              IconButton(
                                                  onPressed: () async {
                                                    final SharedPreferences?
                                                        prefs = await _prefs;
                                                    await prefs?.setString(
                                                        'idchapter',
                                                        listReponse![index]
                                                                ['id']
                                                            .toString());
                                                    await prefs?.setString(
                                                        'titleChapter',
                                                        listReponse![index]
                                                                ['chapterTitle']
                                                            .toString());
                                                    print(
                                                        'ChapterID Click: ${listReponse![index]['id'].toString()}');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute<
                                                              dynamic>(
                                                          builder: (_) =>
                                                              PdfViewerPage()),
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.import_contacts_sharp,
                                                    color:
                                                        Colors.yellow.shade200,
                                                  )),
                                              IconButton(
                                                  onPressed: () async {
                                                    final SharedPreferences?
                                                        prefs = await _prefs;
                                                    await prefs?.setString(
                                                        'idchapter',
                                                        listReponse![index]
                                                                ['id']
                                                            .toString());
                                                    await prefs?.setString(
                                                        'titleChapter',
                                                        listReponse![index]
                                                                ['chapterTitle']
                                                            .toString());
                                                    print(
                                                        'ChapterID Click: ${listReponse![index]['id'].toString()}');
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          const DownloadingDialog(),
                                                    );
                                                  },
                                                  icon: Icon(
                                                      Icons.download_sharp,
                                                      color: Colors
                                                          .green.shade100))
                                            ],
                                          ),
                                        ])),
                              ]),
                            ),
                          );
                        }),
                    Container(),
                  ]),
                ),
              ],
            ),
    );
  }
}

class PdfViewerPage extends StatefulWidget {
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;
  String? titleChapter;

  void getTitleChap() async {
    final prefs = await SharedPreferences.getInstance();
    titleChapter = prefs.getString('accessToken');
  }

  @override
  void initState() {
    super.initState();

    ApiServiceProvider.loadPDF().then((value) {
      setState(() {
        localPath = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "BSOC App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class ApiServiceProvider {
  static Future<String> loadPDF() async {
    String? token;
    String? idchapter;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idchapter = prefs.getString('idchapter');
    print('Token ChapterID: $token');
    print('ChapterID: $idchapter');
    var url = Uri.parse(
        'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/chapter/download/$idchapter');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/pdf'
    });

    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }
}

class DownloadingDialog extends StatefulWidget {
  const DownloadingDialog({Key? key}) : super(key: key);

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  Map<String, dynamic> result = {
    'isSuccess': false,
    'filePath': null,
    'error': null,
  };
  double progress = 0.0;
  String? localPath;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  void startDownloading() async {
    Dio dio = Dio();
    String? token;
    String? idchapter;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idchapter = prefs.getString('idchapter');

    String url =
        'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/chapter/download/$idchapter';

    dio.options.headers["Authorization"] = "Bearer $token";
    dio.get(url);
    String fileName = "data.pdf";
    String path = await _getFilePath(fileName);
    // final result = await OpenFilex.open(path);

    await dio.download(
      url,
      path,
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });
        print(progress);
      },
      deleteOnError: true,
    ).then((_) {
      Navigator.pop(context);
    });
  }

  Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$filename";
  }

  @override
  void initState() {
    super.initState();
    startDownloading();
  }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Downloading: $downloadingprogress%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
