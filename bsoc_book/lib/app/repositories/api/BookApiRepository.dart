import 'dart:convert';
import 'dart:io';
import 'package:bsoc_book/app/models/api/post_response_model.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:http/http.dart' as http;
import 'package:bsoc_book/api/ApiProviderRepository.dart';
import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/comment_model.dart';
import 'package:bsoc_book/app/models/book/list_comment_model.dart';
import 'package:bsoc_book/app/models/book/top_book_model.dart';
import 'package:bsoc_book/app/network/network_config.dart';
import 'package:bsoc_book/app/network/network_endpoints.dart';
import 'package:bsoc_book/app/repositories/IBookRepo.dart';
import 'package:bsoc_book/utils/network/network_util.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

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
          .get(url: '${NetworkEndpoints.GET_COMMENT_BOOK_API}/$bookId')
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
  Future<String> getFilePdf({required int chapterId}) async {
    String filename = 'chapter_$chapterId.pdf';

    var url =
        Uri.parse('http://103.77.166.202/api/chapter/download/$chapterId');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer ${AppDataGlobal().accessToken}',
      'Accept': 'application/pdf'
    });

    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");

    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }

  @override
  Future<PostReponseModel?> postComment(
      {required int userId,
      required int bookId,
      required double rating,
      required String content}) async {
    final formData = {
      "userId": userId,
      "bookId": bookId,
      "rating": rating,
      "content": content,
    };
    try {
      var response = await Dio().post('http://103.77.166.202/api/book/comment',
          data: json.encode(formData),
          options: Options(headers: {
            'Authorization': 'Bearer ${AppDataGlobal().accessToken}'
          }));
      if (response.statusCode == 200) {
        getListComment(bookId: bookId);
        final jsondata = response.data;
      } else {}
      print("res: ${response.data}");
    } catch (e) {
      print(e);
    }
  }
}
