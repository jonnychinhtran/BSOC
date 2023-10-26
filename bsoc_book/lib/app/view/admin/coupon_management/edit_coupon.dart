import 'package:flutter/material.dart';

class EditCouponPage extends StatelessWidget {
  const EditCouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: Text('Chỉnh sửa mã Coupon'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                // key: _formKey,
                child: SizedBox(
              width: size.width,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.85,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: size.height * 0.02),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0, bottom: 4),
                            child: Text(
                              'Tên mã',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'BLACKFRIDAY12312',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        SizedBox(height: size.height * 0.02),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0, bottom: 4),
                            child: Text(
                              'Mô tả',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Giảm giá thứ 6',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        SizedBox(height: size.height * 0.02),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0, bottom: 4),
                            child: Text(
                              'Số lượng mã',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: '6',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        SizedBox(height: size.height * 0.02),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0, bottom: 4),
                            child: Text(
                              'Giảm giá %',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: '20',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        SizedBox(height: size.height * 0.02),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0, bottom: 4),
                            child: Text(
                              'Ngày hết hạn',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: '20/03/2023',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        SizedBox(height: size.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () => {},
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          Color.fromARGB(255, 153, 195, 59),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 40, vertical: 15)
                                    ),
                                    child: const Text(
                                      "Cập nhật",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.deepOrange[300],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: const Text(
                                    "Hủy",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
