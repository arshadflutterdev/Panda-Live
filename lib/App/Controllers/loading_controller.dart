import 'dart:async';

import 'package:get/get.dart';

class LoadingController extends GetxController {
  RxBool isloading = false.obs;
  void loading() {
    isloading.value = true;
    Timer(Duration(seconds: 2), () {
      isloading.value = false;
    });
  }
}
