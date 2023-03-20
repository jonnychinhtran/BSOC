import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 153, 195, 59),
        centerTitle: true,
        title: Text("Giới thiệu"),
      ),
      // drawer: const MenuAside(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.02),
                Text('Chào Tất Cả Mọi Người,',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: size.height * 0.02),
                Text(
                    'BSOC với tên viết tắt là B-Sale Online Customer là ứng dụng với slogan mọi thứ trong một ứng dụng. BSOC được thành lập với sứ mệnh đầu tiên là gắn kết ý niệm giữa Thầy, Cô và sinh viên thông qua những tri thức, kiến thức của Thầy Cô là tác giả của chính những quyển sách ấy.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: size.height * 0.02),
                Text(
                    'Các em có thể download, và đọc sách Online của tất cả các giáo viên trên khắp cả nước.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: size.height * 0.02),
                Text(
                    'Bên cạnh đó, chúng tôi sẽ cho ra những tính năng mới nhằm phục vụ cho việc mua bán, trao đổi những vật phẩm mà quý Thầy Cô và các bạn sinh viên có nhu cầu.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: size.height * 0.02),
                Text('Trân Trọng.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
