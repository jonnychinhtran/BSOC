import 'package:bsoc_book/api/ApiProviderRepository.dart';
import 'package:bsoc_book/app/models/quiz/list_subject_model.dart';
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
}
