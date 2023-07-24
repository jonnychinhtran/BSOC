import 'dart:async';
import 'dart:math';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    } else if (datauser!['spinTurn'] == 0) {
      setState(() {
        isSpinning = false;
      });
    }
  }

  // void showResultDialog(int selectedIndex) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: AlertDialog(
  //           title: Text('Thông báo'),
  //           content: Text(items[selectedIndex]['name'].toString()),
  //           actions: [
  //             TextButton(
  //               onPressed: () async {
  // storage.write('idSpin', items[selectedIndex]['id']);

  // String? token;
  // int? idSpin;
  // final box = GetStorage();
  // token = box.read('accessToken');
  // idSpin = box.read('idSpin');

  // final dio = Dio(); // Create Dio instance
  // final response = await dio.post(
  //   'http://103.77.166.202/api/spin/turn/$idSpin',
  //   options: Options(
  //       contentType: 'application/json',
  //       headers: {'Authorization': 'Bearer $token'}),
  // );
  // print(response);
  // Navigator.of(context).pop();
  // Navigator.push(context,
  //     MaterialPageRoute(builder: (context) => WheelPage()));
  //               },
  //               child: Text('Thu thập ngay'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void showResultDialog(int selectedIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.only(left: 0.0, right: 0.0),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 18.0,
                  ),
                  margin: EdgeInsets.only(top: 3.0, right: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 0.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: new Text(items[selectedIndex]['name'].toString(),
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black)),
                      ) //
                          ),
                      // SizedBox(height: 24.0),
                      // InkWell(
                      // child: Container(
                      //     padding: EdgeInsets.only(top: 15.0,bottom:15.0),
                      //     decoration: BoxDecoration(
                      //     color:Colors.white,
                      //     borderRadius: BorderRadius.only(
                      //         bottomLeft: Radius.circular(16.0),
                      //         bottomRight: Radius.circular(16.0)),
                      //     ),
                      //     child:  Text(
                      //     "OK",
                      //     style: TextStyle(color: Colors.blue,fontSize: 25.0),
                      //     textAlign: TextAlign.center,
                      //     ),
                      // ),
                      // onTap:(){
                      //     Navigator.pop(context);
                      // },
                      // )
                    ],
                  ),
                ),
                Positioned(
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () async {
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
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  WheelPage(),
                        ),
                      );
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 14.0,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        // return AlertDialog(
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Container(),
        //       Container(),
        //       GestureDetector(
        //         onTap: () async {
        //           // storage.write('idSpin', items[selectedIndex]['id']);

        //           // String? token;
        //           // int? idSpin;
        //           // final box = GetStorage();
        //           // token = box.read('accessToken');
        //           // idSpin = box.read('idSpin');

        //           // final dio = Dio(); // Create Dio instance
        //           // final response = await dio.post(
        //           //   'http://103.77.166.202/api/spin/turn/$idSpin',
        //           //   options: Options(
        //           //       contentType: 'application/json',
        //           //       headers: {'Authorization': 'Bearer $token'}),
        //           // );
        //           // print(response);
        //           Navigator.pushReplacement(
        //             context,
        //             PageRouteBuilder(
        //               transitionDuration: Duration.zero,
        //               pageBuilder: (context, animation, secondaryAnimation) =>
        //                   WheelPage(),
        //             ),
        //           );
        //         },
        //         child: Container(
        //           alignment: FractionalOffset.topRight,
        //           child: GestureDetector(
        //             child: SizedBox(
        //               width: 30,
        //               child: Image.asset(
        //                 'assets/images/close.png',
        //               ),
        //             ),
        //             onTap: () async {
        //               // storage.write('idSpin', items[selectedIndex]['id']);

        //               // String? token;
        //               // int? idSpin;
        //               // final box = GetStorage();
        //               // token = box.read('accessToken');
        //               // idSpin = box.read('idSpin');

        //               // final dio = Dio(); // Create Dio instance
        //               // final response = await dio.post(
        //               //   'http://103.77.166.202/api/spin/turn/$idSpin',
        //               //   options: Options(
        //               //       contentType: 'application/json',
        //               //       headers: {'Authorization': 'Bearer $token'}),
        //               // );
        //               // print(response);
        //               Navigator.pushReplacement(
        //                 context,
        //                 PageRouteBuilder(
        //                   transitionDuration: Duration.zero,
        //                   pageBuilder:
        //                       (context, animation, secondaryAnimation) =>
        //                           WheelPage(),
        //                 ),
        //               );
        //             },
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        //   content: Container(
        //       child: Text(
        //     items[selectedIndex]['name'].toString(),
        //     textAlign: TextAlign.center,
        //     style: TextStyle(color: Colors.black),
        //   )),
        //   backgroundColor: Colors.white, // Set red background color
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        //   ),
        // );
      },
    ).timeout(Duration(seconds: 30), onTimeout: () async {
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
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) => WheelPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        // backgroundColor: Colors.grey[300],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Stack(
            children: <Widget>[
              // Stroked text as border.
              Text(
                'Vòng Xoay May Mắn',
                style: TextStyle(
                  fontSize: 20,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = Colors.blue.shade700,
                ),
              ),
              // Solid text as fill.
              Text(
                'Vòng Xoay May Mắn',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
          leading: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/back.png',
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              }),
          actions: [
            GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/list.png',
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VoucherListPage()));
                }),
          ],
        ),
        body: items.length > 1
            ? Stack(children: [
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bgspin.jpg'),
                        fit: BoxFit.cover,
                      ),
                    )),
                SafeArea(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 120.0, top: 135.0),
                        child: SizedBox(
                          child: Text(
                            datauser?['spinTurn'] == 0
                                ? 'Bạn còn 0 lượt quay'
                                : 'Bạn còn ' +
                                    datauser!['spinTurn'].toString() +
                                    ' lượt quay',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ),
                      ),
                      GestureDetector(
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
                                          color:
                                              Color.fromARGB(255, 255, 225, 65),
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
                                            color: Color.fromARGB(
                                                232, 232, 173, 11),
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
                                                  style:
                                                      TextStyle(fontSize: 6.7),
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
                                        color:
                                            Color.fromARGB(232, 232, 173, 11),
                                      ),
                                    ),
                                    Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color.fromARGB(232, 232, 173, 11),
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
                      ),
                    ],
                  ),
                ),
              ])
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class VoucherListPage extends StatefulWidget {
  @override
  State<VoucherListPage> createState() => _VoucherListPageState();
}

class _VoucherListPageState extends State<VoucherListPage> {
  bool isLoading = true;
  List? voucherList;
  int? itemVoucher;
  Future<void> getVoucherList() async {
    try {
      final box = GetStorage();
      String? token;
      token = box.read('accessToken');

      setState(() {
        isLoading = true;
      });

      var response = await Dio().get('http://103.77.166.202/api/user/voucher',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        itemVoucher = response.data['pointForClaimBook'];
        voucherList = response.data['listVoucher'];
        print(voucherList);
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

  @override
  void initState() {
    getVoucherList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voucher List'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/images/point.png'),
                Container(
                  margin: EdgeInsets.only(left: 8.0),
                  child: Text(
                    itemVoucher == null ? '0' : itemVoucher.toString(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: getVoucherList == ''
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
              color: Color.fromARGB(255, 138, 175, 52),
              secondRingColor: Colors.black,
              thirdRingColor: Colors.purple,
              size: 30,
            ))
          : ListView.builder(
              itemCount: voucherList != null ? voucherList!.length : null,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(voucherList != null
                      ? voucherList![index]['name'].toString()
                      : ""),
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
