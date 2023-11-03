import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/top_book_model.dart';
import 'package:bsoc_book/app/repositories/IBookRepo.dart';
import 'package:bsoc_book/app/repositories/api/BookApiRepository.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel {
  late IBookRepo _bookRepo;

  HomeViewModel() {
    _bookRepo = BookApiRepository();
  }

  bool _hasMore = true;
  bool _loading = false;
  bool get loading => _loading;
  bool get hasMore => _hasMore;

  List<TopBookModel> _tempListTopBookBase = [];
  final List<TopBookModel> _topbookModel = [];
  List<BookModel> _tempListBookBase = [];
  final List<BookModel> _bookModel = [];

  dynamic _topBookList;
  dynamic _getBookList;
  dynamic get checkListTopBook => _topBookList;
  dynamic get checkListBook => _getBookList;

  List<TopBookModel> get tempListTopBookBase => _tempListTopBookBase;
  List<TopBookModel> get topBookModel => _topbookModel;

  List<BookModel> get tempListBookBase => _tempListBookBase;
  List<BookModel> get listbookModel => _bookModel;

  final BehaviorSubject<bool> _listTopBookSubject = BehaviorSubject();
  Stream<bool> get listTopBookStream => _listTopBookSubject.stream;

  final BehaviorSubject<bool> _bookModelSubject = BehaviorSubject();
  Stream<bool> get bookModelSubjectStream => _bookModelSubject.stream;

  void setLoading(bool isLoading) {
    _loading = loading;
    _listTopBookSubject.add(isLoading);
    _bookModelSubject.add(isLoading);
  }

  void setTopBookModel({required List<TopBookModel> list}) {
    if (_tempListTopBookBase.isNotEmpty) {
      _tempListTopBookBase.clear();
    }
    _tempListTopBookBase = list;
  }

  void setListTopBookBase({required List<TopBookModel> list}) {
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

  void clearCache() {
    _hasMore = true;
    _topbookModel.clear();
    _topBookList = {};
    _bookModel.clear();
    _getBookList = {};
  }

  void dispose() {
    _listTopBookSubject.close();
    _bookModelSubject.close();
  }
}
