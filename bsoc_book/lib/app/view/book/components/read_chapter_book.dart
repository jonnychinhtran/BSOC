import 'dart:async';

import 'package:bsoc_book/app/view/user/home/home_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PDFView(
      // filePath: localPath,
      pageSnap: true,
      autoSpacing: true,
      enableSwipe: true,
      // defaultPage: currentPage!,
      fitPolicy: FitPolicy.BOTH,
      fitEachPage: true,
      onRender: (_pages) {
        setState(() {
          // pages = _pages;
          // isReady = true;
        });
      },
      onViewCreated: (PDFViewController pdfViewController) {
        _controller.complete(pdfViewController);
      },
      onPageChanged: (int? page, int? total) {
        setState(() async {
          // currentPage = page;
        });
      },
    );
  }
}
