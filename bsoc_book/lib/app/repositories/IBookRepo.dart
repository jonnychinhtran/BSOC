import 'package:bsoc_book/app/models/api/post_response_model.dart';
import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/comment_model.dart';
import 'package:bsoc_book/app/models/book/list_comment_model.dart';
import 'package:bsoc_book/app/models/book/top_book_model.dart';

abstract class IBookRepo {
  Future<List<BookModel>> getListTop();
  Future<List<BookModel>> getList();

  Future<BookModel?> getBookDetail({required int bookId});

  Future<List<ListCommentModel>> getListComment({required int bookId});

  Future<PostReponseModel?> postComment(
      {required int userId,
      required int bookId,
      required double rating,
      required String content});

  Future getFilePdf({required int chapterId});
}