import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/top_book_model.dart';

abstract class IBookRepo {
  Future<List<TopBookModel>> getListTop();
  Future<List<BookModel>> getList();
}
