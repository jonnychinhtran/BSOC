import 'package:bsoc_book/app/models/quiz/answer_model.dart';
import 'package:bsoc_book/app/models/quiz/list_question_model.dart';
import 'package:bsoc_book/app/models/quiz/post_quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';

class CheckAnswersPage extends StatefulWidget {
  const CheckAnswersPage({
    super.key,
    required this.questions,
    required this.answersPost,
  });

  final List<ListQuestionModel> questions;
  final List<PostQuizModel>? answersPost;

  @override
  State<CheckAnswersPage> createState() => _CheckAnswersPageState();
}

class _CheckAnswersPageState extends State<CheckAnswersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiểm tra kết quả'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 200,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: widget.questions.length + 1,
            itemBuilder: _buildItem,
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == widget.questions.length) {
      return ElevatedButton(
        child: Text("Về trang chủ"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }

    ListQuestionModel question = widget.questions[index];
    List<AnswerModel>? options = question.answers;

    // Find the submitted answer IDs for this question
    List<int>? submittedAnswerIds = widget.answersPost
        ?.firstWhere((a) => a.questionId == question.id,
            orElse: () => PostQuizModel())
        .answerId
        ?.cast<int>();

    bool isMultiChoice = question.isMultiChoice ?? false;
    bool allCorrect = true;
    List<Widget> answerWidgets = [];

    submittedAnswerIds?.forEach((answerId) {
      AnswerModel? answer = options?.firstWhere((opt) => opt.id == answerId,
          orElse: () => AnswerModel());
      bool isCorrect = answer?.isCorrect ?? false;

      if (isMultiChoice) {
        // For multi-choice questions, all selected answers must be correct
        allCorrect = allCorrect && isCorrect;
      } else {
        // For single-choice questions, any correct answer is acceptable
        allCorrect = isCorrect;
      }

      answerWidgets.add(
        Text(
          '${answer?.content} (${isCorrect ? "Đúng" : "Sai"})',
          style: TextStyle(
            color: isCorrect ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      );
    });

    // For multi-choice questions, also check if any incorrect options were selected
    if (isMultiChoice) {
      allCorrect = allCorrect &&
          submittedAnswerIds!.every((id) => options!
              .any((answer) => answer.id == id && answer.isCorrect == true));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Câu ${index + 1}: ',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue)),
            Text(
              HtmlUnescape().convert(question.content ?? ''),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10.0),
            ...answerWidgets,
            const SizedBox(height: 10.0),
            allCorrect
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Đáp án đúng: ",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      ...options!.where((opt) => opt.isCorrect == true).map(
                            (opt) => Text(
                              HtmlUnescape().convert(opt.content ?? ''),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                height: 1.5,
                              ),
                            ),
                          ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  // Widget _buildItem(BuildContext context, int index) {
  //   if (index == widget.questions.length) {
  //     return ElevatedButton(
  //       child: Text("Về trang chủ"),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //     );
  //   }
  //   print(widget.questions[index]);
  //   List<ListQuestionModel> question = widget.questions;
  //   List<PostQuizModel> answerIds = widget.answersPost ?? [];

  //   // Find the correct answer for the current question
  //   Answers? correctAnswer =
  //       question.answers.firstWhere((answer) => answer.isCorrect == true);

  //   bool allCorrect = true;
  //   List<Widget> answerWidgets = [];
  //   for (int answerId in answerIds) {
  //     Answers? answer =
  //         question.answers?.firstWhere((answer) => answer.id == answerId);

  //     bool isCorrect = answer?.isCorrect ?? false;
  //     allCorrect = allCorrect && isCorrect;

  //     answerWidgets.add(
  //       Text(
  //         isCorrect
  //             ? '- ${answer?.content}'
  //             : '- ${answer?.content} (Đáp án sai)',
  //         style: TextStyle(
  //             color: isCorrect ? Colors.green : Colors.red,
  //             fontWeight: isCorrect ? FontWeight.bold : FontWeight.bold,
  //             fontSize: 18),
  //       ),
  //     );
  //   }

  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text(
  //             HtmlUnescape().convert(question.content),
  //             style: TextStyle(
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 16.0),
  //           ),
  //           SizedBox(height: 10.0),
  //           answerWidgets.isNotEmpty
  //               ? Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: answerWidgets)
  //               : Text(
  //                   'Bạn chưa chọn đáp án nào',
  //                   style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 18.0,
  //                     letterSpacing: 10.0,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //           SizedBox(height: 10.0),
  //           allCorrect
  //               ? Container()
  //               : Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text.rich(
  //                       TextSpan(
  //                         children: [
  //                           TextSpan(text: "Đáp án đúng: "),
  //                         ],
  //                       ),
  //                       style: TextStyle(
  //                         fontSize: 16.0,
  //                       ),
  //                     ),
  //                     Text(
  //                       HtmlUnescape().convert(
  //                         correctAnswer?.content ?? 'Vui lòng làm bài thi',
  //                       ),
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w500,
  //                         fontSize: 16.0,
  //                         height: 1.5,
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
