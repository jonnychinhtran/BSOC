import 'package:bsoc_book/api/ApiProviderRepository.dart';
import 'package:bsoc_book/app/models/quiz/list_question_model.dart';
import 'package:bsoc_book/app/models/quiz/list_subject_model.dart';
import 'package:bsoc_book/app/models/quiz/post_quiz_model.dart';
import 'package:bsoc_book/app/models/quiz/question_result_model.dart';
import 'package:bsoc_book/app/models/quiz/subject_info_model.dart';
import 'package:bsoc_book/app/network/network_endpoints.dart';
import 'package:bsoc_book/app/repositories/IQuizRepo.dart';
import 'package:bsoc_book/utils/network/network_util.dart';
import 'package:logging/logging.dart';

class QuizApiRepository extends ApiProviderRepository implements IQuizRepo {
  final logger = Logger("QuizApiRepository");

  @override
  Future<List<ListSubjectModel>> getListSubject() => NetworkUtil2()
          .get(url: NetworkEndpoints.GET_QUIZ_SUBJECT_API)
          .then((dynamic response) {
        final items = response;
        List<ListSubjectModel> list = [];
        for (int i = 0; i < items.length; i++) {
          ListSubjectModel subjectModel = ListSubjectModel.fromJson(items[i]);
          list.add(subjectModel);
        }
        return list;
      });

  @override
  Future<SubjectInfoModel?> getSubjectInfo({required int quizId}) =>
      NetworkUtil2()
          .get(url: '${NetworkEndpoints.GET_SUBJECT_INFO_API}/$quizId')
          .then((dynamic response) {
        final data = response;
        SubjectInfoModel subjectInfoModel = SubjectInfoModel.fromJson(data);
        return subjectInfoModel;
      });

  @override
  Future<List<ListQuestionModel>> getListQuestion({required int quizId}) =>
      NetworkUtil2()
          .get(url: '${NetworkEndpoints.GET_QUIZ_QUESTION_API}/$quizId')
          .then((dynamic response) {
        final items = response['listQuestion'];
        List<ListQuestionModel> list = [];
        for (int i = 0; i < items.length; i++) {
          ListQuestionModel commentModel = ListQuestionModel.fromJson(items[i]);
          list.add(commentModel);
        }

        return list;
      });

  @override
  Future<QuestionResultModel?> updateQuiz({
    required dynamic listQuiz,
  }) =>
      NetworkUtil2()
          .post(url: NetworkEndpoints.POST_CHECK_RESULT_API, data: listQuiz)
          .then((dynamic response) {
        print('KET QUA $response');
        QuestionResultModel resultModel =
            QuestionResultModel.fromJson(response);
        return resultModel;
      });
}
