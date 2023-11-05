import 'package:bsoc_book/app/models/book/chapters_model.dart';
import 'package:flutter/material.dart';

class ChapterBookList extends StatefulWidget {
  const ChapterBookList({
    super.key,
    required this.chapterModel,
  });

  final List<ChaptersModel> chapterModel;

  @override
  State<ChapterBookList> createState() => _ChapterBookListState();
}

class _ChapterBookListState extends State<ChapterBookList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: widget.chapterModel.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: Card(
            color: Color.fromARGB(255, 255, 255, 255),
            elevation: 10,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Chương: ' + widget.chapterModel[index].id.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                          style: TextStyle(fontSize: 14)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
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
