import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ItemCommentPopup extends StatefulWidget {
  const ItemCommentPopup({super.key});

  @override
  State<ItemCommentPopup> createState() => _ItemCommentPopupState();
}

class _ItemCommentPopupState extends State<ItemCommentPopup> {
  final _formKey = GlobalKey<FormState>();
  late final _ratingController;
  late double _rating;
  double _initialRating = 5;
  bool _isVertical = false;

  @override
  void initState() {
    _rating = _initialRating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                });
              },
              updateOnDrag: true,
            )),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Text("Nội dung:"),
        const SizedBox(
          height: 3,
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
          // controller: cmtcontroller.contentController,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Vui lòng nhập nội dung'
                : null;
          },
        )
      ],
    );
  }
}
