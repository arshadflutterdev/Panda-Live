import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class EmailAuth extends StatefulWidget {
  const EmailAuth({super.key});

  @override
  State<EmailAuth> createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
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
                child: Text("Login With Your Email", style: AppStyle.btext),
              ),
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: MyTextFormField(
                      keyboard: TextInputType.emailAddress,
                      validator: (value) {
                        if (emailController.text.isEmpty) {
                          return "Please Add Your Email";
                        } else if (!emailController.text.contains(
                          "@gmail.com",
                        )) {
                          return "Please Enter Valid Email";
                        }
                        return null;
                      },
                      controller: emailController,
                      hintext: 'Please enter your email.',
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
                      Get.snackbar(
                        "Congratulations",
                        "You added information correctly",
                      );
                      emailController.clear();
                    }
                  },
                  child: Text(
                    "Next",
                    style: AppStyle.btext.copyWith(color: Colors.white),
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
