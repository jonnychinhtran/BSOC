import 'dart:convert';
import 'dart:io';

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

  dynamic _topBookList;
  dynamic _getBookList;
  dynamic get checkListTopBook => _topBookList;
  dynamic get checkListBook => _getBookList;
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

  final BehaviorSubject<BookModel?> _bookDetailModelSubject =
      BehaviorSubject<BookModel?>();
  Stream<BookModel?> get bookDetailModelSubjectStream =>
      _bookDetailModelSubject.stream;

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
  }

  void setLoading(bool isLoading) {
    _loading = loading;
    _listTopBookSubject.add(isLoading);
    _bookModelSubject.add(isLoading);
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
        if (null != listCommentModel) {
          return listCommentModel;
        }
        return <ListCommentModel>[];
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

  void dispose() {
    _bookDetailModelSubject.close();
    _listTopBookSubject.close();
    _bookModelSubject.close();
  }
}
