import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
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
      setState(() {
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detail Book'),
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
                const SizedBox(
                  height: 10,
                ),
                Hero(
                  tag: 'cover',
                  child: Container(
                      height: 195,
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
                  height: 10,
                ),
                Container(
                  child: Hero(
                    tag: 'title',
                    child: Container(
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
                  ),
                ),
                TabBar(
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
                Expanded(
                    child: Container(
                  child:
                      TabBarView(controller: _tabController, children: <Widget>[
                    Container(
                      child: ListView(
                        children: [
                          mapDemo == null
                              ? Text('Data is loading')
                              : Text(
                                  mapDemo?['description'],
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      fontSize: 16, height: 1.5),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      child: ListView.builder(
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
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
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
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    listReponse?[index]
                                                        ['chapterTitle'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: false,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () async {
                                                          final SharedPreferences?
                                                              prefs =
                                                              await _prefs;
                                                          await prefs?.setString(
                                                              'idchapter',
                                                              listReponse![
                                                                          index]
                                                                      ['id']
                                                                  .toString());
                                                          await prefs?.setString(
                                                              'titleChapter',
                                                              listReponse![
                                                                          index]
                                                                      [
                                                                      'chapterTitle']
                                                                  .toString());
                                                          print(
                                                              'ChapterID Click: ${listReponse![index]['id'].toString()}');
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute<
                                                                    dynamic>(
                                                                builder: (_) =>
                                                                    PdfViewPage()),
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.ads_click,
                                                          color: Colors
                                                              .yellow.shade200,
                                                        )),
                                                    IconButton(
                                                        onPressed: () async {
                                                          final SharedPreferences?
                                                              prefs =
                                                              await _prefs;
                                                          await prefs?.setString(
                                                              'idchapter',
                                                              listReponse![
                                                                          index]
                                                                      ['id']
                                                                  .toString());
                                                          await prefs?.setString(
                                                              'filePath',
                                                              listReponse![
                                                                          index]
                                                                      [
                                                                      'filePath']
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
                                                            Icons
                                                                .download_sharp,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      child: ListView(children: []),
                    ),
                  ]),
                ))
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
        centerTitle: true,
        title: Text(
          "BSOC App",
          style: TextStyle(fontWeight: FontWeight.bold),
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
    String? namesave;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idchapter = prefs.getString('idchapter');
    namesave = prefs.getString('filePath');
    print('Token ChapterID: $token');
    print('ChapterID: $idchapter');
    var url = Uri.parse(
        'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/chapter/download/$idchapter');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/pdf'
    });

    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$namesave");
    await prefs.setString('duongdan', "$file");
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
  bool notificationsEnabled = false;

  Map<String, dynamic> result = {
    'isSuccess': false,
    'filePath': null,
    'error': null,
  };
  double progress = 0.0;
  String? localPath;
  var _openResult = 'Unknown';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void startDownloading() async {
    Map<String, dynamic> result = {
      "isSuccess": false,
      "filePath": null,
      "error": null
    };
    Dio dio = Dio();
    String? token;
    String? idchapter;
    String? namesave;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idchapter = prefs.getString('idchapter');
    namesave = prefs.getString('filePath');
    print(namesave);

    String url =
        'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/chapter/download/$idchapter';

    dio.options.headers["Authorization"] = "Bearer $token";
    dio.get(url);

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory dir = await getApplicationDocumentsDirectory();
    print(dir);

    await dio.download(
      url,
      '${dir.path}/$namesave',
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });
        result['isSuccess'] = progress;
        result['filePath'] = dir.path;
        print(progress);
      },
      deleteOnError: true,
    ).then((_) {
      Navigator.pop(context);
    });
  }

  Future<void> openFile() async {
    final prefs = await SharedPreferences.getInstance();
    String? namesave = prefs.getString('filePath');
    const filePath =
        '/data/user/0/com.example.bsoc_book/app_flutter/ + namesave';
    final result = await OpenFilex.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    startDownloading();
  }

  Future showNotification(Map<String, dynamic> downloadStatus) async {
    final andorid = AndroidNotificationDetails("chapterId", 'BSOC Book',
        priority: Priority.high, importance: Importance.max);
    final ios = DarwinNotificationDetails();
    final notificationDetails = NotificationDetails(android: andorid, iOS: ios);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];
    await FlutterLocalNotificationsPlugin().show(
        0,
        isSuccess ? "Thành công" : "lỗi",
        isSuccess ? "Dữ liệu tải thành công" : "Dữ liệu bị lỗi",
        notificationDetails,
        payload: json);
  }

  final android = AndroidInitializationSettings('mipmap/ic_launcher');
  final ios = DarwinNotificationDetails();

  Future onselectedNotification(String json) async {
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      OpenFilex.open(obj['filePath']);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text(obj['error']),
              ));
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            critical: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted = await androidImplementation?.requestPermission();
      setState(() {
        notificationsEnabled = granted ?? false;
      });
    }
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
            "Tải về: $downloadingprogress%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class PdfViewPage extends StatefulWidget {
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  String? localPath;
  // String? titleChapter;

  void getTitleChap() async {
    final prefs = await SharedPreferences.getInstance();
    localPath = prefs.getString('duongdan');
  }

  @override
  void initState() {
    super.initState();

    // ApiServiceProvider.loadPDF().then((value) {
    //   setState(() {
    //     localPath = value;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "BSOC App",
          style: TextStyle(fontWeight: FontWeight.bold),
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
