import 'package:bsoc_book/model/auth/register_response.dart';
import 'package:bsoc_book/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class GetAuth extends GetxController {
  final RxBool loading = false.obs;
  final RxString exception = ''.obs;
  Rx<RegisterResponse> registerModel =
      RegisterResponse(id: 0, token: 'sdfsfd').obs;
  TextEditingController username = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');

  Future<void> registerUser() async {
    loading.value = true;
    try {
      var res = await AuthService()
          .registerUser(username.text.toString(), password.text.toString());
      registerModel.value = res;
      loading.value = false;
    } catch (e) {
      exception.value = e.toString();
    }
  }
}
