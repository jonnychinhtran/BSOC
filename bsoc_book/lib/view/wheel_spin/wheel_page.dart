import 'dart:async';
import 'dart:math';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html_unescape/html_unescape.dart';

Map<String, dynamic>? datauser;

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
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    getUserDetail();
    getlistSpin();
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  Future<void> getUserDetail() async {
    try {
      setState(() {
        isLoading = true;
      });
      token = storage.read('accessToken');
      print(token);

      if (token == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Phiên đã hết hạn"),
              content: Text("Vui lòng đăng nhập lại."),
              actions: [
                TextButton(
                  child: Text("Đồng ý"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            );
          },
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      var response = await Dio().get('http://103.77.166.202/api/user/profile',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        datauser = response.data;
        // print(datauser!['spinTurn']);
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      // Get.snackbar("error", e.toString());
      print(e);
    }
  }

  List items = <String>[];

  Future<void> getlistSpin() async {
    try {
      setState(() {
        isLoading = true;
      });
      token = storage.read('accessToken');
      print(token);
      var response = await Dio().get('http://103.77.166.202/api/spin/list',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        items = (response.data);
        print(items);
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      // Get.snackbar("error", e.toString());
      print(e);
    }
  }

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
            content: Text(items[selectedIndex]['name'].toString()),
            actions: [
              TextButton(
                onPressed: () async {
                  storage.write('idSpin', items[selectedIndex]['id']);

                  String? token;
                  int? idSpin;
                  final box = GetStorage();
                  token = box.read('accessToken');
                  idSpin = box.read('idSpin');

                  final dio = Dio(); // Create Dio instance
                  final response = await dio.post(
                    'http://103.77.166.202/api/spin/turn/$idSpin',
                    options: Options(
                        contentType: 'application/json',
                        headers: {'Authorization': 'Bearer $token'}),
                  );
                  print(response);
                  Navigator.of(context).pop();
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
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.local_offer),
        //     onPressed: () async {
        //       final vouchers = storage.read('vouchers') ?? [];
        //       final voucherList =
        //           vouchers.map((voucher) => voucher.toString()).toList();
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => VoucherListPage(vouchers: voucherList),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: items.length > 1
          ? GestureDetector(
              onTap: () {
                datauser!['spinTurn'] == 0
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: AlertDialog(
                              title: Text('Thông báo'),
                              content: Text('Bạn đã hết lượt quay'),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Thoát'),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : spinWheel();
              },
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 255, 225, 65),
                                width: 20.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color.fromARGB(232, 232, 173, 11),
                                  width: 10.0,
                                ),
                              ),
                              child: FortuneWheel(
                                selected: selected.stream,
                                animateFirst: false,
                                items: [
                                  for (var item in items)
                                    FortuneItem(
                                      child: Text(
                                        item['name'].toString(),
                                        style: TextStyle(fontSize: 6.5),
                                      ),
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
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(232, 232, 173, 11),
                            ),
                          ),
                          Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(232, 232, 173, 11),
                            ),
                          ),
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(155, 155, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text('Đang tải dữ liệu...'),
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

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = 2
    // Use [PaintingStyle.fill] if you want the circle to be filled.
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
