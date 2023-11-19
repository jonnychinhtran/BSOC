import 'dart:convert';
import 'dart:io';

import 'package:bsoc_book/app/models/api/post_response_model.dart';
import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/list_comment_model.dart';
import 'package:bsoc_book/app/models/book/top_book_model.dart';
import 'package:bsoc_book/app/repositories/IBookRepo.dart';
import 'package:bsoc_book/app/repositories/api/BookApiRepository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel {
  int bookId;
  String _localPath = "";
  late IBookRepo _bookRepo;

  bool _hasMore = true;
  bool _loading = false;
  bool get loading => _loading;
  bool get hasMore => _hasMore;

  BookModel? _bookDetailModel;
  List<BookModel> _tempListTopBookBase = [];
  final List<BookModel> _topbookModel = [];
  List<BookModel> _tempListBookBase = [];
  final List<BookModel> _bookModel = [];
  List<ListCommentModel> _tempListCommentBase = [];
  final List<ListCommentModel> _listCommentModel = [];

  PostReponseModel? _postReponseModel;

  PostReponseModel? get postModel => _postReponseModel;

  dynamic _topBookList;
  dynamic _getBookList;
  dynamic _getCommentList;

  dynamic get checkListTopBook => _topBookList;
  dynamic get checkListBook => _getBookList;
  dynamic get checkListComment => _getCommentList;
  BookModel? get bookDetailModel => _bookDetailModel;
  String get localPath => _localPath;
  List<BookModel> get tempListTopBookBase => _tempListTopBookBase;
  List<BookModel> get topBookModel => _topbookModel;

  List<BookModel> get tempListBookBase => _tempListBookBase;
  List<BookModel> get listbookModel => _bookModel;

  final BehaviorSubject<bool> _listTopBookSubject = BehaviorSubject();
  Stream<bool> get listTopBookStream => _listTopBookSubject.stream;

  final BehaviorSubject<bool> _bookModelSubject = BehaviorSubject();
  Stream<bool> get bookModelSubjectStream => _bookModelSubject.stream;

  final BehaviorSubject<bool> _listCommentModelSubject = BehaviorSubject();
  Stream<bool> get listCommentModelSubjectStream =>
      _listCommentModelSubject.stream;

  final BehaviorSubject<BookModel?> _bookDetailModelSubject =
      BehaviorSubject<BookModel?>();
  Stream<BookModel?> get bookDetailModelSubjectStream =>
      _bookDetailModelSubject.stream;

  final BehaviorSubject<List<ListCommentModel>?> _bookCommentModelSubject =
      BehaviorSubject<List<ListCommentModel>?>();
  Stream<List<ListCommentModel>?> get bookCommentModelSubjectStream =>
      _bookCommentModelSubject.stream;

  HomeViewModel({this.bookId = 0}) {
    _bookRepo = BookApiRepository();
  }

  clearCache() {
    _hasMore = true;
    bookId = 0;
    _localPath = '';
    _topbookModel.clear();
    _topBookList = {};
    _bookModel.clear();
    _getBookList = {};
    _bookDetailModel = null;
    _bookDetailModelSubject.add(null);
  }

  void setLoading(bool isLoading) {
    _loading = loading;
    _listTopBookSubject.add(isLoading);
    _bookModelSubject.add(isLoading);
    _listCommentModelSubject.add(isLoading);
  }

  void setBookDetailModel({BookModel? bookModel}) {
    _bookDetailModel = bookModel;
  }

  void setTopBookModel({required List<BookModel> list}) {
    if (_tempListTopBookBase.isNotEmpty) {
      _tempListTopBookBase.clear();
    }
    _tempListTopBookBase = list;
  }

  void setListTopBookBase({required List<BookModel> list}) {
    _topbookModel.addAll(list);

    _topBookList = {'list': _topbookModel};
  }

  void setbookModel({required List<BookModel> list}) {
    if (_tempListBookBase.isNotEmpty) {
      _tempListBookBase.clear();
    }
    _tempListBookBase = list;
  }

  void setListBookBase({required List<BookModel> list}) {
    _bookModel.addAll(list);

    _getBookList = {'list': _bookModel};
  }

  void setPostModel({PostReponseModel? postModel}) {
    _postReponseModel = postModel;
  }

  void getListBook() {
    clearCache();
    setLoading(true);
    _bookRepo.getList().then((dynamic bookModel) {
      if (!_bookModelSubject.isClosed) {
        setbookModel(list: bookModel ?? []);
        setListBookBase(list: bookModel ?? []);
        setLoading(false);
      }
    });
  }

  void getListTopBook() {
    clearCache();
    setLoading(true);
    _bookRepo.getListTop().then((dynamic topbookModel) {
      if (!_listTopBookSubject.isClosed) {
        setTopBookModel(list: topbookModel ?? []);
        setListTopBookBase(list: topbookModel ?? []);
        setLoading(false);
      }
    });
  }

  Future<BookModel?> getBookDetailPage() {
    return _bookRepo.getBookDetail(bookId: bookId).then((value) {
      if (null != value) {
        setBookDetailModel(bookModel: value);
        _bookDetailModelSubject.add(value);
        return value;
      }
      return null;
    });
  }

  Future<List<ListCommentModel>> getListCommentBook(id) =>
      _bookRepo.getListComment(bookId: id).then((listCommentModel) {
        _bookCommentModelSubject.add(listCommentModel);
        return listCommentModel;
      });

  Future<String> getChapterPdf(id) =>
      _bookRepo.getFilePdf(chapterId: id).then((pdfFile) async {
        print('PDF PDF : $pdfFile');
        if (null != pdfFile) {
          _localPath = pdfFile;
          return pdfFile;
        }
        return '';
      });

  Future<PostReponseModel?> postCommentBook({
    required int userId,
    required int bookId,
    required double rating,
    required String content,
  }) {
    return _bookRepo
        .postComment(
            userId: userId, bookId: bookId, rating: rating, content: content)
        .then((value) {
      setPostModel(postModel: value);
      return value;
    });
  }

  void dispose() {
    _bookDetailModelSubject.close();
    _bookCommentModelSubject.close();
    _listTopBookSubject.close();
    _bookModelSubject.close();
  }
}
