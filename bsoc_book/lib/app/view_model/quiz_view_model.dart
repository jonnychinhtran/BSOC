import 'package:bsoc_book/app/models/quiz/list_subject_model.dart';
import 'package:bsoc_book/app/repositories/IQuizRepo.dart';
import 'package:bsoc_book/app/repositories/api/QuizApiRepository.dart';
import 'package:rxdart/rxdart.dart';

class QuizViewModel {
  int quizId;
  // String _localPath = "";
  late IQuizRepo _quizRepo;

  bool _hasMore = true;
  bool _loading = false;
  bool get loading => _loading;
  bool get hasMore => _hasMore;

  // BookModel? _bookDetailModel;
  // List<BookModel> _tempListTopBookBase = [];
  // final List<BookModel> _topbookModel = [];
  List<ListSubjectModel> _tempListSubjectBase = [];
  final List<ListSubjectModel> _subjectModel = [];

  // dynamic _topBookList;
  dynamic _getSubjectList;
  // dynamic get checkListTopBook => _topBookList;
  dynamic get checkListBook => _getSubjectList;
  // BookModel? get bookDetailModel => _bookDetailModel;
  // String get localPath => _localPath;
  // List<BookModel> get tempListTopBookBase => _tempListTopBookBase;
  // List<BookModel> get topBookModel => _topbookModel;

  List<ListSubjectModel> get tempListSubjectBase => _tempListSubjectBase;
  List<ListSubjectModel> get listSubjectModel => _subjectModel;

  // final BehaviorSubject<bool> _listTopBookSubject = BehaviorSubject();
  // Stream<bool> get listTopBookStream => _listTopBookSubject.stream;

  final BehaviorSubject<bool> _listSubjectModelSubject = BehaviorSubject();
  Stream<bool> get subjectQuizModelSubjectStream =>
      _listSubjectModelSubject.stream;

  // final BehaviorSubject<BookModel?> _bookDetailModelSubject =
  //     BehaviorSubject<BookModel?>();
  // Stream<BookModel?> get bookDetailModelSubjectStream =>
  //     _bookDetailModelSubject.stream;

  QuizViewModel({this.quizId = 0}) {
    _quizRepo = QuizApiRepository();
  }

  clearCache() {
    _hasMore = true;
    quizId = 0;
    // _localPath = '';
    // _topbookModel.clear();
    // _topBookList = {};
    _subjectModel.clear();
    _getSubjectList = {};
    // _bookDetailModel = null;
  }

  void setLoading(bool isLoading) {
    _loading = loading;
    // _listTopBookSubject.add(isLoading);
    _listSubjectModelSubject.add(isLoading);
  }

  // void setBookDetailModel({BookModel? bookModel}) {
  //   _bookDetailModel = bookModel;
  // }

  // void setTopBookModel({required List<BookModel> list}) {
  //   if (_tempListTopBookBase.isNotEmpty) {
  //     _tempListTopBookBase.clear();
  //   }
  //   _tempListTopBookBase = list;
  // }

  // void setListTopBookBase({required List<BookModel> list}) {
  //   _topbookModel.addAll(list);

  //   _topBookList = {'list': _topbookModel};
  // }

  void setsubjectModel({required List<ListSubjectModel> list}) {
    if (_tempListSubjectBase.isNotEmpty) {
      _tempListSubjectBase.clear();
    }
    _tempListSubjectBase = list;
  }

  void setListSubjectBase({required List<ListSubjectModel> list}) {
    _subjectModel.addAll(list);

    _getSubjectList = {'list': _subjectModel};
  }

  // Future<List<ListSubjectModel>> getListSubjectQuiz() {
  //   clearCache();
  //   setLoading(true);
  //   return _quizRepo.getListSubject().then((dynamic subjectModel) {
  //     if (!_listSubjectModelSubject.isClosed) {
  //       setsubjectModel(list: subjectModel ?? []);
  //       setListSubjectBase(list: subjectModel ?? []);
  //       setLoading(false);
  //     }
  //     return <ListSubjectModel>[];
  //   });
  // }

  Future<List<ListSubjectModel>> getListSubjectQuiz() =>
      _quizRepo.getListSubject().then((listSubjectModel) {
        if (null != listSubjectModel) {
          return listSubjectModel;
        }
        return <ListSubjectModel>[];
      });

  // void getListTopBook() {
  //   clearCache();
  //   setLoading(true);
  //   _bookRepo.getListTop().then((dynamic topbookModel) {
  //     if (!_listTopBookSubject.isClosed) {
  //       setTopBookModel(list: topbookModel ?? []);
  //       setListTopBookBase(list: topbookModel ?? []);
  //       setLoading(false);
  //     }
  //   });
  // }

  // Future<BookModel?> getBookDetailPage() {
  //   return _bookRepo.getBookDetail(bookId: bookId).then((value) {
  //     if (null != value) {
  //       setBookDetailModel(bookModel: value);
  //       _bookDetailModelSubject.add(value);
  //       return value;
  //     }
  //     return null;
  //   });
  // }

  // Future<List<ListCommentModel>> getListCommentBook(id) =>
  //     _bookRepo.getListComment(bookId: id).then((listCommentModel) {
  //       if (null != listCommentModel) {
  //         return listCommentModel;
  //       }
  //       return <ListCommentModel>[];
  //     });

  // Future<String> getChapterPdf(id) =>
  //     _bookRepo.getFilePdf(chapterId: id).then((pdfFile) async {
  //       print('PDF PDF : $pdfFile');
  //       if (null != pdfFile) {
  //         _localPath = pdfFile;
  //         return pdfFile;
  //       }
  //       return '';
  //     });

  void dispose() {
    // _bookDetailModelSubject.close();
    // _listTopBookSubject.close();
    _listSubjectModelSubject.close();
  }
}
