import 'package:flutter/material.dart';

class RatingBars extends StatelessWidget {
  double rating;
  final double size;
  int? ratingCount;

  RatingBars({required this.rating, this.ratingCount, this.size = 18});

  @override
  Widget build(BuildContext context) {
    List<Widget> _startList = [];
    int realNumber = rating.floor();
    int partNumber = ((rating - realNumber) * 10).ceil();

    for (int i = 0; i < 5; i++) {
      if (i < realNumber) {
        _startList.add(Icon(
          Icons.star,
          color: Colors.yellow,
          size: size,
        ));
      } else if (i == realNumber) {
        _startList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: size,
              ),
              ClipRect(
                clipper: _Clipper(part: partNumber),
                child: Icon(
                  Icons.star,
                  color: Colors.grey,
                  size: size,
                ),
              ),
            ],
          ),
        ));
      } else {
        _startList.add(Icon(
          Icons.star,
          color: Colors.grey,
          size: size,
        ));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _startList,
    );
  }
}

class _Clipper extends CustomClipper<Rect> {
  final int part;
  _Clipper({required this.part});
  Rect getClip(Size size) {
    return Rect.fromLTRB(
        (size.width / 10) * part, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}
