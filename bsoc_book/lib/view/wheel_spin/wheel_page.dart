import 'dart:async';
import 'dart:math';

import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html_unescape/html_unescape.dart';

class WheelPage extends StatefulWidget {
  const WheelPage({super.key});

  @override
  State<WheelPage> createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelPage> {
  final selected = StreamController<int>();
  int selectedIndex = 0;
  bool isSpinning = false;
  final storage = GetStorage();

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  final items = <String>[
    '       Chúc bạn \n\  may mắn lần sau',
    'Nhận 1 điểm \n\    đổi sách',
    '        Giảm 20% \n\khóa microservice',
    'Nhận 1 điểm \n\    đổi sách',
    '        Giảm 20% \n\       khóa học ios',
    'Nhận thêm \n\1 lượt quay',
    '       Chúc bạn \n\  may mắn lần sau',
    '         Giảm 20% \n\  khóa microservice',
  ];

  void spinWheel() {
    if (!isSpinning) {
      final random = Random();
      final selectedIndex = random.nextInt(items.length);
      isSpinning = true;
      selected.add(selectedIndex);

      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          isSpinning = false;
        });
        showResultDialog(selectedIndex);
      });
    }
  }

  void showResultDialog(int selectedIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Text('Thông báo'),
            content: Text(items[selectedIndex]),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    this.selectedIndex = selectedIndex;
                  });

                  // Store the selected voucher in GetStorage
                  storage.write('vouchers', [items[selectedIndex]]);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VoucherListPage(vouchers: [items[selectedIndex]]),
                    ),
                  );
                },
                child: Text('Thu thập ngay'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: Text('Vòng xoay may mắn'),
        leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.local_offer),
            onPressed: () async {
              final vouchers = storage.read('vouchers') ?? [];
              final voucherList =
                  vouchers.map((voucher) => voucher.toString()).toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VoucherListPage(vouchers: voucherList),
                ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          spinWheel();
        },
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.orangeAccent, width: 10.0),
                        ),
                        child: FortuneWheel(
                          selected: selected.stream,
                          animateFirst: false,
                          items: [
                            for (var it in items)
                              FortuneItem(
                                child: Text(HtmlUnescape().convert(it)),
                              ),
                          ],
                          indicators: [
                            FortuneIndicator(
                              alignment: Alignment.topCenter,
                              child: TriangleIndicator(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellowAccent,
                      ),
                    ),
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     spinWheel();
            //   },
            //   child: Text('Quay vòng xoay'),
            // ),
          ],
        ),
      ),
    );
  }
}

class VoucherListPage extends StatelessWidget {
  final List<dynamic>? vouchers;

  VoucherListPage({required this.vouchers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voucher List'),
      ),
      body: ListView.builder(
        itemCount: vouchers!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(vouchers!.isEmpty ? "" : vouchers![index].toString()),
          );
        },
      ),
    );
  }
}
