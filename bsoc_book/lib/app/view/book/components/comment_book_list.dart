import 'package:bsoc_book/app/models/book/list_comment_model.dart';
import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:bsoc_book/widgets/rating_bar.dart';
import 'package:flutter/material.dart';

class CommentBookList extends StatefulWidget {
  const CommentBookList({
    super.key,
    required this.commentModel,
  });

  final List<ListCommentModel> commentModel;
  @override
  State<CommentBookList> createState() => _CommentBookListState();
}

class _CommentBookListState extends State<CommentBookList> {
  late List<ListCommentModel> _listCommentModel = [];
  late UserModel _userModel;

  @override
  void initState() {
    _listCommentModel = widget.commentModel;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: widget.commentModel.length,
        itemBuilder: (context, index) {
          // _userModel = _listCommentModel[index].user!;
          if (widget.commentModel[index].user != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: <Widget>[
                  Container(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                AppDataGlobal().domain +
                                    widget.commentModel[index].user!.avatar!,
                              )))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.commentModel[index].user!.fullname!),
                      Text(
                        widget.commentModel[index].content!,
                        textAlign: TextAlign.justify,
                      ),
                      RatingBars(
                          rating: widget.commentModel[index].rating!.toDouble())
                    ],
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
