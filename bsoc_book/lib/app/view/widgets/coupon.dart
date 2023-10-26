import 'package:bsoc_book/app/view/widgets/charge_book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponDialog extends StatefulWidget {
  CouponDialog({super.key});

  @override
  State<CouponDialog> createState() => _CouponDialogState();
}

class _CouponDialogState extends State<CouponDialog> {
  var _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Align(alignment: Alignment.center, child: Text('Platform Coupon')),
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Nhập mã coupon của bạn',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Colors.blueAccent),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              primary: Colors.deepOrange[600],
              minimumSize: const Size.fromHeight(35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              // Navigator.pop(context, 'Không')
            },
            child: Text('Áp dụng mã'),
          ),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context, 'Không');

                Get.dialog(ChargeDialog());
              },
              child: Text(
                'Bỏ qua',
                style: TextStyle(color: Colors.white),
              )),
        ],
      )),
    );
  }
}
