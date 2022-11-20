import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadAvatar extends StatefulWidget {
  const UploadAvatar({super.key});

  @override
  State<UploadAvatar> createState() => _UploadAvatarState();
}

class _UploadAvatarState extends State<UploadAvatar> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  String? token;
  String? idUser;
  String? username;
  String? emailUser;
  String? phoneUser;
  String? fullnameUser;

  _getFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _uploadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idUser = prefs.getString('idInforUser');
    username = prefs.getString('username');
    emailUser = prefs.getString('emailuser');
    phoneUser = prefs.getString('phoneUser');

    var formData = FormData.fromMap(
      {
        "image": await MultipartFile.fromFile(imageFile!.path),
        "userId": idUser.toString(),
        "fullname": username,
        "username": username,
        "email": emailUser,
        "phone": phoneUser.toString(),
      },
    );
    var response = await Dio().post('http://103.77.166.202/api/user/update',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
    print(response.toString());
    print(response.data);
    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  void initState() {
    _uploadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: Text('Cập nhật ảnh đại diện'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageFile == null
                ? const Icon(Icons.add_photo_alternate)
                : Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _uploadImage();
                          },
                          child: const Text('Đăng hình đại diện'))
                    ],
                  ),
            ElevatedButton(
                onPressed: () {
                  _getFromGallery();
                },
                child: const Text("Chọn hình đại diện"))
          ],
        ),
      ),
    );
  }
}
