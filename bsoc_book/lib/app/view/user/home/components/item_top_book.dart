import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/top_book_model.dart';
import 'package:bsoc_book/app/view/user/home/components/item_list_top_book.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:flutter/material.dart';

class ItemTopBook extends StatefulWidget {
  const ItemTopBook(
      {super.key, required this.topBookModel, required this.onTapNextPage});

  final List<BookModel> topBookModel;
  final Function onTapNextPage;
  @override
  State<ItemTopBook> createState() => _ItemTopBookState();
}

class _ItemTopBookState extends State<ItemTopBook> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: ListView.builder(
          // physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.topBookModel.length,
          itemBuilder: (context, index) {
            return ItemListTopBook(
                bookModel: widget.topBookModel[index],
                onPressedNextPage: () {
                  widget.onTapNextPage(widget.topBookModel[index]);
                });
          }),
    );
  }
}
