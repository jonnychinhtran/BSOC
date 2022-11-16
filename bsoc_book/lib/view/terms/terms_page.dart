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
                'Cảm ơn bạn đã chọn sản phẩm của chúng tôi. BSOC Book là sản phẩm của Startup Hoa Le, được xây dựng tại bởi nhóm lập trình B4USolution Việt Nam. Các điều khoản dịch vụ này là hợp đồng giữa bạn và BSOC Book. Bằng cách sử dụng BSOC Book, tạo tài khoản của bạn và sử dụng ứng dụng của chúng tôi để đăng tải nhiều nội dung khác nhau lên cộng đồng, bao gồm đăng bài ( đăng sách nếu có) nhận xét , đánh giá và tin nhắn hoặc để truy cập và xem nhận xét của người dùng.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
              '1. Quy định chung',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'Điều khoản Sử dụng quy định các điều khoản ràng buộc bạn khi sử dụng Dịch vụ của BSOC Book. Thuật ngữ "Bạn" và/hoặc "Người sử dụng" sau đây được gọi chung để chỉ tới những người sử dụng Dịch vụ của BSOC Book. Vui lòng nghiên cứu kỹ và lưu lại một bản Điều khoản Sử dụng này.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'Bằng việc tải phần mềm và sử dụng Dịch vụ của chúng tôi, Bạn đồng ý bị ràng buộc với Điều khoản Sử dụng này. Nếu Bạn không đồng ý bị ràng buộc với Điều khoản Sử dụng này. Bạn nên chấm dứt ngay lập tức việc sử dụng Dịch vụ của <App>.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
              '2. Thay đổi điều khoản sử dụng',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'BSOC Book là tổ chức duy nhất có toàn quyền thay đổi, chỉnh sửa, thêm vào hoặc xóa bỏ các Điều Khoản và Điều Kiện bất kỳ lúc nào bằng cách cập nhật nội dung của ứng dụng, và có thể báo trước hoặc không báo trước cho bạn các thay đổi đó. ',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'Do vậy, mỗi khi truy cập vào ứng dụng này, bạn nên kiểm tra các Điều Khoản và Điều Kiện sử dụng một cách định kỳ và cẩn thận. Khi bạn sử dụng ứng dụng sau khi chỉnh sửa nội dung sẽ được xem là bạn thừa nhận và đồng ý với các nội dung chỉnh sửa này.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
              '3. Bảo mật thông tin người dùng',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'Bạn không thể  sử dụng Dịch vụ mà không đăng ký tài khoản. Để tận dụng tối đa nền tảng, bạn cần đăng ký, chọn tên tài khoản và đặt mật khẩu.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
                'Bạn chịu trách nhiệm về tất cả hoạt động trên tài khoản của mình và giữ bí mật mật khẩu của mình. Nếu bạn chia sẻ thông tin tài khoản của mình với bất kỳ ai, người đó có thể kiểm soát tài khoản và chúng tôi không thể xác định ai là chủ tài khoản thích hợp. Chúng tôi sẽ không có bất kỳ trách nhiệm pháp lý nào đối với bạn (hoặc bất kỳ ai mà bạn chia sẻ thông tin tài khoản của mình) do hành động của bạn hoặc họ trong những trường hợp đó. Nếu bạn phát hiện ra ai đó đã sử dụng tài khoản của mình khi chưa được bạn cho phép, bạn nên báo cáo việc đó tại email: hoale@b4usolution.com',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
              '4. Nội dung của bạn',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'Trước khi đăng bất kỳ nội dung nào lên BSOC Book, điều quan trọng là bạn phải đọc “Nguyên tắc nội dung” của chúng tôi. Nếu nội dung của bạn không tuân thủ các nguyên tắc này, nội dung đó có thể bị xóa bất kỳ lúc nào.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'Để tạo ra một không gian hòa nhập và tôn trọng, chúng tôi muốn đảm bảo rằng người dùng của chúng tôi biết loại nội dung họ sẽ khám phá cũng như nội dung họ có thể hoặc không thể đăng.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'Trước khi bạn bắt đầu bình luận hay đăng bài ( nếu có) , vui lòng xem qua các nguyên tắc sau:',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
                '-	Không chứa các nội dung bị cấm như 18+, tự tử, làm hại bản thân hoặc người khác, bạo lực, căm thù, cực đoan…',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
                '-	Chúng tôi có quyền xóa bất kỳ nội dung nào mà chúng tôi thấy không phù hợp. Bất kỳ nội dung nào có thể gây rủi ro cho cộng đồng của chúng tôi sẽ bị xóa ( các hành vi ở trên)',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
                '-	Phương tiện trên ứng dụng bao gồm hình ảnh, video, gif và clip âm thanh. Để giúp giữ cho BSOC Book trở thành một không gian an toàn cho mọi người khám phá nội dung, chúng tôi có thể xóa những hình ảnh không tuân theo nguyên tác của chúng tôi .',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
                '-	Bất kỳ nội dung nào quảng cáo sản phẩm hoặc dịch vụ không liên quan <App>  đều không được phép và sẽ bị xóa',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
              '5. Quyền của chúng tôi trong dịch vụ',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'Chúng tôi bảo lưu tất cả các quyền đối với giao diện ứng dụng cũng như đối với nội dung của chúng tôi. Bạn không được sao chép hoặc điều chỉnh bất kỳ phần nào trong mã hoặc các yếu tố thiết kế trực quan của chúng tôi (bao gồm cả logo) mà không có sự cho phép rõ ràng bằng văn bản từ BSOC Book hoặc như được quy định trong điều khoản này. .',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'BSOC Book  có thể thay đổi, chấm dứt hoặc hạn chế quyền truy cập vào bất kỳ khía cạnh nào của Dịch vụ bất cứ lúc nào mà không cần thông báo trước. Chúng tôi có thể xóa bất kỳ nội dung nào bạn đăng hoặc gửi vì bất kỳ lý do gì. BSOC Book có thể truy cập, đọc, lưu giữ và tiết lộ bất kỳ thông tin nào mà chúng tôi tin rằng cần thiết để  đáp ứng mọi luật, quy định, quy trình pháp lý hiện hành hoặc yêu cầu của chính phủ,  thực thi Điều khoản dịch vụ, bao gồm cả việc điều tra các vi phạm tiềm ẩn,  phát hiện, ngăn chặn hoặc giải quyết các vấn đề gian lận, bảo mật hoặc kỹ thuật, phản hồi các yêu cầu hỗ trợ của người dùng hoặc bảo vệ quyền, tài sản hoặc sự an toàn của Dịch vụ, người dùng và công chúng.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.02),
            Text(
              '6. Xóa tài khoản của bạn',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'Bạn có thể xóa vĩnh viễn tài khoản của mình. Nếu bạn đóng tài khoản của mình, trước tiên tài khoản đó sẽ bị hủy kích hoạt và sau đó bị xóa. Khi tài khoản của bạn bị vô hiệu hóa, trong khi nó không thể xem được trên BSOC Book, tất cả các nhận xét và bài đăng trên bảng tin của bạn trên cộng đồng sẽ vẫn còn ngoại trừ việc chúng sẽ được ẩn danh.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
                'Chúng tôi có thể đình chỉ hoặc chấm dứt tài khoản của bạn hoặc ngừng cung cấp cho bạn tất cả hoặc một phần Dịch vụ bất kỳ lúc nào và vì bất kỳ lý do gì mà chúng tôi cho là phù hợp. Chúng tôi sẽ nỗ lực hợp lý để thông báo cho bạn theo địa chỉ email được liên kết với tài khoản của bạn hoặc vào lần tiếp theo bạn cố gắng truy cập vào tài khoản của mình.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
            Text(
              '7.  Liên hệ',
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
                'Nếu Bạn có bất kỳ câu hỏi nào về Điều khoản Sử dụng này, về hoạt động củaứng dụng , hoặc sự kết nối của Bạn với BSOC Book, vui lòng liên hệ với chúng tôi qua email: hoale@b4usolution.com Tất cả các vấn đề hoặc mâu thuẫn sẽ được giải quyết nhanh chóng và hợp lý.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14)),
            SizedBox(height: size.height * 0.01),
          ],
        )),
      )),
    );
  }
}
