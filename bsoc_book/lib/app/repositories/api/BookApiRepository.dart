import 'package:bsoc_book/api/ApiProviderRepository.dart';
import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/top_book_model.dart';
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
  Future<List<TopBookModel>> getListTop() => NetworkUtil2()
          .get(url: NetworkEndpoints.GET_TOP_BOOK_API)
          .then((dynamic response) {
        final items = response;
        List<TopBookModel> list = [];
        for (int i = 0; i < items.length; i++) {
          TopBookModel topBookModel = TopBookModel.fromJson(items[i]);
          list.add(topBookModel);
        }

        return list;
      });
}
