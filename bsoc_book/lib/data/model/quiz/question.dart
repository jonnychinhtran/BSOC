import 'package:bsoc_book/data/model/quiz/answers_model.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'question.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Question {
  int id;
  @JsonKey(name: 'content')
  String content;
  @JsonKey(name: 'isMultiChoice', defaultValue: false)
  final bool isMultiChoice;
  @JsonKey(name: 'totalAnswer')
  int totalAnswer;
  @JsonKey(name: 'answers')
  List<Answers> answers;

  Question(this.id, this.content, this.isMultiChoice, this.totalAnswer,
      this.answers);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
