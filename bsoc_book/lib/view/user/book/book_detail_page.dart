import 'dart:async';
import 'dart:io';
import 'package:bsoc_book/controller/comment/comment_controller.dart';
import 'package:bsoc_book/provider/bookmark_provider.dart';

import 'package:bsoc_book/view/downloads/download_page.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
List? listComment;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    final provider = Provider.of<BookmarkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        title: Text('Chi tiết sách'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.to(HomePage()),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              Share.share('Đọc ngay: ' +
                  mapDemo!['bookName'].toString() +
                  ' trên ứng dụng B4U BSOC '
                      '- Cài ứng dụng B4U BSOC tại AppStore: https://apps.apple.com/us/app/b4u-bsoc/id6444538062 ' +
                  ' - PlayStore: https://play.google.com/store/apps/details?id=com.b4usolution.b4u_bsoc');
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookmarkPage()),
                );
              },
              icon: Icon(Icons.bookmark_sharp)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadPage()),
                );
              },
              icon: Icon(Icons.download_for_offline))
        ],
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
                        text: "Chương sách",
                      ),
                      Tab(
                        text: "Giới thiệu",
                      ),
                      Tab(
                        text: "Đánh giá",
                      ),
                    ]),
                Expanded(
                    child: Container(
                  child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        isLoading
                            ? LoadingAnimationWidget.discreteCircle(
                                color: Colors.blue,
                                secondRingColor: Colors.black,
                                thirdRingColor: Colors.purple,
                                size: 50,
                              )
                            : Container(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 242, 254, 255),
                                  ),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: listReponse == null
                                          ? 0
                                          : listReponse!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            final SharedPreferences? prefs =
                                                await _prefs;
                                            await prefs?.setString(
                                                'idchapter',
                                                listReponse![index]['id']
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
                                              MaterialPageRoute<dynamic>(
                                                  builder: (_) =>
                                                      PdfViewerPage()),
                                            );
                                          },
                                          child: Card(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            elevation: 10,
                                            margin: EdgeInsets.all(10),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Chương: ' +
                                                          listReponse![index]
                                                                  ['chapterId']
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                listReponse?[
                                                                        index][
                                                                    'chapterTitle'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                softWrap: false,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade900,
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
                                                                    onPressed:
                                                                        () async {
                                                                      final SharedPreferences?
                                                                          prefs =
                                                                          await _prefs;
                                                                      await prefs?.setString(
                                                                          'idchapter',
                                                                          listReponse![index]['id']
                                                                              .toString());
                                                                      await prefs?.setString(
                                                                          'titleChapter',
                                                                          listReponse![index]['chapterTitle']
                                                                              .toString());
                                                                      print(
                                                                          'ChapterID Click: ${listReponse![index]['id'].toString()}');

                                                                      provider.toggleBookmark(listReponse![index]
                                                                              [
                                                                              'chapterTitle']
                                                                          .toString());
                                                                    },
                                                                    icon: provider.isExist(listReponse![index]['chapterTitle']
                                                                            .toString())
                                                                        ? Icon(
                                                                            Icons
                                                                                .bookmark,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                51,
                                                                                182,
                                                                                61))
                                                                        : Icon(
                                                                            Icons.bookmark_border,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                51,
                                                                                182,
                                                                                61),
                                                                          )),
                                                                IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      final SharedPreferences?
                                                                          prefs =
                                                                          await _prefs;
                                                                      await prefs?.setString(
                                                                          'idchapter',
                                                                          listReponse![index]['id']
                                                                              .toString());
                                                                      await prefs?.setString(
                                                                          'filePath',
                                                                          listReponse![index]['filePath']
                                                                              .toString());
                                                                      print(
                                                                          'ChapterID Click: ${listReponse![index]['id'].toString()}');
                                                                      listReponse![index]['downloaded'] ==
                                                                              true
                                                                          ? showDialog(
                                                                              context: context,
                                                                              builder: (context) => AlertDialog(
                                                                                  title: Text("Thông báo"),
                                                                                  content: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Text('Bạn đã tải chương sách, bạn có muốn tải lại không?')
                                                                                    ],
                                                                                  ),
                                                                                  actions: <Widget>[
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context, 'Thoát');
                                                                                      },
                                                                                      child: const Text('Thoát'),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        showDialog(
                                                                                          context: context,
                                                                                          useRootNavigator: false,
                                                                                          builder: (context) => const DownloadingDialog(),
                                                                                        );
                                                                                        Timer(Duration(seconds: 2), () => Navigator.of(context).pop());
                                                                                      },
                                                                                      child: const Text('Tải về'),
                                                                                    ),
                                                                                  ]),
                                                                            )
                                                                          : showDialog(
                                                                              context: context,
                                                                              builder: (context) => const DownloadingDialog(),
                                                                            );
                                                                    },
                                                                    icon: listReponse![index]['downloaded'] ==
                                                                            true
                                                                        ? Icon(
                                                                            Icons
                                                                                .download_sharp,
                                                                            color: Colors
                                                                                .blue)
                                                                        : Icon(
                                                                            Icons
                                                                                .download_outlined,
                                                                            color:
                                                                                Colors.blue))
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

class _PdfViewerPageState extends State<PdfViewerPage>
    with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  void readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentPage = prefs.getInt('keeppage') ?? 0;
  }

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String? localPath;
  String? titleChapter;

  void getTitleChap() async {
    final prefs = await SharedPreferences.getInstance();
    titleChapter = prefs.getString('accessToken');
  }

  @override
  void initState() {
    readData();
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
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         setState(() {
        //           isSaved = !isSaved;
        //           if (isSaved) {
        //             bookmarkAdded.add(widget.indexPage);
        //           }
        //         });
        //       },
        //       icon: Icon(
        //         isSaved ? Icons.bookmark : Icons.bookmark_border,
        //         size: 30,
        //       ))
        // ],
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath,
              pageSnap: true,
              autoSpacing: true,
              enableSwipe: true,
              defaultPage: currentPage!,
              fitPolicy: FitPolicy.BOTH,
              fitEachPage: true,
              onRender: (_pages) {
                setState(() {
                  pages = _pages;
                  isReady = true;
                });
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
                setState(() async {
                  currentPage = page;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt('keeppage', page!);
                  print('Trang hien tai: ${prefs.getInt('keeppage')}');
                });
              },
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
  bool isLoading = true;
  double progress = 0.0;
  String? localPath;
  var _openResult = '';

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
    Directory? dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    // Directory dir = await getApplicationDocumentsDirectory();
    print(dir);
    await prefs.setString('duongdan', "${dir?.path}/$namesave");

    await dio.download(
      url,
      '${dir?.path}/$namesave',
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });
      },
      deleteOnError: true,
    ).then((_) {
      Navigator.pop(context);
    });
    final result = await OpenFilex.open("${dir?.path}/$namesave");
    _openResult = "type=${result.type}  message=${result.message}";
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

class ReviewBook extends StatefulWidget {
  @override
  State<ReviewBook> createState() => _ReviewBookState();
}

class _ReviewBookState extends State<ReviewBook> {
  bool isLoading = true;

  Future<void> getComment() async {
    try {
      setState(() {
        isLoading = true;
      });
      String? token;
      String? idBook;
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      idBook = prefs.getString('idbook');
      print(idBook);
      setState(() {
        isLoading = true;
      });
      var url =
          Uri.parse('http://103.77.166.202/api/book/list-comment/$idBook');
      http.Response response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        listComment = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
        setState(() {
          isLoading = false;
        });
      } else {
        throw Exception('Lỗi tải hệ thống');
      }
      print("res: ${response.bodyBytes}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }

  @override
  void initState() {
    getComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: listComment == null ? 0 : listComment!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    'http://103.77.166.202' +
                                        listComment![index]['user']['avatar']
                                            .toString(),
                                  )),
                            )),
                            // Text(listComment![index]['content'].toString())
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listComment == null
                                        ? 'Đang tải dữ liệu'
                                        : listComment![index]['user']
                                                ['fullname']
                                            .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    listComment == null
                                        ? 'Đang tải dữ liệu'
                                        : listComment![index]['content']
                                            .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  RatingBars(
                                    rating: listComment![index]['rating']
                                        .toDouble(),
                                    ratingCount: 12,
                                  )
                                ],
                              ),
                            )),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    // margin: EdgeInsets.only(top: 30),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DialogComment(),
                    ),
                  )
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
  DialogComment({super.key});
  final _formKey = GlobalKey<FormState>();
  CommentController cmtcontroller = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ElevatedButton(
        child: Text(
          'CHIA SẺ ĐÁNH GIÁ',
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 2,
          primary: Colors.blueAccent,
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Đánh giá"),
                  content: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text("Số điểm: "),
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 40, maxHeight: 50),
                                child: IntrinsicWidth(
                                  child: Container(
                                    height: 30,
                                    child: TextFormField(
                                      controller:
                                          cmtcontroller.ratingController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        return (value == null || value.isEmpty)
                                            ? 'Nhập số'
                                            : null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[1-5]")),
                                      ],
                                      maxLength: 1,
                                      decoration: new InputDecoration(
                                        counterText: '',
                                        border: OutlineInputBorder(),
                                        errorStyle: TextStyle(height: 30),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text("  /  5 Sao"),
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
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.red)),
                            ),
                            controller: cmtcontroller.contentController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            validator: (value) {
                              return (value == null || value.isEmpty)
                                  ? 'Vui lòng nhập nội dung'
                                  : null;
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                        Navigator.pop(context, 'Huỷ');
                      },
                      child: const Text('Huỷ'),
                    ),
                    TextButton(
                        onPressed: () => {
                              if (_formKey.currentState!.validate())
                                {
                                  cmtcontroller.commentUserBook(),
                                  // Navigator.of(context).pop(),
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DetailBookPage()),
                                      (Route<dynamic> route) => false),
                                },
                            },
                        child: Text('Gửi'))
                  ],
                )),
      ),
    );
  }
}

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? chap;
  void readBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    chap = prefs.getString('saveBookmark') ?? "";
    print(chap);
  }

  @override
  void initState() {
    readBookmark();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookmarkProvider>(context);
    final chapter = provider.listReponse;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 175, 52),
          centerTitle: true,
          title: Text('Đánh dấu chương'),
        ),
        body: ListView.builder(
            itemCount: chapter.length,
            itemBuilder: (context, index) {
              chap = chapter[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(builder: (_) => PdfViewerPage()),
                  );
                },
                child: ListTile(
                  title: Text(chap!),
                  trailing: IconButton(
                      onPressed: () {
                        provider.toggleBookmark(chap!);
                      },
                      icon: provider.isExist(chap!)
                          ? Icon(Icons.bookmark,
                              color: Color.fromARGB(255, 51, 182, 61))
                          : Icon(Icons.bookmark_border,
                              color: Color.fromARGB(255, 51, 182, 61))),
                ),
              );
            }));
  }
}
