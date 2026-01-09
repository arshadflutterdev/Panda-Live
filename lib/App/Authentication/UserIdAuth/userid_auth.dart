import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Controllers/loading_controller.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class UseridAuth extends StatefulWidget {
  const UseridAuth({super.key});

  @override
  State<UseridAuth> createState() => _UseridAuthState();
}

class _UseridAuthState extends State<UseridAuth> {
  // final LoadingController isloading = Get.put(LoadingController());
  RxBool isLoading = false.obs;

  final _formkey = GlobalKey<FormState>();
  RxBool isUserIdEmpty = false.obs;
  TextEditingController userController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(AppImages.bgimage),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(height * 0.010),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
              ),
              Gap(height * 0.25),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: Text("Login With Your_Id", style: AppStyle.btext),
              ),
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => MyTextFormField(
                      onChanged: (newValue) {
                        isUserIdEmpty.value = newValue.isNotEmpty;
                      },
                      inputformat: [FilteringTextInputFormatter.digitsOnly],
                      keyboard: TextInputType.number,
                      validator: (value) {
                        if (userController.text.isEmpty) {
                          return "Please Add Your userId";
                        } else if (userController.text.length < 6) {
                          return "Please Enter Your 6 Digits userId";
                        }
                        return null;
                      },
                      controller: userController,
                      hintext: "Please Enter Your 6 Digits userId",
                      suffix: isUserIdEmpty.value
                          ? IconButton(
                              onPressed: () {
                                userController.clear();
                              },
                              icon: Icon(Icons.close),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              Gap(height * 0.020),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColours.blues,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fixedSize: Size(width * 0.60, 45),
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      isLoading.value = true;
                      Timer(Duration(seconds: 2), () {
                        isLoading.value = false;
                        Get.toNamed(AppRoutes.bottomnav);
                      });
                    }
                  },
                  child: Obx(
                    () => isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Next",
                            style: AppStyle.btext.copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
