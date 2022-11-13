// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';

// Map? viewBook;

// class ReadeBook extends StatefulWidget {
//   const ReadeBook({super.key});

//   @override
//   State<ReadeBook> createState() => _ReadeBookState();
// }

// class _ReadeBookState extends State<ReadeBook> {
//   bool _isLoading = true;
//   late PDFDocument document;
//   late DownloadProgress downloadProgress;

  // String idchapter = '';

  // void _loadFileName() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     idchapter = prefs.getString('chapterId') ?? '';
  //     print('Namepdf: $idchapter');
  //   });
  // }

//   // loadDocument() async {
//   //   document = await PDFDocument.fromURL(
//   //       'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/chapter/download/$idchapter');
//   //   print(document);
//   //   setState(() => _isLoading = false);
//   // }

  // getDownloadBooks() async {
  //   String? token;
  //   final prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('accessToken');

  //   var url = Uri.parse(
  //       'http://ec2-54-172-194-31.compute-1.amazonaws.com/api/chapter/download/$idchapter');
  //   http.Response response =
  //       await http.get(url, headers: {'Authorization': 'Bearer $token'});

  //   if (response.statusCode == 200) {
  //     viewBook = jsonDecode(response.body);
  //     print('viewbook: $viewBook');
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load Infor');
  //   }
  // }

//   // void loadDocument() async {
//   //   /// Clears the cache before download, so [PDFDocument.fromURLWithDownloadProgress.downloadProgress()]
//   //   /// is always executed (meant only for testing).
//   //   await DefaultCacheManager().emptyCache();
//   //   String? namepdf;
//   //   final prefs = await SharedPreferences.getInstance();
//   //   namepdf = prefs.getString('filename');

//   //   PDFDocument.fromURLWithDownloadProgress(
//   //     'http://ec2-54-172-194-31.compute-1.amazonaws.com/$namepdf',
//   //     downloadProgress: (downloadProgress) => setState(() {
//   //       this.downloadProgress = downloadProgress;
//   //     }),
//   //     onDownloadComplete: (document) => setState(() {
//   //       this.document = document;
//   //       _isLoading = false;
//   //     }),
//   //   );
//   // }

//   // Widget buildProgress() {
//   //   if (downloadProgress == null) return SizedBox();

//   //   String parseBytesToKBs(int bytes) {
//   //     return '${(bytes / 1000).toStringAsFixed(2)} KBs';
//   //   }

//   //   String progressString = parseBytesToKBs(downloadProgress.downloaded);
//   //   if (downloadProgress.totalSize != null) {
//   //     progressString += '/ ${parseBytesToKBs(downloadProgress.totalSize)}';
//   //   }

//   //   return Column(
//   //     children: [
//   //       SizedBox(height: 20),
//   //       Text(progressString),
//   //     ],
//   //   );
//   // }

//   @override
//   void initState() {
//     super.initState();
//     _loadFileName();
//     // loadDocument();
//   }

//   @override
//   void setState(VoidCallback fn) {
//     if (mounted) {
//       super.setState(fn);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Title Book'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(
//               Icons.bookmark,
//               color: Colors.white,
//               semanticLabel: 'Bookmark',
//             ),
//             onPressed: () {
//               // _pdfViewerKey.currentState?.openBookmarkView();
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: _isLoading
//             ? Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: const [
//                     CircularProgressIndicator(),
//                     // buildProgress(),
//                   ],
//                 ),
//               )
//             : PDFViewer(
//                 document: document,
//               ),
//       ),
//     );
//   }
// }


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pspdfkit_flutter/pspdfkit.dart';

// // Filename of the PDF you'll download and save.
// const fileName = '/pspdfkit-flutter-quickstart-guide.pdf';

// // URL of the PDF file you'll download.
// const imageUrl = 'https://pspdfkit.com/downloads' + fileName;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Download and Display a PDF',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Download and Display a PDF'),
//     );
//   }
// }



// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   // Track the progress of a downloaded file here.
//   double progress = 0;

//   // Track if the PDF was downloaded here.
//   bool didDownloadPDF = false;

//   // Show the progress status to the user.
//   String progressString = 'File has not been downloaded yet.';

//   // This method uses Dio to download a file from the given URL
//   // and saves the file to the provided `savePath`.
//   Future download(Dio dio, String url, String savePath) async {
//     try {
//       Response response = await dio.get(
//         url,
//         onReceiveProgress: updateProgress,
//         options: Options(
//             responseType: ResponseType.bytes,
//             followRedirects: false,
//             validateStatus: (status) { return status! < 500; }
//             ),
//       );
//       var file = File(savePath).openSync(mode: FileMode.write);
//       file.writeFromSync(response.data);
//       await file.close();

// 	    // Here, you're catching an error and printing it. For production
// 	    // apps, you should display the warning to the user and give them a
// 	    // way to restart the download.
//     } catch (e) {
//       print(e);
//     }
//   }

//   // You can update the download progress here so that the user is
//   // aware of the long-running task.
//   void updateProgress(done, total) {
//     progress = done / total;
//     setState(() {
//       if (progress >= 1) {
//         progressString = '✅ File has finished downloading. Try opening the file.';
//         didDownloadPDF = true;
//       } else {
//         progressString = 'Download progress: ' + (progress * 100).toStringAsFixed(0) + '% done.';
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'First, download a PDF file. Then open it.',
//             ),
//             TextButton(
//               // Here, you download and store the PDF file in the temporary
//               // directory.
//               onPressed: didDownloadPDF ? null : () async {
//                   var tempDir = await getTemporaryDirectory();
//                   download(Dio(), imageUrl, tempDir.path + fileName);
//                 },
//               child: Text('Download a PDF file'),
//             ),
//             Text(
//               progressString,
//             ),
//             TextButton(
//               // Disable the button if no PDF is downloaded yet. Once the
//               // PDF file is downloaded, you can then open it using PSPDFKit.
//               onPressed: !didDownloadPDF ? null : () async {
//                   var tempDir = await getTemporaryDirectory();
//                   await Pspdfkit.present(tempDir.path + fileName);
//                 },
//               child: Text('Open the downloaded file using PSPDFKit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

