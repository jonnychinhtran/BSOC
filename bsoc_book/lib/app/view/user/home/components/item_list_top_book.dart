import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:flutter/material.dart';

class ItemListTopBook extends StatelessWidget {
  const ItemListTopBook({
    Key? key,
    required this.bookModel,
    required this.onPressedNextPage,
  }) : super(key: key);

  final BookModel bookModel;
  final Function onPressedNextPage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressedNextPage(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Image.network(
            AppDataGlobal().domain + bookModel.image.toString(),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
