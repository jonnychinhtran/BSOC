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

    var url = Uri.parse('http://103.77.166.202/api/book/$id');
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
      throw Exception('Lỗi tải hệ thống');
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
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: Text('Chi tiết'),
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
                            ? Text('Đang tải dữ liệu')
                            : Image.network(
                                'http://103.77.166.202' + mapDemo?['image'],
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
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 242, 254, 255),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView(
                            children: [
                              mapDemo == null
                                  ? Text('Đang tải dữ liệu')
                                  : Text(
                                      mapDemo?['description'],
                                      softWrap: true,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          fontSize: 17, height: 1.5),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 242, 254, 255),
                        ),
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
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  elevation: 10,
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
                                              color: Colors.blue.shade900,
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
                                                      style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900,
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
                                                                      PdfViewerPage()),
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.ads_click,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    51,
                                                                    182,
                                                                    61),
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
                                                                  Colors.black))
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
                    ),
                    ReviewBook(),
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
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: Text(
          "B4U BSOC",
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

    var url =
        Uri.parse('http://103.77.166.202/api/chapter/download/$idchapter');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/pdf'
    });

    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$namesave");

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

  double progress = 0.0;
  String? localPath;

  void startDownloading() async {
    Dio dio = Dio();
    String? token;
    String? idchapter;
    String? namesave;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idchapter = prefs.getString('idchapter');
    namesave = prefs.getString('filePath');

    String url = 'http://103.77.166.202/api/chapter/download/$idchapter';

    dio.options.headers["Authorization"] = "Bearer $token";
    dio.get(url);

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory dir = await getApplicationDocumentsDirectory();
    print(dir);
    await prefs.setString('duongdan', "${dir.path}/$namesave");
    await dio.download(
      url,
      '${dir.path}/$namesave',
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });
      },
      deleteOnError: true,
    ).then((_) {
      Navigator.pop(context);
    });
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

class ReviewBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 242, 254, 255),
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            'https://avatars.githubusercontent.com/u/104020709?s=96&v=4',
                          )),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ngọc Tài',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Quyển kỷ yếu rất hay về chiến lược Marketing',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RatingBars(
                            rating: 3.5,
                            ratingCount: 12,
                          )
                        ],
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: DialogComment(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RatingBars extends StatelessWidget {
  final double rating;
  final double size;
  int? ratingCount;

  RatingBars({required this.rating, this.ratingCount, this.size = 18});

  @override
  Widget build(BuildContext context) {
    List<Widget> _startList = [];
    int realNumber = rating.floor();
    int partNumber = ((rating - realNumber) * 10).ceil();

    for (int i = 0; i < 5; i++) {
      if (i < realNumber) {
        _startList.add(Icon(
          Icons.star,
          color: Colors.yellow,
          size: size,
        ));
      } else if (i == realNumber) {
        _startList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: size,
              ),
              ClipRect(
                clipper: _Clipper(part: partNumber),
                child: Icon(
                  Icons.star,
                  color: Colors.grey,
                  size: size,
                ),
              ),
            ],
          ),
        ));
      } else {
        _startList.add(Icon(
          Icons.star,
          color: Colors.grey,
          size: size,
        ));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _startList,
    );
  }
}

class _Clipper extends CustomClipper<Rect> {
  final int part;
  _Clipper({required this.part});
  Rect getClip(Size size) {
    return Rect.fromLTRB(
        (size.width / 10) * part, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}

class DialogComment extends StatelessWidget {
  const DialogComment({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('CHIA SẺ ĐÁNH GIÁ'),
      style: ElevatedButton.styleFrom(
          elevation: 5,
          primary: Colors.grey.shade600,
          padding: EdgeInsets.all(20)),
      onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Đánh giá"),
                content: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text("Rating: "),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: 40, minHeight: 10),
                            child: IntrinsicWidth(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                // decoration: InputDecoration(
                                //   focusedBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           width: 1, color: Colors.black)),
                                //   enabledBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           width: 1, color: Colors.black)),
                                // ),
                              ),
                            ),
                          ),
                          Text("/5 Sao"),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Nội dung:"),
                      SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black)),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Huỷ'),
                    child: const Text('Huỷ'),
                  ),
                  TextButton(
                      onPressed: () => Navigator.pop(context, 'Gửi'),
                      child: Text('Gửi'))
                ],
              )),
    );
  }
}
