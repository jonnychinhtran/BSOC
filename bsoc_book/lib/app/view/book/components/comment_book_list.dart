import 'package:bsoc_book/app/models/book/list_comment_model.dart';
import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/view/book/components/item_comment_popup.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:bsoc_book/widgets/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
    return Scaffold(
        body: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: widget.commentModel.length,
            itemBuilder: (context, index) {
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.commentModel[index].user!.fullname!),
                            Text(
                              widget.commentModel[index].content!,
                              textAlign: TextAlign.justify,
                            ),
                            RatingBars(
                                rating:
                                    widget.commentModel[index].rating == null
                                        ? 0
                                        : widget.commentModel[index].rating!
                                            .toDouble())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FloatingActionButton(
            onPressed: () {
              _showPopupComment();
            },
            child: Icon(Icons.edit, color: Colors.red),
            backgroundColor: Colors.white,
            elevation: 4.0,
            shape: CircleBorder(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked);
  }

  _showPopupComment() {
    WidgetHelper.showPopupMessage(
        context: context,
        header: "Đánh giá sách",
        headerColor: AppColors.PRIMARY_COLOR,
        content: ItemCommentPopup());
  }
}
