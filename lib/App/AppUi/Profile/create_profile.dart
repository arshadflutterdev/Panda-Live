import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/Buttons/elevatedbutton0.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  RxBool isloading = false.obs;
  final _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  RxInt isSelected = 0.obs;
  //image picker

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image(fit: BoxFit.cover, image: AssetImage(AppImages.halfbg)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Complete personal data",
                              style: AppStyle.btext.copyWith(
                                fontSize: width * 0.066,
                              ),
                            ),
                            Text(
                              "Let everyone know you better",
                              style: AppStyle.halfblacktext,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: -15,
                                    right: -2,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text("Profile", style: AppStyle.halfblacktext),
                          ],
                        ),
                      ],
                    ),

                    Text("Name", style: AppStyle.halfblacktext),
                    Gap(5),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          MyTextFormField(
                            validator: (value) {
                              if (nameController.text.isEmpty) {
                                return "Enter your name";
                              } else if (nameController.text.length < 6) {
                                return "Name too short";
                              }
                              return null;
                            },
                            controller: nameController,
                            keyboard: TextInputType.text,
                            hintext: "Enter Your Name",
                          ),
                          Gap(7),
                          Text("Date of Birth", style: AppStyle.halfblacktext),
                          Gap(5),
                          MyTextFormField(
                            controller: dobController,
                            keyboard: TextInputType.datetime,
                            hintext: "DD-MM-YYYY",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Add your date of birth";
                              }

                              // DD-MM-YYYY format check
                              final dobRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');

                              if (!dobRegex.hasMatch(value)) {
                                return "Please enter date in DD-MM-YYYY format";
                              }

                              return null; // ✅ valid
                            },
                          ),

                          Gap(7),
                          Row(
                            children: [
                              Text("Country", style: AppStyle.halfblacktext),
                              Text(" 👀 "),
                              Text(
                                "not to be altered once set",
                                style: AppStyle.halfblacktext.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Gap(5),
                          MyTextFormField(
                            keyboard: TextInputType.text,
                            hintext: "Select Your Country",
                          ),
                        ],
                      ),
                    ),
                    Gap(7),
                    Row(
                      children: [
                        Text("Gender", style: AppStyle.halfblacktext),
                        Text(" 👀 "),
                        Text(
                          "not to be altered once set",
                          style: AppStyle.halfblacktext.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    Gap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            isSelected.value = 1;
                          },
                          child: Obx(
                            () => Container(
                              height: height * 0.075,
                              width: width * 0.40,
                              decoration: BoxDecoration(
                                color: isSelected.value == 1
                                    ? Colors.blue.shade100
                                    : AppColours.greycolour,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Gap(width * 0.050),
                                  Text("Male", style: AppStyle.btext),
                                  Spacer(),
                                  Image(
                                    // color: Colors.white,
                                    image: AssetImage(AppImages.boy),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            isSelected.value = 2;
                          },
                          child: Obx(
                            () => Container(
                              height: height * 0.075,
                              width: width * 0.40,
                              decoration: BoxDecoration(
                                color: isSelected.value == 2
                                    ? Colors.blue.shade100
                                    : AppColours.greycolour,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Gap(width * 0.050),
                                  Text("Female", style: AppStyle.btext),
                                  Spacer(),
                                  Image(
                                    // color: Colors.white,
                                    image: AssetImage(AppImages.girl),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(height * 0.015),
                    Center(
                      child: MyElevatedButton(
                        width: width,
                        btext: isloading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Submit",
                                style: AppStyle.btext.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            isloading.value = true;
                            Timer(Duration(seconds: 2), () {
                              isloading.value = false;
                              Get.toNamed(AppRoutes.createprofile);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
