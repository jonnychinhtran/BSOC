import 'package:bsoc_book/view/widgets/menu_aside.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  _sendingMails() async {
    var url = Uri.parse("mailto:info@b4usolution.com");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sendingCall() async {
    var url = Uri.parse("tel:+840989214285");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      'Liên hệ:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 10),
                    child: Text(
                        'B4USolution là công ty TNHH Tư vấn đào tạo công nghệ thông tin, là đơn vị tư vấn giải pháp công nghệ, đào tạo lập trình viên chuyên nghiệp, kiểm thử phần mềm. Bên cạnh đó, đơn vị chúng tôi hỗ trợ sinh viên, học viên như review CV, giới thiệu sinh viên, học viên sau khi tốt nghiệp và vượt qua kỳ thi cuối khóa của đơn vị chúng tôi vào các công ty phần mềm trong và ngoài nước.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16.5)),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text('Ms: Hoa Le',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 18)),
                  ),
                  SizedBox(height: size.height * 0.01),
                  TextButton(
                    child: Text('Zalo/Phone: +840989214285',
                        style: TextStyle(fontSize: 18)),
                    style: ButtonStyle(),
                    onPressed: _sendingCall,
                  ),
                  TextButton(
                    child: Text('Email: info@b4usolution.com',
                        style: TextStyle(fontSize: 18)),
                    style: ButtonStyle(),
                    onPressed: _sendingMails,
                  ),
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
