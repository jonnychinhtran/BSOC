import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/view/infor/infor_page_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/user_view_model.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:bsoc_book/widgets/default_button.dart';
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
                                            onPress: () {
                                              _userViewModel!
                                                  .updateUser(
                                                      userId:
                                                          item.id!.toString(),
                                                      username: item.username!,
                                                      email: item.email!,
                                                      phone:
                                                          _phoneController.text,
                                                      fullname:
                                                          _fullnameController
                                                              .text)
                                                  .then((bool value) => {
                                                        setState(() {
                                                          _isLoading = false;
                                                        }),
                                                        if (true == value)
                                                          {
                                                            WidgetHelper
                                                                .showMessageSuccess(
                                                                    context:
                                                                        context,
                                                                    content:
                                                                        'Cập nhật thông tin thành công'),
                                                            _userViewModel
                                                                ?.getInfoPage()
                                                                .then((value) {
                                                              if (value !=
                                                                  null) {
                                                                _userItem =
                                                                    value;
                                                                print(
                                                                    "User Info update done: $_userItem");
                                                              } else {
                                                                WidgetHelper.showMessageError(
                                                                    context:
                                                                        context,
                                                                    content:
                                                                        'Cập nhật thông tin thất bại');
                                                              }
                                                            }),
                                                          }
                                                      });
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
