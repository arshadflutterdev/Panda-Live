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

  @override
  Widget build(BuildContext context) {
    double width = AppHeightwidth.screenWidth(context);
    double height = AppHeightwidth.screenHeight(context);
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
                      Text("Please Enter 8 Digits Password"),
                      Gap(height * 0.010),
                      Obx(
                        () => MyTextFormField(
                          validator: (value) {
                            if (passController.text.isEmpty) {
                              return "Enter Your Password";
                            } else if (passController.text.length < 8) {
                              return "Password must be 8 digits";
                            }
                            return null;
                          },
                          obscure: isSecure.value,
                          controller: passController,
                          keyboard: TextInputType.number,
                          hintext: "Enter Your Password",
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
                            "Forget Password?",
                            style: TextStyle(color: AppColours.blues),
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
                      Get.toNamed(AppRoutes.bottomnav);
                    }
                  },
                  child: Text(
                    "Next",
                    style: AppStyle.btext.copyWith(color: Colors.white),
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
                      "I have read and agreed the",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.terms);
                    },
                    child: Text(
                      "PandaLive terms of Services",
                      style: TextStyle(color: Colors.blueAccent),
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
