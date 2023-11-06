import 'package:bsoc_book/api/ApiProviderRepository.dart';
import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/comment_model.dart';
import 'package:bsoc_book/app/models/book/list_comment_model.dart';
import 'package:bsoc_book/app/models/book/top_book_model.dart';
import 'package:bsoc_book/app/network/network_config.dart';
import 'package:bsoc_book/app/network/network_endpoints.dart';
import 'package:bsoc_book/app/repositories/IBookRepo.dart';
import 'package:bsoc_book/utils/network/network_util.dart';
import 'package:logging/logging.dart';

class BookApiRepository extends ApiProviderRepository implements IBookRepo {
  final logger = Logger("BookApiRepository");

  @override
  Future<List<BookModel>> getList() => NetworkUtil2()
          .get(url: NetworkEndpoints.GET_BOOK_STORE_API)
          .then((dynamic response) {
        final items = response['content'];
        List<BookModel> list = [];
        for (int i = 0; i < items.length; i++) {
          BookModel bookModel = BookModel.fromJson(items[i]);
          list.add(bookModel);
        }
        return list;
      });

  @override
  Future<List<BookModel>> getListTop() => NetworkUtil2()
          .get(url: NetworkEndpoints.GET_TOP_BOOK_API)
          .then((dynamic response) {
        final items = response;
        List<BookModel> list = [];
        for (int i = 0; i < items.length; i++) {
          BookModel topBookModel = BookModel.fromJson(items[i]);
          list.add(topBookModel);
        }

        return list;
      });

  @override
  Future<BookModel?> getBookDetail({required int bookId}) => NetworkUtil2()
          .get(url: '${NetworkEndpoints.GET_BOOK_DETAIL_API}/$bookId')
          .then((dynamic response) {
        final data = response;
        BookModel bookModel = BookModel.fromJson(data);
        return bookModel;
      });

  @override
  Future<List<ListCommentModel>> getListComment({required int bookId}) =>
      NetworkUtil2()
          .get(url: NetworkEndpoints.GET_COMMENT_BOOK_API + '/$bookId')
          .then((dynamic response) {
        final items = response;
        List<ListCommentModel> list = [];
        for (int i = 0; i < items.length; i++) {
          ListCommentModel commentModel = ListCommentModel.fromJson(items[i]);
          list.add(commentModel);
        }

        return list;
      });

  @override
  Future getFilePdf({required int chapterId}) => NetworkUtil2()
      .get(url: NetworkEndpoints.GET_DOWNLOAD_CHAPTER_API + '/$chapterId')
      .then((dynamic response) => print(response));
}
