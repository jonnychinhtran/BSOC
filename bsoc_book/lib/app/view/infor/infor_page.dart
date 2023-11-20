import 'package:bsoc_book/app/models/user_model.dart';
import 'package:bsoc_book/app/view/infor/infor_page_view.dart';
import 'package:bsoc_book/app/view/rewards/rewards_page_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/app/view_model/user_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/app/view/about/about_page.dart';
import 'package:bsoc_book/app/view/contact/contact_page.dart';
import 'package:bsoc_book/app/view/terms/terms_page.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/resource/values/app_strings.dart';
import 'package:bsoc_book/utils/resource_values.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:bsoc_book/widgets/app_preferences.dart';
import 'package:bsoc_book/widgets/default_button.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({
    super.key,
    required this.homeViewModel,
    required this.parentViewState,
    required this.userViewModel,
  });

  final HomeViewModel homeViewModel;
  final InfoPageViewState parentViewState;
  final UserViewModel userViewModel;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  HomeViewModel? _homeViewModel;
  UserViewModel? _userViewModel;
  bool _isLoading = false;
  UserModel? _userItem;
  void goHome() {
    Application.router.navigateTo(context, Routes.app, clearStack: true);
  }

  void goLogin() {
    Application.router
        .navigateTo(context, Routes.appRouteLogin, clearStack: true);
  }

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    _userViewModel = widget.userViewModel;

    setState(() {
      _isLoading = true;
    });

    if (AppDataGlobal().accessToken != "") {
      _userViewModel?.getInfoPage().then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value != null) {
          _userItem = value;
        }
      });

      _userViewModel!.userInfoModelSubjectStream.listen((event) {
        if (event != null) {
          _userItem = event;
        }
      });
    } else {
      _userViewModel!.clearCache();
      setState(() {
        _isLoading = false;
      });
    }
    super.initState();
  }

  File? _image;

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      var formData = FormData.fromMap(
        {
          "image": await MultipartFile.fromFile(pickedImage.path),
          "userId": _userItem!.id!,
          "username": _userItem!.username!,
          "email": _userItem!.email!,
          "phone": _userItem!.phone!,
          "fullname": _userItem!.fullname!
        },
      );
      var response = await Dio().post('http://103.77.166.202/api/user/update',
          data: formData,
          options: Options(headers: {
            'Authorization': 'Bearer ${AppDataGlobal().accessToken}',
          }));
      if (response.statusCode == 200) {
        WidgetHelper.showMessageSuccess(
            context: context, content: 'Cập nhật avatar thành công');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_COLOR,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        title: const Text(
          'Thông tin tài khoản',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            goHome();
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                child: Column(
                  children: [
                    (AppDataGlobal().accessToken != '')
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              StreamBuilder(
                                  stream: _userViewModel!
                                      .userInfoModelSubjectStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      UserModel item = snapshot.data!;
                                      return Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              CircleAvatar(
                                                radius: 60.0,
                                                backgroundImage: (_image !=
                                                        null)
                                                    ? FileImage(_image!)
                                                        as ImageProvider<
                                                            Object>?
                                                    : NetworkImage(
                                                        AppDataGlobal().domain +
                                                            (_userItem
                                                                    ?.avatar ??
                                                                '')),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                              GestureDetector(
                                                onTap: _pickImageFromGallery,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color:
                                                        AppColors.PRIMARY_COLOR,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _userItem!.username ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: ResourceValues
                                                          .FONT_SIZE_MEDIUM),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Card(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: const Text(
                                                    'Mã tài khoản:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  trailing: Text(
                                                      _userItem!.id.toString()),
                                                ),
                                                const Divider(
                                                  height: 1,
                                                  endIndent: 0,
                                                  color: Color.fromARGB(
                                                      255, 87, 87, 87),
                                                ),
                                                ListTile(
                                                  title: const Text(
                                                    'Họ Tên:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  trailing: Text(
                                                      _userItem!.fullname!),
                                                ),
                                                const Divider(
                                                  height: 2,
                                                  endIndent: 0,
                                                  color: Color.fromARGB(
                                                      255, 87, 87, 87),
                                                ),
                                                ListTile(
                                                  title: const Text(
                                                    'Email:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  trailing:
                                                      Text(_userItem!.email!),
                                                ),
                                                const Divider(
                                                  height: 2,
                                                  endIndent: 0,
                                                  color: Color.fromARGB(
                                                      255, 87, 87, 87),
                                                ),
                                                ListTile(
                                                  title: const Text(
                                                    'Số điện thoại:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  trailing: Text(_userItem!
                                                          .phone!
                                                          .toString() ??
                                                      'N/A'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RewardPageView(
                                                          userModel: item,
                                                          homeViewModel:
                                                              _homeViewModel!,
                                                        )),
                                              );
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 500,
                                                    height: 80,
                                                    decoration: const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 138, 175, 52),
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        8.0))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15.0,
                                                              right: 8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Điểm thưởng',
                                                            style: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Container(
                                                              height: 70,
                                                              child: Image.asset(
                                                                  'assets/images/gift.png'))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 500,
                                                    height: 100,
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                bottom: Radius
                                                                    .circular(
                                                                        8.0))),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 16.0,
                                                                top: 20.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            _userItem!.pointForClaimBook ==
                                                                    0
                                                                ? const Text(
                                                                    '0 Điểm',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black),
                                                                  )
                                                                : Text(
                                                                    '${_userItem!.pointForClaimBook!} Điểm',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                            SizedBox(
                                                                height:
                                                                    size.height *
                                                                        0.02),
                                                            const Text(
                                                              'Mỗi bài thi đạt 100% sẽ được tặng 01 điểm',
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Card(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                const Divider(
                                                  height: 2,
                                                  endIndent: 0,
                                                  color: Color.fromARGB(
                                                      255, 87, 87, 87),
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.info),
                                                  title: const Text(
                                                    'Cập nhật thông tin',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  trailing: const Icon(Icons
                                                      .keyboard_arrow_right),
                                                  onTap: () {
                                                    widget.parentViewState
                                                        .jumpPageInfoUpdate();
                                                  },
                                                ),
                                                const Divider(
                                                  height: 2,
                                                  endIndent: 0,
                                                  color: Color.fromARGB(
                                                      255, 87, 87, 87),
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.shield),
                                                  title: const Text(
                                                    'Đổi mật khẩu',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  trailing: const Icon(Icons
                                                      .keyboard_arrow_right),
                                                  onTap: () {
                                                    widget.parentViewState
                                                        .jumpPageChangePass();
                                                  },
                                                ),
                                                const Divider(
                                                  height: 2,
                                                  endIndent: 0,
                                                  color: Color.fromARGB(
                                                      255, 87, 87, 87),
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.delete),
                                                  title: const Text(
                                                    'Xóa tài khoản',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.red),
                                                  ),
                                                  trailing: const Icon(Icons
                                                      .keyboard_arrow_right),
                                                  onTap: () async {
                                                    _deletePopup();
                                                  },
                                                ),
                                                const Divider(
                                                  height: 2,
                                                  endIndent: 0,
                                                  color: Color.fromARGB(
                                                      255, 87, 87, 87),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .shade400))),
                                                  child: ListTile(
                                                    title: const Text(
                                                        'Giới thiệu'),
                                                    trailing: const Icon(
                                                        Icons.arrow_right),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AboutPage()),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .shade400))),
                                                  child: ListTile(
                                                    title:
                                                        const Text('Liên hệ'),
                                                    trailing: const Icon(
                                                        Icons.arrow_right),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const ContactPage()),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                  child: ListTile(
                                                    title: const Text(
                                                        'Điều khoản sử dụng'),
                                                    trailing: const Icon(
                                                        Icons.arrow_right),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const TermsPage()),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _logoutPopup();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red[100],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                minimumSize: const Size(
                                                    double.infinity, 50),
                                              ),
                                              child: const Text(
                                                'Đăng xuất',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${AppStrings.APP_NAME} 1.1.4",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF8A8A8A),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 15.0),
                                child: Text(
                                  'Bạn cần đăng nhập hoặc đăng ký để xem thông tin tài khoản.',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: size.height * 0.02),
                              ElevatedButton(
                                onPressed: () {
                                  goLogin();
                                },
                                child: Container(
                                  width: 190,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: const Text(
                                    'Đăng nhập hoặc Đăng ký',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.04),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.grey.shade400),
                                        bottom: BorderSide(
                                            color: Colors.grey.shade400))),
                                child: ListTile(
                                  title: const Text('Giới thiệu'),
                                  trailing: const Icon(Icons.arrow_right),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AboutPage()),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade400))),
                                child: ListTile(
                                  title: const Text('Liên hệ'),
                                  trailing: const Icon(Icons.arrow_right),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ContactPage()),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade400))),
                                child: ListTile(
                                  title: const Text('Điều khoản sử dụng'),
                                  trailing: const Icon(Icons.arrow_right),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TermsPage()),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${AppStrings.APP_NAME} 1.1.4",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8A8A8A),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                  ],
                ),
              )),
            ),
            (true == _isLoading)
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                    color: AppColors.PRIMARY_COLOR,
                    secondRingColor: Colors.black,
                    thirdRingColor: Colors.purple,
                    size: 30,
                  ))
                : Container(),
          ],
        ),
      ),
    );
  }

  _deletePopup() {
    WidgetHelper.showPopupMessage(
      context: context,
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Text(
              'Bạn có chắc chắn muốn xóa tài khoản?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResourceValues.FONT_SIZE_MEDIUM),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  child: DefaultButton(
                onPress: () {
                  Navigator.of(context).pop();
                },
                title: 'Không',
                borderWidth: 1.5,
                titleColor: AppColors.COLOR_ICON_TRASH,
                borderColor: AppColors.COLOR_ICON_TRASH,
              )),
              const SizedBox(
                width: 15,
              ),
              Expanded(child: StatefulBuilder(builder: (context, setStatef) {
                return DefaultButton(
                  onPress: () async {
                    Navigator.of(context).pop();
                    try {
                      var response = await Dio().post(
                          'http://103.77.166.202/api/user/delete',
                          options: Options(headers: {
                            'accept': '*/*',
                            'Authorization':
                                'Bearer ${AppDataGlobal().accessToken}}'
                          }));
                      if (response.statusCode == 200) {
                        var data = response.data;
                        print(data);
                        AppDataGlobal().setAccessToken(accessToken: '');
                        AppPreferences().setLoggedIn(isLoggedIn: false);
                        AppDataGlobal().userLogout();
                        Application.router
                            .navigateTo(context, Routes.app, clearStack: true);
                      } else {
                        WidgetHelper.showMessageError(
                            context: context,
                            content: 'Xóa tải khoản lỗi. Thử lại.');
                      }
                      print("res: ${response.data}");
                    } catch (e) {
                      print(e);
                    }
                  },
                  title: 'Có',
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  titleColor: Colors.white,
                );
              }))
            ],
          )
        ],
      ),
    );
  }

  _logoutPopup() {
    WidgetHelper.showPopupMessage(
      context: context,
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Text(
              'Bạn có chắc chắn muốn đăng xuất?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResourceValues.FONT_SIZE_MEDIUM),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  child: DefaultButton(
                onPress: () {
                  Navigator.of(context).pop();
                },
                title: 'Không',
                borderWidth: 1.5,
                titleColor: AppColors.COLOR_ICON_TRASH,
                borderColor: AppColors.COLOR_ICON_TRASH,
              )),
              const SizedBox(
                width: 15,
              ),
              Expanded(child: StatefulBuilder(builder: (context, setStatef) {
                return DefaultButton(
                  onPress: () async {
                    Navigator.of(context).pop();
                    AppDataGlobal().setAccessToken(accessToken: '');
                    AppPreferences().setLoggedIn(isLoggedIn: false);
                    AppDataGlobal().userLogout();
                    Application.router
                        .navigateTo(context, Routes.app, clearStack: true);
                  },
                  title: 'Có',
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  titleColor: Colors.white,
                );
              }))
            ],
          )
        ],
      ),
    );
  }
}
