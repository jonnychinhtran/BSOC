import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:flutter/material.dart';

class ItemListBook extends StatelessWidget {
  const ItemListBook({
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
          child: Stack(
            children: [
              Column(
                children: [
                  Image.network(
                    AppDataGlobal().domain + bookModel.image!,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                      child: Text(
                    bookModel.bookName!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
