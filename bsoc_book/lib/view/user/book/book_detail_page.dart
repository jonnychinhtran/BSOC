import 'dart:async';
import 'dart:io';
import 'package:bsoc_book/controller/comment/comment_controller.dart';
import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/view/downloads/download_page.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
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
Map? dataBook;

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage>
    with TickerProviderStateMixin {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isLoading = true;
  String? token;
  String? idchap;
  String? idbooks;

  Future<void> getItemBooks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      idbooks = prefs.getString('idbook');
      var response = await Dio().get('http://103.77.166.202/api/book/$idbooks',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        dataBook = response.data;
        listReponse = dataBook!['chapters'];
        print('CHI TIET SACH: ${listReponse.toString()}');
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        Get.dialog(DialogLogout());
      }
      if (e.isNoConnectionError) {
        Get.dialog(DialogLogout());
      } else {
        Get.snackbar("error", e.toString());
        print(e);
        rethrow;
      }
    }
  }

  Future<void> addBookmark() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      idchap = prefs.getString('idchapter');
      var response = await Dio()
          .post(
              'http://103.77.166.202/api/chapter/add-bookmark?chapterId=$idchap',
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              }))
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        // Get.snackbar("Thông báo", "Thêm đánh dấu trang thành công.");
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
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
    // final provider = Provider.of<BookmarkProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        title: Text('Chi tiết sách'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('idbook');
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              Share.share('Đọc ngay: ' +
                  dataBook!['bookName'].toString() +
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
                        child: dataBook == null
                            ? Text('Đang tải dữ liệu')
                            : Image.network(
                                'http://103.77.166.202' + dataBook?['image'],
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
                          Text(dataBook?['bookName'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            dataBook?['author'],
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
                        Container(
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
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      final SharedPreferences? prefs =
                                          await _prefs;
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
                                                    listReponse![index]
                                                            ['chapterId']
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Colors.blue.shade900,
                                                  fontWeight: FontWeight.bold,
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
                                                          listReponse?[index]
                                                              ['chapterTitle'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                              onPressed:
                                                                  () async {
                                                                final SharedPreferences?
                                                                    prefs =
                                                                    await _prefs;
                                                                await prefs?.setString(
                                                                    'idchapter',
                                                                    listReponse![index]
                                                                            [
                                                                            'id']
                                                                        .toString());

                                                                print(
                                                                    'ChapterID Click: ${listReponse![index]['id'].toString()}');

                                                                addBookmark();
                                                                Get.snackbar(
                                                                    'Chương: ' +
                                                                        listReponse![index]['chapterTitle']
                                                                            .toString(),
                                                                    "Thêm đánh dấu trang thành công.");
                                                              },
                                                              icon: Icon(
                                                                Icons.bookmark,
                                                                color: Color
                                                                    .fromARGB(
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
                                                                    listReponse![index]
                                                                            [
                                                                            'id']
                                                                        .toString());
                                                                await prefs?.setString(
                                                                    'filePath',
                                                                    listReponse![index]
                                                                            [
                                                                            'filePath']
                                                                        .toString());
                                                                print(
                                                                    'ChapterID Click: ${listReponse![index]['id'].toString()}');

                                                                listReponse![index]
                                                                            [
                                                                            'downloaded'] ==
                                                                        true
                                                                    ? showDialog(
                                                                        context:
                                                                            context,
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
                                                                                  // Timer(Duration(seconds: 10), () => Navigator.of(context).pop());
                                                                                },
                                                                                child: const Text('Tải về'),
                                                                              ),
                                                                            ]),
                                                                      )
                                                                    : showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) =>
                                                                                const DownloadingDialog(),
                                                                      );
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                });
                                                              },
                                                              icon: listReponse![
                                                                              index]
                                                                          [
                                                                          'downloaded'] ==
                                                                      true
                                                                  ? Icon(
                                                                      Icons
                                                                          .download_sharp,
                                                                      color: Colors
                                                                          .blue)
                                                                  : Icon(
                                                                      Icons
                                                                          .download_sharp,
                                                                      color: Colors
                                                                          .blue))
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
                                  dataBook == null
                                      ? Text('Đang tải dữ liệu')
                                      : Text(
                                          dataBook?['description'],
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
  bool isLoading = true;
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
    print('API DOWNLOAD BOOK: $url');
    print('PARAM: ID BOOK $idchapter and TOKEN $token ');
    print(namesave);
    String filename = namesave.toString();
    String path = await _getFilePath(filename);
    await dio.download(
      url,
      path,
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
          print('PROGRESS DOWNLOAD: $progress');
        });
      },
      deleteOnError: true,
    ).then((_) {
      Navigator.pop(context);
    });
    await OpenFilex.open(path);
  }

  Future<String> _getFilePath(String filename) async {
    final dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return '${dir?.path}/$filename';
  }

  @override
  void initState() {
    super.initState();
    startDownloading();
  }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();
    print('PROGRESS DOWNLOAD: $downloadingprogress');
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

  bool isLoading = true;
  String? token;
  String? id;
  String? idchaps;
  List? bookmark;

  Future<void> getBookmarkDetail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      id = prefs.getString('idbook');
      setState(() {
        isLoading = true;
      });

      var response = await Dio()
          .get('http://103.77.166.202/api/chapter/list-bookmark?bookId=$id',
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              }));
      if (response.statusCode == 200) {
        bookmark = response.data;
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }

  Future<void> removeBookmark() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      idchaps = prefs.getString('idchapter');
      setState(() {
        isLoading = false;
      });
      var response = await Dio().delete(
          'http://103.77.166.202/api/chapter/delete-bookmark?chapterId=$idchaps',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        Get.snackbar("Thông báo", "Xoá đánh dấu trang thành công.");
        getBookmarkDetail();
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }

  @override
  void initState() {
    readBookmark();
    getBookmarkDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<BookmarkProvider>(context);
    // final chapter = provider.listReponse;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 175, 52),
          centerTitle: true,
          title: Text('Đánh dấu chương'),
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
            : ListView.builder(
                itemCount: bookmark == null ? null : bookmark!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      final SharedPreferences? prefs = await _prefs;
                      await prefs?.setString('idchapter',
                          bookmark![index]['chapter']['id'].toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (_) => PdfViewerPage()),
                      );
                    },
                    child: ListTile(
                      title: Text(bookmark![index] == null
                          ? 'Không có tên'
                          : 'Chương: ' +
                              bookmark![index]['chapter']['chapterId']
                                  .toString()),
                      subtitle: Text(bookmark![index] == null
                          ? 'Không có tên'
                          : bookmark![index]['chapter']['chapterTitle']
                              .toString()),
                      trailing: IconButton(
                          onPressed: () async {
                            final SharedPreferences? prefs = await _prefs;
                            await prefs?.setString('idchapter',
                                bookmark![index]['chapter']['id'].toString());
                            removeBookmark();
                            // Navigator.pop(context);
                          },
                          icon: Icon(Icons.bookmark_remove, color: Colors.red)),
                    ),
                  );
                }));
  }
}

class DialogLogout extends StatelessWidget {
  DialogLogout({super.key});
  final userdata = GetStorage();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thông báo'),
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Lỗi tải hệ thống, vui lòng đăng nhập lại'),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              primary: Colors.blueAccent,
              minimumSize: const Size.fromHeight(35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('accessToken');
              await prefs.clear();
              userdata.write('isLogged', false);
              Get.offAll(LoginPage());
            },
            child: Text('Đăng nhập lại'),
          ),
        ],
      )),
    );
  }
}
