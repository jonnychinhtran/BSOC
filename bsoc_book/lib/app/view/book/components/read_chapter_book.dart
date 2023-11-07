import 'dart:async';
import 'dart:io';

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
  // final Completer<PDFViewController> _controller =
  //     Completer<PDFViewController>();
  late HomeViewModel _homeViewModel;
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String urlPDFPath = "";
  late PDFViewController _pdfViewController;

  // Future<String> loadPDF() async {
  //   dynamic response = _homeViewModel.localPath;
  //   String fileName = response.split('/').last;
  //   var dir = await getApplicationDocumentsDirectory();
  //   File file = File("${dir.path}/$fileName");

  //   file.writeAsBytesSync(response.bodyBytes, flush: true);
  //   return file.path;
  // }

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    urlPDFPath = widget.homeViewModel.localPath;
    print('TRANG SACH ${widget.homeViewModel.localPath}');

    super.initState();
  }

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
      ),
      body: Column(
        children: [
          widget.homeViewModel.localPath != ''
              ? Expanded(
                  child: PDFView(
                    filePath: urlPDFPath,
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
                    // onViewCreated: (PDFViewController pdfViewController) {
                    //   _controller.complete(pdfViewController);
                    // },
                    onViewCreated: (PDFViewController vc) {
                      setState(() {
                        _pdfViewController = vc;
                      });
                    },
                    onPageChanged: (int? page, int? total) {
                      setState(() async {
                        currentPage = page;
                      });
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
