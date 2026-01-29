import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class UseridAuth extends StatefulWidget {
  const UseridAuth({super.key});

  @override
  State<UseridAuth> createState() => _UseridAuthState();
}

class _UseridAuthState extends State<UseridAuth> {
  RxInt shortId = 0.obs;
  // final LoadingController isloading = Get.put(LoadingController());
  RxBool isLoading = false.obs;
  bool isArabic = Get.locale?.languageCode == "ar";

  final _formkey = GlobalKey<FormState>();
  RxBool isUserIdEmpty = false.obs;
  TextEditingController userController = TextEditingController();

  final arg = Get.arguments;
  Future<void> loginwithId() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("userProfile")
        .where("shortId", isEqualTo: int.tryParse(userController.text))
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      Get.toNamed(AppRoutes.bottomnav);
    } else {
      Get.snackbar(
        "ooOps",
        "UserId didn't match",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  //let't try to login

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: Text(
                  localization.loginwithid,
                  style: isArabic
                      ? AppStyle.arabictext.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        )
                      : AppStyle.btext,
                ),
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
                          return localization.adduserid;
                        } else if (userController.text.length < 6) {
                          return localization.uid6digits;
                        }
                        return null;
                      },
                      controller: userController,
                      hintext: localization.hintid,
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
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      isLoading.value = true;
                      await loginwithId();
                      isLoading.value = false;
                    }
                  },
                  child: Obx(
                    () => isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            localization.buttonnext,
                            style: isArabic
                                ? AppStyle.arabictext.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )
                                : AppStyle.btext.copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ),
              Gap(height * 0.020),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      localization.readAndAgree,
                      style: isArabic
                          ? AppStyle.arabictext
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
                          ? AppStyle.arabictext.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            )
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
