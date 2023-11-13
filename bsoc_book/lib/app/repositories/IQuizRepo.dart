import 'package:bsoc_book/app/models/quiz/list_question_model.dart';
import 'package:bsoc_book/app/models/quiz/list_subject_model.dart';
import 'package:bsoc_book/app/models/quiz/post_quiz_model.dart';
import 'package:bsoc_book/app/models/quiz/question_result_model.dart';
import 'package:bsoc_book/app/models/quiz/subject_info_model.dart';

abstract class IQuizRepo {
  Future<List<ListSubjectModel>> getListSubject();
  // Future<List<BookModel>> getList();

  Future<SubjectInfoModel?> getSubjectInfo({required int quizId});

  Future<QuestionResultModel?> updateQuiz({required dynamic listQuiz});

  Future<List<ListQuestionModel>> getListQuestion({required int quizId});

  // Future getFilePdf({required int chapterId});
}
