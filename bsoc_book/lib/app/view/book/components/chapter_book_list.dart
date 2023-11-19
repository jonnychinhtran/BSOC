import 'dart:io';

import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/chapters_model.dart';
import 'package:bsoc_book/app/view/home/home_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ChapterBookList extends StatefulWidget {
  const ChapterBookList({
    super.key,
    required this.bookModel,
    required this.chapterModel,
    required this.homeViewModel,
    required this.homeViewState,
  });

  final BookModel bookModel;
  final List<ChaptersModel> chapterModel;
  final HomeViewModel homeViewModel;
  final HomeViewState homeViewState;

  @override
  State<ChapterBookList> createState() => _ChapterBookListState();
}

class _ChapterBookListState extends State<ChapterBookList> {
  late HomeViewModel _homeViewModel;
  late BookModel _bookModel;
  late List<ChaptersIdModel>? chapterId;
  String? itemsChapter;
  int? chapterid;

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    _bookModel = widget.bookModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: widget.chapterModel.length,
      itemBuilder: (context, index) {
        bool shouldHide = false;
        if (widget.chapterModel[index].chapterId == 999) {
          if (_bookModel.payment == false) {
            shouldHide = false; // show hide the container
          }
          if (_bookModel.payment == true &&
              widget.chapterModel[index].allow == true) {
            shouldHide = true; // hide the container
          }
        } else if (widget.chapterModel[index].allow!) {
          shouldHide = false; // show the container
        } else {
          shouldHide = true; // hide the container
        }
        return shouldHide
            ? Container()
            : GestureDetector(
                onTap: () {
                  _homeViewModel
                      .getChapterPdf(widget.chapterModel[index].id)
                      .then((value) => {
                            if (value != '')
                              {
                                itemsChapter = value,
                                if (itemsChapter!.isNotEmpty)
                                  {widget.homeViewState.jumpReadBookPage()}
                              }
                          });
                },
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  elevation: 10,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: <Widget>[
                      Row(
                        children: [
                          widget.chapterModel[index].chapterId != 999
                              ? Text(
                                  'Chương: ' +
                                      widget.chapterModel[index].chapterId
                                          .toString() +
                                      ' ',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              : Text(
                                  'Thông báo',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          widget.chapterModel[index].chapterId != 999
                              ? Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.yellow.shade800,
                                  size: 16,
                                )
                              : Container(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: widget.chapterModel[index].chapterId != 999
                                ? Text(
                                    widget.chapterModel[index].chapterTitle,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                    ),
                                  )
                                : Container(),
                            // child: Text(widget.chapterModel[index].chapterTitle,
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 2,
                            //     style: const TextStyle(fontSize: 14)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Row(
                              children: [
                                if (widget.chapterModel[index].chapterId != 999)
                                  IconButton(
                                    icon: widget.chapterModel[index].bookmark ==
                                            true
                                        ? const Icon(Icons.bookmark_outlined,
                                            color: Color.fromARGB(
                                                255, 253, 135, 0))
                                        : const Icon(
                                            Icons.bookmark_border_outlined,
                                            color: Colors.blue),
                                    onPressed: () async {
                                      if (AppDataGlobal().accessToken != '') {
                                        var response = await Dio().post(
                                            'http://103.77.166.202/api/chapter/add-bookmark?chapterId=${widget.chapterModel[index].chapterId}',
                                            options: Options(headers: {
                                              'Content-Type':
                                                  'application/json',
                                              'Authorization':
                                                  'Bearer ${AppDataGlobal().accessToken}',
                                            }));
                                        if (response.statusCode == 200) {
                                          setState(() {});
                                        } else {}
                                      } else {
                                        WidgetHelper.showPopupMessage(
                                            context: context,
                                            content: const Text(
                                                'Bạn cần đăng nhập để sử dụng chức năng này'));
                                      }
                                    },
                                  ),
                                if (widget.chapterModel[index].chapterId != 999)
                                  IconButton(
                                    icon: widget.chapterModel[index]
                                                .downloaded ==
                                            true
                                        ? const Icon(
                                            Icons.download_done_outlined,
                                            color: Colors.blue)
                                        : const Icon(Icons.download_outlined,
                                            color: Colors.blue),
                                    onPressed: () {
                                      if (AppDataGlobal().accessToken != '') {
                                        if (widget.chapterModel[index]
                                                .downloaded ==
                                            true) {
                                          WidgetHelper.showPopupMessage(
                                              context: context,
                                              content: const Text(
                                                  'Bạn đã tải chương này rồi'));
                                        } else {
                                          showDialog(
                                            context: context,
                                            useRootNavigator: false,
                                            builder: (context) =>
                                                DownloadingDialog(
                                                    chapterId:
                                                        widget
                                                            .chapterModel[index]
                                                            .chapterId,
                                                    namePath: widget
                                                        .chapterModel[index]
                                                        .filePath),
                                          );
                                        }
                                      } else {
                                        WidgetHelper.showPopupMessage(
                                            context: context,
                                            content: const Text(
                                                'Bạn cần đăng nhập để sử dụng chức năng này'));
                                      }
                                    },
                                  ),
                              ],
                            ),
                          )
                        ],
                      )
                    ]),
                  ),
                ),
              );
      },
    );
  }
}

class ChaptersIdModel {
  int chapterId;

  ChaptersIdModel(this.chapterId);
}

class DownloadingDialog extends StatefulWidget {
  const DownloadingDialog({
    super.key,
    required this.chapterId,
    required this.namePath,
  });

  final int? chapterId;
  final String? namePath;

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  bool isLoading = true;
  double progress = 0.0;

  void startDownloading() async {
    Dio dio = Dio()
      ..options.connectTimeout = 15000 // 15 seconds timeout
      ..options.receiveTimeout = 30000 // 30 seconds receive timeout
      ..interceptors.add(LogInterceptor(responseBody: true)); // Add logging

    String url =
        'http://103.77.166.202/api/chapter/download/${widget.chapterId}';
    dio.options.headers["Authorization"] =
        "Bearer ${AppDataGlobal().accessToken}";

    String filename = widget.namePath.toString();

    try {
      String path = await _getFilePath(filename);

      await dio.download(
        url,
        path,
        onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            progress = receivedBytes / totalBytes;
          });
        },
        deleteOnError: true,
      ).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        print("Download error: $error");
        // Handle the error, maybe show a message to the user
      });

      await OpenFilex.open(path);
    } catch (e) {
      print("Error downloading file: $e");
    }

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
    startDownloading();

    super.initState();
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
