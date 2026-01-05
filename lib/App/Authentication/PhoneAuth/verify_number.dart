import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({super.key});

  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(AppImages.bgimage),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(height * 0.010),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              Gap(height * 0.25),

              Text(
                "Login With Phone number",
                style: AppStyle.btext.copyWith(fontSize: 22),
              ),
              Text(
                "verification code send to SMS +966 ******34",
                style: TextStyle(color: Colors.black54),
              ),
              Gap(height * 0.030),
              MyTextFormField(
                keyboard: TextInputType.number,
                hintext: "Type 6 digits code",
              ),
              Text(
                "35s leterResend SMS",
                style: TextStyle(color: Colors.black54),
              ),
              Row(
                children: [
                  Text(
                    "Chnage the way?",
                    style: TextStyle(color: Colors.black54),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Resend Watsapp?",
                      style: TextStyle(color: AppColours.blues),
                    ),
                  ),
                ],
              ),

              MyTextFormField(
                keyboard: TextInputType.number,
                hintext: "Type 6 digits code",
              ),
              Text(
                "Set 6-8 digits code with letters&numbers",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
