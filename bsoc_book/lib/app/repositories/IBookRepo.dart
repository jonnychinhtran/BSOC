import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/comment_model.dart';
import 'package:bsoc_book/app/models/book/list_comment_model.dart';
import 'package:bsoc_book/app/models/book/top_book_model.dart';

abstract class IBookRepo {
  Future<List<BookModel>> getListTop();
  Future<List<BookModel>> getList();

  Future<BookModel?> getBookDetail({required int bookId});

  Future<List<ListCommentModel>> getListComment({required int bookId});

  Future getFilePdf({required int chapterId});
}
