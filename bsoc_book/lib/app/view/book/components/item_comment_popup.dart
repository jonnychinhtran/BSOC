import 'dart:convert';

import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/user_view_model.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:developer' as logg;

class ItemCommentPopup extends StatefulWidget {
  const ItemCommentPopup({
    super.key,
    required this.homeViewModel,
    required this.bookId,
    required this.userId,
  });

  final HomeViewModel homeViewModel;
  final int bookId;
  final int userId;

  @override
  State<ItemCommentPopup> createState() => _ItemCommentPopupState();
}

class _ItemCommentPopupState extends State<ItemCommentPopup> {
  late HomeViewModel _homeViewModel;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();
  late UserViewModel _userViewModel;
  UserModel? _userItem;
  double? _rating;
  double _initialRating = 5;
  bool _isVertical = false;

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    _rating = _initialRating;
    // _userItem = widget.userItem;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormField(
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.red)),
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
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      print('User ID: ${widget.userId}');
                      print('Book ID: ${widget.bookId}');
                      print('Rating: $_rating');
                      print('Content: ${_contentController.text}');
                      _homeViewModel
                          .postCommentBook(
                              userId: widget.userId,
                              bookId: widget.bookId,
                              rating: _rating!,
                              content: _contentController.text)
                          .then((value) => {
                                if (value != null)
                                  {
                                    _homeViewModel
                                        .getListCommentBook(widget.bookId),
                                    Navigator.of(context).pop(),
                                    WidgetHelper.showMessageSuccess(
                                        context: context,
                                        content: "Đánh giá thành công")
                                  }
                              });
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
