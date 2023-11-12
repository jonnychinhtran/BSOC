import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/view/home/components/item_list_book.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:flutter/material.dart';

class ItemBook extends StatefulWidget {
  const ItemBook(
      {super.key, required this.bookModel, required this.onTapNextPage});

  final List<BookModel> bookModel;
  final Function onTapNextPage;

  @override
  State<ItemBook> createState() => _ItemBookState();
}

class _ItemBookState extends State<ItemBook> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      controller: ScrollController(keepScrollOffset: false),
      itemCount: widget.bookModel.length,
      itemBuilder: (context, index) {
        return ItemListBook(
            bookModel: widget.bookModel[index],
            onPressedNextPage: () {
              widget.onTapNextPage(widget.bookModel[index]);
            });
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 1 / 1.7,
      ),
    );
  }
}
