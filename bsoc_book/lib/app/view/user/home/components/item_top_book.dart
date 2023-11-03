import 'package:bsoc_book/app/models/book/top_book_model.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:flutter/material.dart';

class ItemTopBook extends StatefulWidget {
  const ItemTopBook({super.key, required this.topBookModel});

  final List<TopBookModel> topBookModel;
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
            TopBookModel topBookModel = widget.topBookModel[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {},
                child: SizedBox(
                  child: Image.network(
                    AppDataGlobal().domain + topBookModel.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
