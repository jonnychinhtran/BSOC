import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/view/infor/infor_page_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/user_view_model.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:bsoc_book/widgets/default_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoUpdatePage extends StatefulWidget {
  const InfoUpdatePage({
    super.key,
    required this.homeViewModel,
    required this.parentViewState,
    required this.userViewModel,
  });

  final HomeViewModel homeViewModel;
  final InfoPageViewState parentViewState;
  final UserViewModel userViewModel;

  @override
  State<InfoUpdatePage> createState() => _InfoUpdatePageState();
}

class _InfoUpdatePageState extends State<InfoUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
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
          _fullnameController.text = event.fullname.toString();
          _emailController.text = event.email.toString();
          _phoneController.text = event.phone.toString();
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: Text('Cập nhật thông tin'),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            widget.parentViewState.jumpPageInfo();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: _userViewModel!.userInfoModelSubjectStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                UserModel item = snapshot.data!;
                print(item.username!);
                print(item.id!);
                return Column(
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
                                    SizedBox(height: size.height * 0.02),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 0, bottom: 4),
                                        child: Text(
                                          'Họ và Tên',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _fullnameController,
                                      // validator: (value) {
                                      //   return (value == null || value.isEmpty)
                                      //       ? 'Vui lòng nhập lại họ tên'
                                      //       : null;
                                      // },
                                      decoration: InputDecoration(
                                          hintText: item.fullname.toString(),
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 0, bottom: 4),
                                        child: Text(
                                          'Email',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Vui lòng nhập email';
                                        }
                                        if (!RegExp(
                                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                            .hasMatch(value)) {
                                          return 'Nhập sai định dạng email';
                                        }
                                        return null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r" "))
                                      ],
                                      decoration: InputDecoration(
                                          hintText: "Email",
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 0, bottom: 4),
                                        child: Text(
                                          'Số điện thoại',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _phoneController,
                                      // validator: (value) {
                                      //   if (value == "") {
                                      //     return null;
                                      //   }
                                      //   if (value!.isEmpty) {
                                      //     return 'Vui lòng nhập Số điện thoại';
                                      //   }
                                      //   return null;
                                      // },
                                      // maxLength: 20,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: item.phone.toString(),
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                                    SizedBox(height: size.height * 0.04),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: DefaultButton(
                                            onPress: () async {
                                              var formData = FormData.fromMap(
                                                {
                                                  "userId": item.id!.toString(),
                                                  "fullname":
                                                      _fullnameController.text,
                                                  "username":
                                                      item.username!.toString(),
                                                  "email":
                                                      _emailController.text,
                                                  "phone":
                                                      _phoneController.text,
                                                },
                                              );
                                              var response = await Dio().post(
                                                  'http://103.77.166.202/api/user/update',
                                                  data: formData,
                                                  options: Options(headers: {
                                                    'Authorization':
                                                        'Bearer ${AppDataGlobal().accessToken}',
                                                  }));

                                              if (response.statusCode == 200) {
                                                _userViewModel?.getInfoPage();
                                                WidgetHelper.showMessageSuccess(
                                                    context: context,
                                                    content:
                                                        'Cập nhật thành công.');
                                              } else {
                                                WidgetHelper.showMessageError(
                                                    context: context,
                                                    content:
                                                        'Cập nhật thất bại. Thử lại.');
                                              }
                                            },
                                            titleColor: Colors.white,
                                            backgroundColor:
                                                AppColors.PRIMARY_COLOR,
                                            title: 'CẬP NHẬT',
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
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
