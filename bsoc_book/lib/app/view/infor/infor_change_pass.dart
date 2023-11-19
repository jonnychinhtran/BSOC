import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/view/infor/infor_page_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/user_view_model.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class InfoChangePass extends StatefulWidget {
  const InfoChangePass({
    super.key,
    required this.homeViewModel,
    required this.parentViewState,
    required this.userViewModel,
  });

  final HomeViewModel homeViewModel;
  final InfoPageViewState parentViewState;
  final UserViewModel userViewModel;

  @override
  State<InfoChangePass> createState() => _InfoChangePassState();
}

class _InfoChangePassState extends State<InfoChangePass> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentpasswordController =
      TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  HomeViewModel? _homeViewModel;
  UserViewModel? _userViewModel;
  bool _isLoading = false;
  UserModel? _userItem;

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    _userViewModel = widget.userViewModel;

    setState(() {
      _isLoading = true;
    });

    if (AppDataGlobal().accessToken != "") {
      _userViewModel?.getInfoPage().then((value) {
        if (value != null) {
          _userItem = value;
          print("User Info 2222: $_userItem");
        }
      });
      _userViewModel!.userInfoModelSubjectStream.listen((event) {
        if (event != null) {
          _usernameController.text = event.username.toString();
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: Text('Đổi mật khẩu'),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            widget.parentViewState.jumpPageInfo();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: SizedBox(
                  width: size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width * 0.85,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: size.height * 0.04),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0, bottom: 4),
                                child: Text(
                                  'Mật khẩu hiện tại',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _currentpasswordController,
                              obscureText: true,
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? 'Vui lòng nhập mật khẩu hiện tại'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Mật khẩu hiện tại",
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
                                  'Mật khẩu mới',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _newpasswordController,
                              obscureText: true,
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? 'Vui lòng nhập mật khẩu hiện tại'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Mật khẩu mới",
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
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        var formData = {
                                          "username": _usernameController.text,
                                          "currPassword":
                                              _currentpasswordController.text,
                                          "newPassword":
                                              _newpasswordController.text,
                                        };

                                        try {
                                          var response = await Dio().post(
                                              'http://103.77.166.202/api/user/changepass',
                                              data: formData,
                                              options: Options(headers: {
                                                'Content-Type':
                                                    'application/json',
                                                'Authorization':
                                                    'Bearer ${AppDataGlobal().accessToken}',
                                              }));
                                          if (response.statusCode == 200) {
                                            widget.parentViewState
                                                .jumpPageInfo();
                                            WidgetHelper.showMessageSuccess(
                                                context: context,
                                                content:
                                                    'Thay đổi mật khẩu thành công.');
                                          } else {
                                            WidgetHelper.showMessageError(
                                                context: context,
                                                content:
                                                    'Thay đổi mật khẩu thất bại. Thử lại.');
                                          }
                                          print("res: ${response.data}");
                                        } catch (e) {
                                          print(e);
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.PRIMARY_COLOR,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15)),
                                    child: const Text(
                                      "Cập nhật",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
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
