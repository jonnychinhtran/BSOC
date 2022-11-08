import 'package:flutter/material.dart';
import '../../../model/book_model.dart';

class DetailBookPage extends StatelessWidget {
  const DetailBookPage({Key? key, required this.books}) : super(key: key);

  final Book books;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(books.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(books.author),
      ),
    );
  }
}
