import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    MyTextFormField(
                      keyboard: TextInputType.text,
                      hintext: "Enter Your Name",
                    ),
                    Gap(10),
                    Text("Date of Birth", style: AppStyle.halfblacktext),
                    Gap(5),
                    MyTextFormField(
                      keyboard: TextInputType.text,
                      hintext: "Enter your date of birth",
                    ),
                    Gap(10),
                    Row(
                      children: [
                        Text("Country", style: AppStyle.halfblacktext),
                        Text(" 👀 "),
                        Text(
                          "not to be altered once set",
                          style: AppStyle.halfblacktext.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    Gap(5),
                    MyTextFormField(
                      keyboard: TextInputType.text,
                      hintext: "Select Your Country",
                    ),
                    Gap(10),
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
                        Container(
                          height: height * 0.075,
                          width: width * 0.40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text("lashari"),
                              Spacer(),
                              Image(
                                image: AssetImage("assets/images/girl.png"),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: height * 0.075,
                          width: width * 0.40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
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
