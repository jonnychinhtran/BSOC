import 'dart:io';

import 'package:bsoc_book/view/widgets/menu_aside.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 153, 195, 59),
          centerTitle: true,
          title: Text("Thông tin liên hệ"),
        ),
        drawer: const MenuAside(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Liên hệ:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text('Mrs: Hòa',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: size.height * 0.01),
                  Text('Số điện thoại: 0989214285',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: size.height * 0.01),
                  Text('Skype: hoa.lethibich',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: size.height * 0.01),
                  Text('Email: info@b4usolution.com',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: size.height * 0.04),
                  Text(
                    'Vị trí:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                      'Địa chỉ 1: Phòng 108, Tòa nhà SBI, Lốc 6B, đường số 3, Công viên phần mềm Quang Trung, phường Tân Chánh Hiệp, quận 12, thành phố Hồ Chí Minh.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: size.height * 0.01),
                  Text(
                      'Địa chỉ 2: Số 796/157/2 đường Lê Đức Thọ, phường 15, quận Gò Vấp, thành phố Hồ Chí Minh. ',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: size.height * 0.04),
                  Image.network(
                      'https://b4usolution.com/upload/tin-tuc/bai-viet/b4u1.JPG')
                ],
              ),
            ),
          ),
        ));
  }
}
