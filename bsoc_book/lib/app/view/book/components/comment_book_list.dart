import 'dart:convert';

import 'package:bsoc_book/app/models/book/list_comment_model.dart';
import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/view/book/components/item_comment_popup.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/user_view_model.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:bsoc_book/widgets/default_button.dart';
import 'package:bsoc_book/widgets/rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:developer' as logg;

class CommentBookList extends StatefulWidget {
  const CommentBookList({
    super.key,
    required this.bookId,
    required this.homeViewModel,
    // required this.commentModel,
  });

  final int bookId;
  final HomeViewModel homeViewModel;
  // final List<ListCommentModel> commentModel;
  @override
  State<CommentBookList> createState() => _CommentBookListState();
}

class _CommentBookListState extends State<CommentBookList> {
  List<ListCommentModel> _listCommentModel = [];
  late UserViewModel _userViewModel;
  UserModel? _userItem;
  int _userCommentId = 0;
  int _usertId = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();
  double? _rating;
  double _initialRating = 5;
  bool _isVertical = false;
  bool _isLoading = false;

  late HomeViewModel _homeViewModel;

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;

    _rating = _initialRating;
    _userViewModel = UserViewModel();

    _homeViewModel.getListCommentBook(widget.bookId).then((value) {
      if (value != null) {
        _listCommentModel = value;
        logg.log(jsonEncode(_listCommentModel));
      }
    });

    _homeViewModel.listCommentModelSubjectStream.listen((event) {
      setState(() {
        _isLoading = true;
      });
    });

    if (AppDataGlobal().accessToken != "") {
      _userViewModel.getInfoPage().then((value) {
        if (value != null) {
          _usertId = value.id!;
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
          body: StreamBuilder(
              stream: _homeViewModel.bookCommentModelSubjectStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  List<ListCommentModel> item = snapshot.data!;
                  for (var i = 0; i < item.length; i++) {
                    if (item[i].user!.id == _usertId) {
                      _userCommentId = item[i].user!.id!;
                    }
                  }
                  return Stack(
                    children: [
                      Container(
                        color: Colors.white,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: item.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(
                                                  AppDataGlobal().domain +
                                                      item[index].user!.avatar!,
                                                )))),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item[index].user!.fullname!),
                                            Text(
                                              item[index].content!,
                                              textAlign: TextAlign.justify,
                                            ),
                                            RatingBars(
                                                rating:
                                                    item[index].rating == null
                                                        ? 0
                                                        : item[index]
                                                            .rating!
                                                            .toDouble())
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      (_isLoading == false)
                          ? Center(
                              child: LoadingAnimationWidget.discreteCircle(
                              color: AppColors.PRIMARY_COLOR,
                              secondRingColor: Colors.black,
                              thirdRingColor: Colors.purple,
                              size: 30,
                            ))
                          : Container(),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                if (AppDataGlobal().accessToken != "") {
                  print('USER ID: $_usertId');
                  print('COMMENT ID: ${_userCommentId}');
                  if (_userCommentId != _usertId) {
                    WidgetHelper.showPopupMessage(
                        context: context,
                        header: "Đánh giá sách",
                        headerColor: AppColors.PRIMARY_COLOR,
                        content: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      child: RatingBar.builder(
                                    initialRating: _initialRating,
                                    wrapAlignment: WrapAlignment.center,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    unratedColor: Colors.amber.withAlpha(50),
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _rating = rating;
                                        print('RATING: $_rating');
                                      });
                                    },
                                    updateOnDrag: true,
                                  )),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Nội dung:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.black)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.red)),
                                ),
                                controller: _contentController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                validator: (value) {
                                  return (value == null || value.isEmpty)
                                      ? 'Vui lòng nhập nội dung'
                                      : null;
                                },
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DefaultButton(
                                      title: 'Hủy',
                                      titleColor: Colors.white,
                                      backgroundColor: Colors.red,
                                      borderColor: Colors.red,
                                      onPress: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: DefaultButton(
                                      title: 'Gửi đánh giá',
                                      titleColor: Colors.white,
                                      backgroundColor: AppColors.PRIMARY_COLOR,
                                      borderColor: AppColors.PRIMARY_COLOR,
                                      onPress: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final formData = {
                                            "userId": _usertId,
                                            "bookId": widget.bookId,
                                            "rating": _rating,
                                            "content": _contentController.text,
                                          };
                                          try {
                                            var response = await Dio().post(
                                                'http://103.77.166.202/api/book/comment',
                                                data: json.encode(formData),
                                                options: Options(headers: {
                                                  'Authorization':
                                                      'Bearer ${AppDataGlobal().accessToken}'
                                                }));
                                            if (response.statusCode == 200) {
                                              final jsondata = response.data;
                                              Navigator.of(context).pop();
                                              _homeViewModel.getListCommentBook(
                                                  widget.bookId);
                                              WidgetHelper.showMessageSuccess(
                                                  context: context,
                                                  content:
                                                      "Đánh giá thành công");
                                              _contentController.clear();
                                            } else {
                                              WidgetHelper.showMessageError(
                                                  context: context,
                                                  content: "Đánh giá thất bại");
                                            }
                                            print("res: ${response.data}");
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ));
                  } else {
                    WidgetHelper.showMessageInfo(
                        context: context, content: "Bạn đã đánh giá sách này");
                  }
                } else {
                  WidgetHelper.showPopupMessage(
                      context: context,
                      header: "Thông báo",
                      headerColor: AppColors.PRIMARY_COLOR,
                      content:
                          const Text("Bạn cần đăng nhập để đánh giá sách"));
                }
              },
              child: Icon(Icons.edit, color: Colors.red),
              backgroundColor: Colors.white,
              elevation: 4.0,
              shape: const CircleBorder(),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked),
    );
  }
}
