import 'package:bsoc_book/app/view/home/home_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({
    super.key,
    required this.bookId,
    required this.homeViewModel,
    required this.parentViewState,
  });

  final int bookId;
  final HomeViewModel homeViewModel;
  final HomeViewState parentViewState;

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late HomeViewModel _homeViewModel;
  String? chap;
  String? itemsChapter;
  bool isLoading = true;
  String? token;
  String? id;
  int? _idchaps;
  List? bookmark;

  Future<void> getBookmarkDetail() async {
    try {
      setState(() {
        isLoading = true;
      });

      var response = await Dio().get(
          'http://103.77.166.202/api/chapter/list-bookmark?bookId=${widget.bookId}',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AppDataGlobal().accessToken}',
          }));
      if (response.statusCode == 200) {
        bookmark = response.data;
        setState(() {
          isLoading = false;
        });
      } else {}
      print("res: ${response.data}");
    } catch (e) {
      // Get.snackbar("error", e.toString());
      print(e);
    }
  }

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    getBookmarkDetail();
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
        body: Stack(
          children: [
            ListView.builder(
                itemCount: bookmark == null ? null : bookmark!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      _homeViewModel
                          .getChapterPdf(bookmark?[index]['chapter']['id'])
                          .then((value) => {
                                if (value != '')
                                  {
                                    itemsChapter = value,
                                    if (itemsChapter!.isNotEmpty)
                                      {
                                        setState(() {
                                          isLoading = false;
                                        }),
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReadChapterBook(
                                                      homeViewModel:
                                                          _homeViewModel,
                                                      parentViewState: widget
                                                          .parentViewState,
                                                    )))
                                      }
                                  }
                              });
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
                            try {
                              setState(() {
                                isLoading = false;
                              });
                              var response = await Dio().delete(
                                  'http://103.77.166.202/api/chapter/delete-bookmark?chapterId=${bookmark?[index]['chapter']['id']}',
                                  options: Options(headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization':
                                        'Bearer ${AppDataGlobal().accessToken}',
                                  }));
                              if (response.statusCode == 200) {
                                getBookmarkDetail();
                              } else {}
                              print("res: ${response.data}");
                            } catch (e) {
                              print(e);
                            }
                          },
                          icon: Icon(Icons.bookmark_remove, color: Colors.red)),
                    ),
                  );
                }),
            (isLoading == true)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: LoadingAnimationWidget.discreteCircle(
                        color: Color.fromARGB(255, 138, 175, 52),
                        secondRingColor: Colors.black,
                        thirdRingColor: Colors.purple,
                        size: 30,
                      )),
                      Text('Đang tải dữ liệu...',
                          style: TextStyle(fontSize: 20)),
                    ],
                  )
                : Container()
          ],
        )
        // )
        );
  }
}

class ReadChapterBook extends StatefulWidget {
  const ReadChapterBook({
    super.key,
    required this.homeViewModel,
    required this.parentViewState,
  });
  final HomeViewModel homeViewModel;
  final HomeViewState parentViewState;
  @override
  State<ReadChapterBook> createState() => _ReadChapterBookState();
}

class _ReadChapterBookState extends State<ReadChapterBook>
    with WidgetsBindingObserver {
  GlobalKey pdfViewKey = GlobalKey();
  late HomeViewModel _homeViewModel;
  String newPdfPath = "";
  int _totalPages = 0;
  int _currentPage = 0;
  bool isReady = false;
  String urlPDFPath = "";
  late PDFViewController _pdfViewController;
  bool isChapterContainerOpen = false;

  void toggleChapterContainer() {
    setState(() {
      isChapterContainerOpen = !isChapterContainerOpen;
    });
  }

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    urlPDFPath = widget.homeViewModel.localPath;
    print('TRANG SACH ${widget.homeViewModel.localPath}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: const Text('Đọc sách'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            urlPDFPath = '';
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          widget.homeViewModel.localPath != ''
              ? Expanded(
                  child: PDFView(
                    filePath: urlPDFPath,
                    key: pdfViewKey,
                    pageSnap: true,
                    autoSpacing: true,
                    enableSwipe: true,
                    defaultPage: _currentPage,
                    fitPolicy: FitPolicy.BOTH,
                    fitEachPage: true,
                    onRender: (_pages) {
                      setState(() {
                        _totalPages = _pages!;
                        isReady = true;
                      });
                    },
                    onViewCreated: (PDFViewController vc) {
                      setState(() {
                        _pdfViewController = vc;
                      });
                    },
                    onPageChanged: (int? page, int? total) {
                      setState(() async {
                        _currentPage = page!;
                      });
                    },
                  ),
                )
              : Container()
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_left),
            iconSize: 50,
            color: Colors.black,
            onPressed: () {
              setState(() {
                if (_currentPage > 0) {
                  _currentPage--;
                  _pdfViewController.setPage(_currentPage);
                }
              });
            },
          ),
          Text(
            "${_currentPage + 1}/$_totalPages",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: 50,
            color: Colors.black,
            onPressed: () {
              setState(() {
                if (_currentPage < _totalPages - 1) {
                  _currentPage++;
                  _pdfViewController.setPage(_currentPage);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
