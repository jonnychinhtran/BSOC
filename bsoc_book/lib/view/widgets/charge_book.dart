import 'package:flutter/material.dart';

class ChargeDialog extends StatelessWidget {
  ChargeDialog({super.key});

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
            'Sách bản quyền của B4U BSOC',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          Text(
            'Vui lòng thanh toán để mở khóa.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          Row(
            children: [
              Text(
                'Giá bán: ',
                style: TextStyle(fontSize: 17, height: 1.5),
              ),
              Text(
                '59.000VNĐ',
                style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Thông tin chuyển khoản',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          Text(
            'Ngân hàng Vietcombank',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                height: 1.5,
                color: Colors.green.shade800),
          ),
          Text(
            'Chủ tài khoản: Lê Thị Bích Hòa',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          Text(
            'Số tài khoản: 0071003095741',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          Text(
            'Chi nhánh Kỳ Đồng, Q.3, HCMC ',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Nội dung chuyển khoản:',
            style: TextStyle(
                fontSize: 16, height: 1.5, fontWeight: FontWeight.bold),
          ),
          Text(
            'USER<Mã Tài khoản> + BOOK<Mã Sách>',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
          Text(
            'Ví dụ: USER 3 BOOK 10',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            '*Lưu ý: Mã user trong cài đặt tài khoản, Mã sách trong chi tiết sách',
            style: TextStyle(fontSize: 12.5, height: 1.5, color: Colors.blue),
          ),
          Text(
            'Mọi thắc mắc vui lòng liên hệ Email: info@b4usolution.com ; Zalo: 0989214285',
            style: TextStyle(
                fontSize: 12, height: 1.5, color: Colors.orange.shade700),
          ),
          SizedBox(
            height: 10,
          ),

          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     elevation: 2,
          //     primary: Colors.blueAccent,
          //     minimumSize: const Size.fromHeight(35),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //   ),
          //   onPressed: () {},
          //   child: Text('Đăng nhập lại'),
          // ),
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
