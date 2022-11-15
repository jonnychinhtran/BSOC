import 'package:bsoc_book/view/widgets/menu_aside.dart';
import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 153, 195, 59),
        centerTitle: true,
        title: Text('Điều khoản sử dụng'),
      ),
      drawer: MenuAside(),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Text(
              '1. Cung cấp thông tin',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'BSOC Book tuân thủ nghiêm ngặt các chính sách lấy và lưu giữ thông tin từ Apple và Google cho ứng dụng của mình. Khách hàng phải chịu trách nhiệm về việc khai báo, bảo quản thông tin tài khoản, BSOC Book hay các ứng dụng khác liên quan không bao giờ yêu cầu Quý khách cung cấp thông tin nhạy cảm như mật khẩu hoặc các dữ liệu được đánh dấu riêng tư.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'Ứng dụng BSOC Book là ứng dụng chạy trên nền các hệ điều hành điện thoại',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
              '2. Bảo mật thông tin',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'Việc thu thập thông tin cá nhân của bạn nhằm giúp chúng tôi có điều kiện để phục vụ bạn ngày một tốt hơn. BSOC Book cam kết sử dụng thông tin của bạn một cách hợp lý và bảo mật nhất.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'Ngoài ra, bạn có trách nhiệm phải tự bảo quản thông tin tài khoản (thông tin đăng nhập, mật khẩu). BSOC Book sẽ không chịu trách nhiệm đối với thông tin bị thất thoát do lỗi từ bạn.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
              '3. Chia sẻ thông tin',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'Chúng tôi sẽ không chia sẻ thông tin của bạn cho bất kỳ bên thứ ba nào khác nếu chưa có sự đồng ý của bạn, trừ trường hợp do cơ quan quản lý yêu cầu để đảm bảo sự tuân thủ các quy định của pháp luật và/hoặc trong những trường chúng tôi nhận thấy rằng việc cung cấp thông tin tài khoản và những thông tin cá nhân khác là phù hợp với luật pháp nhằm bảo vệ quyền lợi của BSOC Book và các bên thứ ba khác (nếu có).',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
              '4. Quy tắc ứng xử',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'Bạn tuyệt đối không được sử dụng bất kỳ chương trình, công cụ hay hình thức nào khác để can thiệp vào hệ thống hay làm thay đổi cấu trúc dữ liệu.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'Khi giao tiếp, nhận xét và đánh giá bất kỳ sản phẩm hoặc nhận xét của người khác, bạn không được sử dụng từ ngữ khiếm nhã, quấy rối, chửi bới, làm phiền hay có bất kỳ hành vi thiếu văn hoá nào khác.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'Không bàn luận các vấn đề liên quan đến tôn giao, chính trị, giới tính hoặc các vấn đề nhạy cảm khác, không có các hành vi tuyên truyền, chống phá và xuyên tạc chính quyền. ',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
              '5.  Thông tin liên hệ',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'BSOC Book có thể thay đổi, bổ sung hoặc sửa chữa thỏa thuận này bất cứ lúc nào và sẽ công bố rõ trong ứng dụng.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'Trong bất kỳ trường hợp có thắc mắc, góp ý nào liên quan đến điều khoản sử dụng của BSOC Book, vui lòng liên hệ với chúng tôi qua email: hoale@b4usolution.com  để được phúc đáp, giải quyết thắc mắc trong thời gian sớm nhất.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
          ],
        )),
      )),
    );
  }
}
