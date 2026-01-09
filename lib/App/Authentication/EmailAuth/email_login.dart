import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key});

  @override
  State<EmailLogin> createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  RxBool isCodeEmpty = false.obs;
  RxBool isSecure = true.obs;
  RxBool isLoading = false.obs;
  bool isArabic = Get.locale?.languageCode == "ar";

  @override
  Widget build(BuildContext context) {
    double width = AppHeightwidth.screenWidth(context);
    double height = AppHeightwidth.screenHeight(context);
    final localization = AppLocalizations.of(context)!;

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

              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.enter8pass,
                        style: isArabic ? AppStyle.arabictext : TextStyle(),
                      ),
                      Gap(height * 0.010),
                      Obx(
                        () => MyTextFormField(
                          validator: (value) {
                            if (passController.text.isEmpty) {
                              return localization.enteryourpass;
                            } else if (passController.text.length < 8) {
                              return localization.code8digits;
                            }
                            return null;
                          },
                          obscure: isSecure.value,
                          controller: passController,
                          keyboard: TextInputType.text,
                          hintext: localization.enteryourpass,
                          onChanged: (newValue) {
                            isCodeEmpty.value = newValue.isNotEmpty;
                          },
                          suffix: SizedBox(
                            height: 20,
                            width: width * 0.27,

                            child: Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    passController.clear();
                                  },
                                  icon: isCodeEmpty.value
                                      ? Icon(Icons.close, color: Colors.black54)
                                      : SizedBox.shrink(),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    isSecure.value = !isSecure.value;
                                  },
                                  icon: isSecure.value
                                      ? Image(
                                          height: 25,

                                          image: AssetImage(AppImages.eyesoff),
                                        )
                                      : Image(
                                          height: 25,
                                          image: AssetImage(AppImages.eyeson),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.resetpassword);
                          },
                          child: Text(
                            localization.forgetpass,
                            style: isArabic
                                ? AppStyle.arabictext.copyWith(
                                    color: AppColours.blues,
                                  )
                                : TextStyle(color: AppColours.blues),
                          ),
                        ),
                      ),
                    ],
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
                            localization.buttonnext,
                            style: isArabic
                                ? AppStyle.arabictext.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.white,
                                  )
                                : AppStyle.btext.copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ),
              Gap(height * 0.030),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      localization.readAndAgree,
                      style: isArabic
                          ? AppStyle.arabictext.copyWith(color: Colors.black)
                          : TextStyle(color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.terms);
                    },
                    child: Text(
                      localization.pterms,
                      style: isArabic
                          ? AppStyle.arabictext.copyWith(color: Colors.blue)
                          : TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
