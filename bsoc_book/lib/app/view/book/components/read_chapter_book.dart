import 'dart:async';
import 'dart:io';

import 'package:bsoc_book/app/models/book/chapters_model.dart';
import 'package:bsoc_book/app/view/book/components/item_chapter_list.dart';
import 'package:bsoc_book/app/view/user/home/home_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

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
  late List<ChaptersModel> _chapterModel;

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
    _chapterModel = _homeViewModel.bookDetailModel!.chapters;
    super.initState();
  }

  // void onSelectChapter(String newPdfPath) {
  //   setState(() {
  //     // Generate a new key to force the widget to rebuild
  //     pdfViewKey = GlobalKey();
  //     urlPDFPath = newPdfPath;
  //   });
  // }

  // void onSelectChapter() async {
  //   print('ID CHAPTER $idChapter');
  //   _homeViewModel.getChapterPdf(idChapter).then((value) => {
  //         if (value.isNotEmpty)
  //           {
  //             setState(() {
  //               pdfViewKey = GlobalKey();
  //               urlPDFPath = value;
  //               // Close the drawer
  //               Navigator.of(context).pop();
  //             })
  //           }
  //       });
  // }

  void goHome() {
    Application.router.navigateTo(context, Routes.app, clearStack: true);
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
            widget.parentViewState.jumpPageBookDetailPage();
          },
        ),
        actions: [
          Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(Icons.list_sharp));
          }),
        ],
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
      endDrawer: _buildChapterDrawer(),
    );
  }

  Widget _buildChapterDrawer() {
    return Drawer(
      child: Container(
        padding: EdgeInsets.zero,
        child: ItemChapterList(
          chapterItem: _chapterModel,
          homeViewModel: _homeViewModel,
          homeViewState: widget.parentViewState,
          // onSelectChapter: onSelectChapter,
          onSelectChapter: (String newPdfPath) {
            setState(() {
              pdfViewKey = GlobalKey();
              urlPDFPath = newPdfPath;
              print('URL PDF PATH $urlPDFPath');
              Navigator.of(context).pop();
            });
          },
        ),
      ),
    );
  }
}
