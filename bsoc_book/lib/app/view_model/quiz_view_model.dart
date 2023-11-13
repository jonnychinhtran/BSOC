import 'package:bsoc_book/app/models/quiz/list_question_model.dart';
import 'package:bsoc_book/app/models/quiz/list_subject_model.dart';
import 'package:bsoc_book/app/models/quiz/post_quiz_model.dart';
import 'package:bsoc_book/app/models/quiz/question_result_model.dart';
import 'package:bsoc_book/app/models/quiz/subject_info_model.dart';
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

  SubjectInfoModel? _subjectInfoModel;
  QuestionResultModel? _quizResultModel;
  List<ListQuestionModel> _tempListQuestionBase = [];
  final List<ListQuestionModel> _listQuestionModel = [];
  List<ListSubjectModel> _tempListSubjectBase = [];
  final List<ListSubjectModel> _subjectModel = [];

  dynamic _questionList;
  dynamic _getSubjectList;
  dynamic get checkListQuestion => _questionList;
  dynamic get checkListBook => _getSubjectList;
  SubjectInfoModel? get subjectInfoModel => _subjectInfoModel;
  QuestionResultModel? get quizResultModel => _quizResultModel;

  // String get localPath => _localPath;
  List<ListQuestionModel> get tempListQuestionBase => _tempListQuestionBase;
  List<ListQuestionModel> get listQuestionModel => _listQuestionModel;

  List<ListSubjectModel> get tempListSubjectBase => _tempListSubjectBase;
  List<ListSubjectModel> get listSubjectModel => _subjectModel;

  final BehaviorSubject<bool> _listQuestionSubject = BehaviorSubject();
  Stream<bool> get listQuestionStream => _listQuestionSubject.stream;

  final BehaviorSubject<bool> _listSubjectModelSubject = BehaviorSubject();
  Stream<bool> get subjectQuizModelSubjectStream =>
      _listSubjectModelSubject.stream;

  final BehaviorSubject<SubjectInfoModel?> _subjectInfoModelSubject =
      BehaviorSubject<SubjectInfoModel?>();
  Stream<SubjectInfoModel?> get subjectInfoModelSubjectStream =>
      _subjectInfoModelSubject.stream;

  final BehaviorSubject<QuestionResultModel?> _subjectQuizResultSubject =
      BehaviorSubject<QuestionResultModel?>();
  Stream<QuestionResultModel?> get quizResultModelSubjectStream =>
      _subjectQuizResultSubject.stream;

  QuizViewModel({this.quizId = 0}) {
    _quizRepo = QuizApiRepository();
  }

  clearCache() {
    _hasMore = true;
    quizId = 0;
    // _localPath = '';
    _quizResultModel = null;
    _listQuestionModel.clear();
    _questionList = {};
    _subjectModel.clear();
    _getSubjectList = {};
    _subjectInfoModel = null;
  }

  void setLoading(bool isLoading) {
    _loading = loading;
    _listQuestionSubject.add(isLoading);
    _listSubjectModelSubject.add(isLoading);
  }

  void setSubjectInfoModel({SubjectInfoModel? subjectInfoModel}) {
    _subjectInfoModel = subjectInfoModel;
  }

  void setQuizResultModel({QuestionResultModel? quizResultModel}) {
    _quizResultModel = quizResultModel;
  }

  void setListQuestionModel({required List<ListQuestionModel> list}) {
    if (_tempListQuestionBase.isNotEmpty) {
      _tempListQuestionBase.clear();
    }
    _tempListQuestionBase = list;
  }

  void setListQuestionBase({required List<ListQuestionModel> list}) {
    _listQuestionModel.addAll(list);

    _questionList = {'list': _listQuestionModel};
  }

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
        if (null != _listSubjectModelSubject) {
          setsubjectModel(list: listSubjectModel);
          setListSubjectBase(list: listSubjectModel);
          return listSubjectModel;
        }
        return <ListSubjectModel>[];
      });

  Future<List<ListQuestionModel>> getListQuestionQuiz(id) {
    // clearCache();
    // setLoading(true);
    return _quizRepo.getListQuestion(quizId: id).then((listQuestionModel) {
      if (!_listQuestionSubject.isClosed) {
        setListQuestionModel(list: listQuestionModel);
        setListQuestionBase(list: listQuestionModel);
        // setLoading(false);
        return listQuestionModel;
      }
      return <ListQuestionModel>[];
    });
  }

  Future<SubjectInfoModel?> getSubjectInfoBottom(id) {
    return _quizRepo.getSubjectInfo(quizId: id).then((value) {
      if (null != value) {
        setSubjectInfoModel(subjectInfoModel: value);
        _subjectInfoModelSubject.add(value);
        return value;
      }
      return null;
    });
  }

  Future<QuestionResultModel?> updateQuizDone(data) {
    print('DATA DATA DATA : $data');
    return _quizRepo.updateQuiz(listQuiz: data).then((value) {
      if (null != value) {
        setQuizResultModel(quizResultModel: value);
        _subjectQuizResultSubject.add(value);
        return value;
      }
      return null;
    });
  }

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
    _subjectInfoModelSubject.close();
    _subjectQuizResultSubject.close();
    _listQuestionSubject.close();
    _listSubjectModelSubject.close();
  }
}
