import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:flutter/material.dart';

class ItemBook extends StatefulWidget {
  const ItemBook({super.key, required this.bookModel});

  final List<BookModel> bookModel;
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
        BookModel bookModel = widget.bookModel[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
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
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
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
