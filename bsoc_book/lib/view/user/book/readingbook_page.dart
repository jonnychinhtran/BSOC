import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map? viewBook;

class ReadeBook extends StatefulWidget {
  const ReadeBook({super.key});

  @override
  State<ReadeBook> createState() => _ReadeBookState();
}

class _ReadeBookState extends State<ReadeBook> {
  bool _isLoading = true;
  late PDFDocument document;
  late DownloadProgress downloadProgress;

  String idchapter = '';

  void _loadFileName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idchapter = prefs.getString('chapterId') ?? '';
      print('Namepdf: $idchapter');
    });
  }

  // loadDocument() async {
  //   document = await PDFDocument.fromURL(
  //       'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/chapter/download/$idchapter');
  //   print(document);
  //   setState(() => _isLoading = false);
  // }

  getDownloadBooks() async {
    String? token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    var url = Uri.parse(
        'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/chapter/download/$idchapter');
    http.Response response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      viewBook = jsonDecode(response.body);
      print('viewbook: $viewBook');
      setState(() {
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load Infor');
    }
  }

  void loadDocument() async {
    /// Clears the cache before download, so [PDFDocument.fromURLWithDownloadProgress.downloadProgress()]
    /// is always executed (meant only for testing).
    await DefaultCacheManager().emptyCache();
    String? namepdf;
    final prefs = await SharedPreferences.getInstance();
    namepdf = prefs.getString('filename');

    PDFDocument.fromURLWithDownloadProgress(
      'http://ec2-54-172-194-31.compute-1.amazonaws.com/$namepdf',
      downloadProgress: (downloadProgress) => setState(() {
        this.downloadProgress = downloadProgress;
      }),
      onDownloadComplete: (document) => setState(() {
        this.document = document;
        _isLoading = false;
      }),
    );
  }

  // Widget buildProgress() {
  //   if (downloadProgress == null) return SizedBox();

  //   String parseBytesToKBs(int bytes) {
  //     return '${(bytes / 1000).toStringAsFixed(2)} KBs';
  //   }

  //   String progressString = parseBytesToKBs(downloadProgress.downloaded);
  //   if (downloadProgress.totalSize != null) {
  //     progressString += '/ ${parseBytesToKBs(downloadProgress.totalSize)}';
  //   }

  //   return Column(
  //     children: [
  //       SizedBox(height: 20),
  //       Text(progressString),
  //     ],
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _loadFileName();
    loadDocument();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title Book'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              // _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    // buildProgress(),
                  ],
                ),
              )
            : PDFViewer(
                document: document,
              ),
      ),
    );
  }
}
