import 'package:flutter/material.dart';

class AlertPageDialog extends StatelessWidget {
  AlertPageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thông báo'),
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vui lòng đăng nhập để có trải nghiệm tốt hơn',
            style: TextStyle(
                fontSize: 17, height: 1.5, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.blue,
              ),
              onPressed: () => Navigator.pop(context, 'Không'),
              child: Text(
                'Đóng',
                style: TextStyle(color: Colors.white),
              )),
        ],
      )),
    );
  }
}
