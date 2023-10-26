import 'package:bsoc_book/app/view/wheel_spin/wheel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TimeFrameIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WheelPage()));
      },
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.red,
              width: 3.0,
            ),
          ),
          child: SvgPicture.asset(
            'assets/images/wheel_icon.svg',
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
}
