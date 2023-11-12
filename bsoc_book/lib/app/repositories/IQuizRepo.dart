import 'package:bsoc_book/app/models/quiz/list_subject_model.dart';

abstract class IQuizRepo {
  Future<List<ListSubjectModel>> getListSubject();
  // Future<List<BookModel>> getList();

  // Future<BookModel?> getBookDetail({required int bookId});

  // Future<List<ListCommentModel>> getListComment({required int bookId});

  // Future getFilePdf({required int chapterId});
}
