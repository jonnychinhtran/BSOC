import 'package:bsoc_book/app/models/book/chapters_model.dart';
import 'package:bsoc_book/app/view/home/home_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

class ItemChapterList extends StatefulWidget {
  const ItemChapterList({
    super.key,
    required this.chapterItem,
    required this.homeViewModel,
    required this.homeViewState,
    required this.onSelectChapter,
  });

  final List<ChaptersModel> chapterItem;
  final HomeViewModel homeViewModel;
  final HomeViewState homeViewState;
  final Function(String) onSelectChapter;

  @override
  State<ItemChapterList> createState() => _ItemChapterListState();
}

class _ItemChapterListState extends State<ItemChapterList> {
  late List<ChaptersModel> _chapterModel;
  late HomeViewModel _homeViewModel;
  String? itemsChapter;

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    _chapterModel = widget.chapterItem;
    print('CHAPTER ITEM ${widget.chapterItem}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: 200,
          height: double.infinity,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ListView.builder(
                itemCount: widget.chapterItem.length,
                itemBuilder: (context, index) {
                  if (widget.chapterItem.isNotEmpty) {
                    return GestureDetector(
                      onTap: () {
                        // widget.onSelectChapter(widget.chapterItem[index].id!);
                        _homeViewModel
                            .getChapterPdf(widget.chapterItem[index].id)
                            .then((value) => {
                                  if (value.isNotEmpty)
                                    widget.onSelectChapter(value)
                                });
                      },
                      child: Card(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        elevation: 10,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Chương ${_chapterModel[index].chapterId}: ${_chapterModel[index].chapterTitle}',
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ))),
    );
  }
}
