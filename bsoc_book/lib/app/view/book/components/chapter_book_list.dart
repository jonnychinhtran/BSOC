import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/chapters_model.dart';
import 'package:bsoc_book/app/view/home/home_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

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
                                widget.chapterModel[index].chapterId != 999
                                    ? Icon(
                                        Icons.bookmark_add_sharp,
                                        color: Color.fromARGB(255, 253, 135, 0),
                                      )
                                    : Container(),
                                widget.chapterModel[index].chapterId != 999
                                    ? Icon(Icons.download_outlined,
                                        color: Colors.blue)
                                    : Container()
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
