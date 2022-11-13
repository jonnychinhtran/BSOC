import 'dart:async';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter/material.dart';
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

  // void _getIdChapter() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     ipchapter = prefs.getString('idchapter') ?? '';
  //     print('ipchater: $ipchapter');
  //   });
  // }

  void getDownloadBooks() async {
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

    if (response.statusCode == 200) {
      datapdf = response.body;
      print('DATA Chapter: $datapdf');
      isLoading = false;
    } else {
      throw Exception('Failed to load Infor');
    }
  }

  @override
  void initState() {
    getItemBooks();
    getDownloadBooks();
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
                          return Card(
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
                                                      listReponse![index]['id']
                                                          .toString());

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (_) =>
                                                          // PDFViewer(
                                                          //   document: datapdf,
                                                          // )
                                                          PDFViewerFromAsset(
                                                              pdfAssetPath: datapdf
                                                                  .toString()),
                                                      // url: 'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/chapter/download/' +
                                                      //     listReponse![index]
                                                      //             ['id']
                                                      //         .toString(),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.import_contacts_sharp,
                                                  color: Colors.yellow.shade200,
                                                )),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.download_sharp,
                                                    color:
                                                        Colors.green.shade100))
                                          ],
                                        ),
                                      ])),
                            ]),
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

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF From Url'),
      ),
      body: const PDF().fromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class PDFViewerCachedFromUrl extends StatelessWidget {
  const PDFViewerCachedFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BSOC App'),
      ),
      body: const PDF().cachedFromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class PDFViewerFromAsset extends StatelessWidget {
  PDFViewerFromAsset({Key? key, required this.pdfAssetPath}) : super(key: key);
  final String pdfAssetPath;
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();
  final StreamController<String> _pageCountController =
      StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF From Asset'),
        actions: <Widget>[
          StreamBuilder<String>(
              stream: _pageCountController.stream,
              builder: (_, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[900],
                      ),
                      child: Text(snapshot.data!),
                    ),
                  );
                }
                return const SizedBox();
              }),
        ],
      ),
      body: PDF(
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onPageChanged: (int? current, int? total) =>
            _pageCountController.add('${current! + 1} - $total'),
        onViewCreated: (PDFViewController pdfViewController) async {
          _pdfViewController.complete(pdfViewController);
          final int currentPage = await pdfViewController.getCurrentPage() ?? 0;
          final int? pageCount = await pdfViewController.getPageCount();
          _pageCountController.add('${currentPage + 1} - $pageCount');
        },
      ).fromAsset(
        pdfAssetPath,
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _pdfViewController.future,
        builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: '-',
                  child: const Text('-'),
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data!;
                    final int currentPage =
                        (await pdfController.getCurrentPage())! - 1;
                    if (currentPage >= 0) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                ),
                FloatingActionButton(
                  heroTag: '+',
                  child: const Text('+'),
                  onPressed: () async {
                    final PDFViewController pdfController = snapshot.data!;
                    final int currentPage =
                        (await pdfController.getCurrentPage())! + 1;
                    final int numberOfPages =
                        await pdfController.getPageCount() ?? 0;
                    if (numberOfPages > currentPage) {
                      await pdfController.setPage(currentPage);
                    }
                  },
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
