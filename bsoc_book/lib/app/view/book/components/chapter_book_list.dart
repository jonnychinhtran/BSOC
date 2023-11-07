import 'package:bsoc_book/app/models/book/chapters_model.dart';
import 'package:bsoc_book/app/view/user/home/home_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

class ChapterBookList extends StatefulWidget {
  const ChapterBookList({
    super.key,
    required this.chapterModel,
    required this.homeViewModel,
    required this.homeViewState,
  });

  final List<ChaptersModel> chapterModel;
  final HomeViewModel homeViewModel;
  final HomeViewState homeViewState;

  @override
  State<ChapterBookList> createState() => _ChapterBookListState();
}

class _ChapterBookListState extends State<ChapterBookList> {
  late HomeViewModel _homeViewModel;
  late List<ChaptersIdModel>? chapterId;
  String? itemsChapter;
  int? chapterid;

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: widget.chapterModel.length,
      itemBuilder: (context, index) {
        return GestureDetector(
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
                    Text(
                      'Chương: ${widget.chapterModel[index].id}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.remove_red_eye,
                      color: Colors.yellow.shade800,
                      size: 16,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.chapterModel[index].chapterTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 14)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.bookmark_add_sharp,
                            color: Color.fromARGB(255, 253, 135, 0),
                          ),
                          Icon(Icons.download_outlined, color: Colors.blue)
                        ],
                      ),
                    )
                  ],
                )
              ]),
            ),
          ),
        );
        // return ListTile(
        //   title: Text(widget.chapterModel[index].chapterTitle),
        //   subtitle: Text(widget.chapterModel[index].id.toString()),
        // );
      },
    );
  }
}

class ChaptersIdModel {
  int chapterId;

  ChaptersIdModel(this.chapterId);
}
