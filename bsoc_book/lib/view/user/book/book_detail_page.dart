import 'dart:async';
import 'dart:io';
import 'package:auto_reload/auto_reload.dart';
import 'package:bsoc_book/controller/comment/comment_controller.dart';
import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/view/downloads/download_page.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:bsoc_book/view/widgets/charge_book.dart';
import 'package:bsoc_book/view/widgets/coupon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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

enum RequestStatus {
  success,
  error,
}

enum RequestReview {
  success,
  error,
}

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key, required this.id});
  final String id;
  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage>
    with TickerProviderStateMixin {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ConnectivityResult connectivity = ConnectivityResult.none;
  bool isLoading = true;
  String? token;
  String? idchap;
  String? idbooks;

  Future<void> getItemBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idbooks = prefs.getString('idbook');
    try {
      var response = await Dio()
          .get('http://103.77.166.202/api/book/${widget.id}',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }))
          .timeout(Duration(seconds: 2));
      ;
      print(widget.id);
      if (response.statusCode == 200) {
        dataBook = response.data;
        listReponse = dataBook!['chapters'];
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {}
      if (e.isNoConnectionError) {
        // Get.dialog(DialogError());
      } else {
        // Get.snackbar("error", e.toString());
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
        setState(() {
          getItemBooks();
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      // Get.snackbar("error", e.toString());
      print(e);
    }
  }

  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DetailBookPage(id: idbooks!)),
          (Route<dynamic> route) => false);
    }
  }

  final _autoRequestManager = AutoRequestManager(minReloadDurationSeconds: 3);
  late List<RequestStatus> _requestStatuses;

  @override
  void initState() {
    getItemBooks();
    callback();

    _requestStatuses = List.generate(3, (idx) {
      _autoRequestManager.autoReload(
        id: idx.toString(),
        toReload: getItemBooks,
      );
      return RequestStatus.error;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return WillPopScope(
        onWillPop: () {
          callback();
          print(callback());
          isLoading = true;
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 138, 175, 52),
            title: Text('Chi tiết sách'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (() {
                // Get.to(HomePage());
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false);
              }),
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
                    print('id bookmark: ${dataBook!['id'].toString()}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BookmarkPage(id: dataBook!['id'].toString())),
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
          body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              if (connectivity == ConnectivityResult.none) {
                return Container(
                  color: Colors.white70,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.asset('assets/images/wifi.png'),
                          Text(
                            'Không có kết nối Internet',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Vui lòng kiểm tra kết nối internet và thử lại',
                            style: TextStyle(color: Colors.black),
                          ),
                          // TextButton(
                          //     onPressed: () {
                          //       Navigator.pushAndRemoveUntil(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   DetailBookPage(id: idbooks!)),
                          //           (Route<dynamic> route) => false);
                          //     },
                          //     child: Text('Thử lại'))
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return child;
              }
            },
            child: isLoading
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                    color: Color.fromARGB(255, 138, 175, 52),
                    secondRingColor: Colors.black,
                    thirdRingColor: Colors.purple,
                    size: 30,
                  ))
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
                              child: dataBook?['image'] == null
                                  ? Image.asset('assets/images/avatar.png',
                                      fit: BoxFit.fill)
                                  : Image.network(
                                      'http://103.77.166.202' +
                                          dataBook?['image'],
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      dataBook?['bookName'] == null
                                          ? "Đang tải..."
                                          : dataBook?['bookName'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      '(Mã sách: ' +
                                          dataBook!['id'].toString() +
                                          ')',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    dataBook?['author'] == null
                                        ? "Đang tải..."
                                        : dataBook?['author'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            final SharedPreferences? prefs =
                                                await _prefs;
                                            await prefs?.setInt('idchapter',
                                                listReponse![index]['id']);
                                            await prefs?.setInt(
                                                'sttchapter',
                                                listReponse![index]
                                                    ['chapterId']);
                                            await prefs?.setString(
                                                'titleChapter',
                                                listReponse![index]
                                                        ['chapterTitle']
                                                    .toString());
                                            await prefs?.setString(
                                                'filePathChapter',
                                                listReponse![index]['filePath']
                                                    .toString());
                                            print(
                                                'ChapterID Click: ${listReponse![index]['id'].toString()}');

                                            if (listReponse![index]['allow'] ==
                                                true) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute<dynamic>(
                                                    builder: (context) =>
                                                        PdfViewerPage(
                                                            idb: dataBook!['id']
                                                                .toString())),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CouponDialog(),
                                              );
                                            }
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
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Chương: ' +
                                                              listReponse![
                                                                          index]
                                                                      [
                                                                      'chapterId']
                                                                  .toString() +
                                                              ' ',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .blue.shade900,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Icon(
                                                          listReponse![index][
                                                                      'allow'] ==
                                                                  true
                                                              ? Icons
                                                                  .remove_red_eye
                                                              : Icons
                                                                  .lock_sharp,
                                                          color: Colors
                                                              .yellow.shade800,
                                                          size: 16,
                                                        ),
                                                      ],
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
                                                                listReponse![index]
                                                                            [
                                                                            'allow'] ==
                                                                        true
                                                                    ? IconButton(
                                                                        onPressed:
                                                                            () async {
                                                                          final SharedPreferences?
                                                                              prefs =
                                                                              await _prefs;
                                                                          await prefs?.setString(
                                                                              'idchapter',
                                                                              listReponse![index]['id'].toString());

                                                                          print(
                                                                              'ChapterID Click: ${listReponse![index]['id'].toString()}');

                                                                          addBookmark();
                                                                          Get.snackbar(
                                                                              'Chương: ' + listReponse![index]['chapterTitle'].toString(),
                                                                              "Thêm đánh dấu trang thành công.");
                                                                        },
                                                                        icon: listReponse![index]['bookmark'] ==
                                                                                true
                                                                            ? Icon(
                                                                                Icons.bookmark_added_sharp,
                                                                                color: Color.fromARGB(255, 253, 135, 0),
                                                                              )
                                                                            : Icon(
                                                                                Icons.bookmark_add_sharp,
                                                                                color: Color.fromARGB(255, 51, 182, 61),
                                                                              ))
                                                                    : IconButton(
                                                                        onPressed:
                                                                            () {},
                                                                        icon: Icon(
                                                                            Icons.lock_person_sharp)),
                                                                listReponse![index]
                                                                            [
                                                                            'allow'] ==
                                                                        true
                                                                    ? IconButton(
                                                                        onPressed:
                                                                            () async {
                                                                          final SharedPreferences?
                                                                              prefs =
                                                                              await _prefs;
                                                                          await prefs?.setString(
                                                                              'idchapter',
                                                                              listReponse![index]['id'].toString());
                                                                          await prefs?.setString(
                                                                              'filePath',
                                                                              listReponse![index]['filePath'].toString());
                                                                          print(
                                                                              'ChapterID Click: ${listReponse![index]['id'].toString()}');

                                                                          listReponse![index]['downloaded'] == true
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
                                                                                            // Timer(Duration(seconds: 10), () => Navigator.of(context).pop());
                                                                                          },
                                                                                          child: const Text('Tải về'),
                                                                                        ),
                                                                                      ]),
                                                                                )
                                                                              : showDialog(
                                                                                  context: context,
                                                                                  builder: (context) => const DownloadingDialog(),
                                                                                );
                                                                          setState(
                                                                              () {
                                                                            getItemBooks();
                                                                            isLoading =
                                                                                false;
                                                                          });
                                                                          isLoading =
                                                                              true;
                                                                        },
                                                                        icon: listReponse![index]['downloaded'] ==
                                                                                true
                                                                            ? Icon(Icons.download_sharp,
                                                                                color: Colors
                                                                                    .blue)
                                                                            : Icon(Icons.download_outlined,
                                                                                color: Colors
                                                                                    .blue))
                                                                    : IconButton(
                                                                        onPressed:
                                                                            () {},
                                                                        icon: Icon(
                                                                            Icons.lock_person_sharp))
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
                              ReviewBook(id: dataBook!['id'].toString()),
                            ]),
                      ))
                    ],
                  ),
          ),
        ));
  }
}

class PdfViewerPage extends StatefulWidget {
  PdfViewerPage({super.key, required this.idb});
  final String idb;
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

  bool isLoading = true;

  String? token;
  int? idchap;
  int? sttchap;
  String? idbooks;
  String? filename;

  Future<void> getItemBooks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      idbooks = prefs.getString('idbook');
      idchap = prefs.getInt('idchapter') ?? 0;
      sttchap = prefs.getInt('sttchapter') ?? 0;
      titleChapter = prefs.getString('titleChapter');
      var response =
          await Dio().get('http://103.77.166.202/api/book/${widget.idb}',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }));
      if (response.statusCode == 200) {
        dataBook = response.data;
        listReponse = dataBook!['chapters'];

        // print('CHI TIET SACH: ${listReponse.toString()}');
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      // print("res: ${response.data}");
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        Get.dialog(DialogLogout());
      }
      if (e.isNoConnectionError) {
        Get.snackbar('Opps', 'Mất kết nối mạng, vui lòng thử lại');
      } else {
        Get.snackbar("error", e.toString());
        print(e);
        rethrow;
      }
    }
  }

  Future<String> loadPDF() async {
    String? token;

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idchap = prefs.getInt('idchapter') ?? 0;
    filename = prefs.getString('filePathChapter');

    var url = Uri.parse('http://103.77.166.202/api/chapter/download/$idchap');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/pdf'
    });

    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");

    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }

  void getTitleChap() async {
    final prefs = await SharedPreferences.getInstance();
    titleChapter = prefs.getString('accessToken');
  }

  @override
  void initState() {
    readData();
    getItemBooks();
    loadPDF();
    super.initState();

    loadPDF().then((value) {
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
          'Chương ' + sttchap.toString() + ': ' + titleChapter.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('idchapter');
            await prefs.remove('sttchapter');
            await prefs.remove('chapterTitle');
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => DetailBookPage(id: idbooks!),
              ),
              (route) =>
                  false, //if you want to disable back feature set to false
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          localPath != null
              ? Expanded(
                  child: Container(
                      child: PageView(
                    children: [
                      PDFView(
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
                            print(
                                'Trang hien tai: ${prefs.getInt('keeppage')}');
                          });
                        },
                      ),
                    ],
                  )),
                )
              : LoadingAnimationWidget.discreteCircle(
                  color: Color.fromARGB(255, 138, 175, 52),
                  secondRingColor: Colors.black,
                  thirdRingColor: Colors.purple,
                  size: 30,
                ),
          Container(
            height: .10 * MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        setState(() {
                          if (sttchap!.bitLength != 1) {
                            int.parse(idchap.toString()) - 1;

                            prefs.setInt(
                                'idchapter', int.parse(idchap.toString()) - 1);
                            prefs.setInt('sttchapter',
                                int.parse(sttchap.toString()) - 1);
                            prefs.setString(
                                'titleChapter',
                                listReponse![int.parse(sttchap!.toString()) - 2]
                                        ['chapterTitle']
                                    .toString());
                            print(
                                listReponse![int.parse(sttchap!.toString()) - 2]
                                        ['chapterTitle']
                                    .toString());
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => PdfViewerPage(
                                        idb: dataBook!['id'].toString())));
                          }
                        });
                      },
                      child: Icon(Icons.arrow_back_ios),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5);
                            else if (states.contains(MaterialState.disabled))
                              return Color.fromARGB(255, 138, 175, 52);
                            return Color.fromARGB(255, 138, 175,
                                52); // Use the component's default.
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: listReponse!.length,
                      itemBuilder: (context, index) {
                        // if (listReponse!.last != true)
                        //   return Text(listReponse!.last);
                        // return SizedBox();
                        return Container(
                          margin: EdgeInsets.only(right: 5, left: 5),
                          child: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                prefs.setInt(
                                    'idchapter', listReponse![index]['id']);
                                prefs.setInt('sttchapter',
                                    listReponse![index]['chapterId']);
                                prefs.setString(
                                    'titleChapter',
                                    listReponse![index]['chapterTitle']
                                        .toString());
                                listReponse![index]['allow'] == true
                                    ? Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => PdfViewerPage(
                                                idb: dataBook!['id']
                                                    .toString())))
                                    : showDialog(
                                        context: context,
                                        builder: (context) => ChargeDialog(),
                                      );
                              });
                            },
                            child: Text(
                              listReponse![index]['chapterId'].toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5);
                                  else if (states
                                      .contains(MaterialState.disabled))
                                    return Colors.black;
                                  return Color.fromARGB(255, 138, 175, 52);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )),
                  SizedBox(
                    height: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          int.parse(idchap.toString()) + 1;

                          prefs.setInt(
                              'idchapter', int.parse(idchap.toString()) + 1);
                          prefs.setInt(
                              'sttchapter', int.parse(sttchap.toString()) + 1);
                          prefs.setString(
                              'titleChapter',
                              listReponse![sttchap!]['chapterTitle']
                                  .toString());
                          if (listReponse![sttchap!]['allow'] == true) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PdfViewerPage(
                                    idb: dataBook!['id'].toString())));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => ChargeDialog(),
                            );
                          }
                        });
                      },
                      child: Icon(Icons.arrow_forward_ios),
                      // child: Text('Tiếp'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5);
                            else if (states.contains(MaterialState.disabled))
                              return Color.fromARGB(255, 138, 175, 52);
                            return Color.fromARGB(255, 138, 175, 52);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
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
  String? idbooks;

  void startDownloading() async {
    Dio dio = Dio();
    String? token;
    String? idchapter;
    String? namesave;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idchapter = prefs.getString('idchapter');
    namesave = prefs.getString('filePath');
    idbooks = prefs.getString('idbook');

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
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailBookPage(id: idbooks!)));
    await OpenFilex.open(path);
    setState(() {
      isLoading = false;
    });
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
  ReviewBook({super.key, required this.id});
  final String id;
  @override
  State<ReviewBook> createState() => _ReviewBookState();
}

class _ReviewBookState extends State<ReviewBook> {
  final _autoRequestManager = AutoRequestManager(minReloadDurationSeconds: 1);
  bool isLoading = true;
  String? token;
  late List<RequestReview> _requestReview;

  Future<void> getComment() async {
    try {
      setState(() {
        isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');

      setState(() {
        isLoading = true;
      });
      var url =
          Uri.parse('http://103.77.166.202/api/book/list-comment/${widget.id}');
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

  ConnectivityResult connectivity = ConnectivityResult.none;

  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ReviewBook(id: widget.id)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    getComment();
    callback();

    _requestReview = List.generate(1, (idx) {
      _autoRequestManager.autoReload(
        id: idx.toString(),
        toReload: getComment,
      );
      return RequestReview.error;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading &&
              callback == ConnectivityResult.none &&
              listComment == null
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
              color: Color.fromARGB(255, 138, 175, 52),
              secondRingColor: Colors.black,
              thirdRingColor: Colors.purple,
              size: 30,
            ))
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
                                    // overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  RatingBars(
                                    rating:
                                        listComment![index]['rating'] == null
                                            ? 0
                                            : listComment![index]['rating']
                                                .toDouble(),
                                    // ratingCount: 5,
                                  )
                                ],
                              ),
                            )),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DialogComment(id: widget.id),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class RatingBars extends StatelessWidget {
  double rating;
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

class DialogComment extends StatefulWidget {
  // DialogComment({super.key});
  DialogComment({super.key, required this.id});
  final String id;
  @override
  State<DialogComment> createState() => _DialogCommentState();
}

class _DialogCommentState extends State<DialogComment> {
  final _formKey = GlobalKey<FormState>();

  CommentController cmtcontroller = Get.put(CommentController());
  String? idbooks;
  String? token;

  getIdbook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idbooks = prefs.getString('idbook');
    token = prefs.getString('accessToken');
  }

  late final _ratingController;
  late double _rating;
  double _initialRating = 5;
  bool _isVertical = false;

  @override
  void initState() {
    getIdbook();
    _rating = _initialRating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
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
                  title: Text("Đánh giá & Nhận xét"),
                  content: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints(minWidth: 40, maxHeight: 50),
                                child: IntrinsicWidth(
                                  child: Container(
                                      height: 30,
                                      child: RatingBar.builder(
                                        initialRating: _initialRating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        unratedColor:
                                            Colors.amber.withAlpha(50),
                                        itemCount: 5,
                                        itemSize: 35.5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            _rating = rating;

                                            print('SAO: $_rating');
                                          });
                                        },
                                        updateOnDrag: true,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
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
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setDouble('rating', _rating);
                          if (_formKey.currentState!.validate()) {
                            cmtcontroller.commentUserBook();
                            setState(() {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailBookPage(id: widget.id)),
                                  (Route<dynamic> route) => false);
                            });
                          }
                        },
                        child: Text('Gửi'))
                  ],
                )),
      ),
    );
  }
}

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key, required this.id});
  final String id;

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ConnectivityResult connectivity = ConnectivityResult.none;
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
      // id = prefs.getString('idbook');
      setState(() {
        isLoading = true;
      });

      var response = await Dio().get(
          'http://103.77.166.202/api/chapter/list-bookmark?bookId=${widget.id}',
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
      // Get.snackbar("error", e.toString());
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

  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BookmarkPage(id: widget.id)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    readBookmark();
    getBookmarkDetail();
    callback();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 175, 52),
          centerTitle: true,
          title: Text('Đánh dấu chương'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              if (connectivity == ConnectivityResult.none) {
                return Container(
                  color: Colors.white70,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.asset('assets/images/wifi.png'),
                          Text(
                            'Không có kết nối Internet',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Vui lòng kiểm tra kết nối internet và thử lại',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return child;
              }
            },
            child: callback == ConnectivityResult.none
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                    color: Color.fromARGB(255, 138, 175, 52),
                    secondRingColor: Colors.black,
                    thirdRingColor: Colors.purple,
                    size: 30,
                  ))
                : ListView.builder(
                    itemCount: bookmark == null ? null : bookmark!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final SharedPreferences? prefs = await _prefs;
                          await prefs?.setInt(
                              'idchapter',
                              int.parse(bookmark![index]['chapter']['id']
                                  .toString()));
                          await prefs?.setInt('sttchapter',
                              bookmark![index]['chapter']['chapterId']);
                          await prefs?.setString(
                              'titleChapter',
                              bookmark![index]['chapter']['chapterTitle']
                                  .toString());
                          await prefs?.setString(
                              'filePathChapter',
                              bookmark![index]['chapter']['filePath']
                                  .toString());
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PdfViewerPage(idb: id!)));
                        },
                        child: ListTile(
                          title: Text(bookmark?[index].toString() == null
                              ? 'Không có tên'
                              : 'Chương: ' +
                                  bookmark![index]['chapter']['chapterId']
                                      .toString()),
                          subtitle: Text(bookmark?[index].toString() == null
                              ? 'Không có tên'
                              : bookmark![index]['chapter']['chapterTitle']
                                  .toString()),
                          trailing: IconButton(
                              onPressed: () async {
                                final SharedPreferences? prefs = await _prefs;
                                await prefs?.setString(
                                    'idchapter',
                                    bookmark![index]['chapter']['id']
                                        .toString());
                                removeBookmark();
                                // Navigator.pop(context);
                              },
                              icon: Icon(Icons.bookmark_remove,
                                  color: Colors.red)),
                        ),
                      );
                    })));
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

class DialogError extends StatelessWidget {
  DialogError({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thông báo'),
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Mất kết nối mạng internet/4G, vui lòng thử lại'),
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
            onPressed: () {
              Get.off(() => const HomePage());
            },
            child: Text('Trở về trang chủ'),
          ),
        ],
      )),
    );
  }
}
