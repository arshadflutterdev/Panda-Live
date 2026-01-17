import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/Buttons/elevatedbutton0.dart';
import 'package:pandlive/App/Widgets/DialogBox/country_picker_dialoge.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

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
  RxString genderError = "".obs;
  //image picker
  Rxn<File> image = Rxn<File>();

  Future<void> imagepic() async {
    ImagePicker picker = ImagePicker();
    final XFile? images = await picker.pickImage(source: ImageSource.gallery);
    if (images == null) {
      return;
    }

    image.value = File(images!.path);
    print("here is image path $image");
    if (!mounted) {
      return;
    }
  }

  //dialog box for countries

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // header background
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // button color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
      setState(() {
        dobController.text = formattedDate;
      });
    }
  }

  bool isArabic = Get.locale?.languageCode == "ar";
  Future<void> storeuserprofile() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final adduser = {
        "name": nameController.text.toString(),
        "dob": dobController.text.toString(),
        "country": countryController.text.toString(),
        "gender": isSelected.value == 1 ? "Male" : "Female",
        "userimage": image.value!.path ?? "",
        "createdAt": FieldValue.serverTimestamp(),
      };
      firestore.collection("userProfile").add(adduser);
      Get.snackbar("Congratulation", "All set! Your profile is now complete.");
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        "Error",
        "Failed to save user information",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final argu = Get.arguments as Map<String, dynamic>;
    final userId = argu["userId"] ?? "";
    print("on profile screen id $userId");
    final username = argu['username'] ?? "";
    if (username != null) {
      nameController.text = username;
    }
    print("profile screen name $username");
    final userphoto = argu["userphoto"] ?? "";
    // print("prfile screen photo $userphoto") ?? "";
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    final localization = AppLocalizations.of(context)!;
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
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.completedata,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        fontSize: width * 0.066,
                                        fontWeight: FontWeight.w600,
                                      )
                                    : AppStyle.btext.copyWith(
                                        fontSize: width * 0.066,
                                      ),
                              ),
                              Text(
                                localization.letknow,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        color: Colors.black54,
                                      )
                                    : AppStyle.halfblacktext,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Obx(
                                () => Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black26,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: userphoto != null
                                          ? NetworkImage(userphoto)
                                          : image.value != null
                                          ? FileImage(image.value!)
                                                as ImageProvider
                                          : AssetImage(AppImages.girl),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: -15,
                                        right: -2,
                                        child: IconButton(
                                          onPressed: () {
                                            imagepic();
                                          },
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Text(
                                localization.profile,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        color: Colors.black54,
                                      )
                                    : AppStyle.halfblacktext,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Text(
                      localization.nam,
                      style: isArabic
                          ? AppStyle.arabictext.copyWith(color: Colors.black54)
                          : AppStyle.halfblacktext,
                    ),
                    Gap(5),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          MyTextFormField(
                            validator: (value) {
                              if (nameController.text.isEmpty) {
                                return localization.entername;
                              } else if (nameController.text.length < 6) {
                                return localization.shortnam;
                              }
                              return null;
                            },
                            controller: nameController,
                            keyboard: TextInputType.text,
                            hintext: localization.entername,
                          ),
                          Gap(7),
                          Align(
                            alignment: isArabic
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Text(
                              localization.dob,
                              style: isArabic
                                  ? AppStyle.arabictext.copyWith(
                                      color: Colors.black54,
                                    )
                                  : AppStyle.halfblacktext,
                            ),
                          ),
                          Gap(5),
                          MyTextFormField(
                            read: true,
                            ontapp: () {
                              pickDate();
                            },
                            controller: dobController,
                            keyboard: TextInputType.datetime,
                            hintext: localization.date,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localization.adddob;
                              }

                              return null; // ✅ valid
                            },
                          ),

                          Gap(7),
                          Row(
                            children: [
                              Text(
                                localization.contry,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        color: Colors.black54,
                                      )
                                    : AppStyle.halfblacktext,
                              ),
                              Text(" 👀 "),
                              Text(
                                localization.noalterd,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      )
                                    : AppStyle.halfblacktext.copyWith(
                                        fontSize: 13,
                                      ),
                              ),
                            ],
                          ),
                          Gap(5),
                          MyTextFormField(
                            validator: (value) {
                              if (countryController.text.isEmpty) {
                                return localization.selectcontry;
                              }
                            },
                            controller: countryController,
                            read: true,
                            ontapp: () {
                              CountryPickerDialog.show(
                                context,
                                countryController,
                              );
                            },
                            keyboard: TextInputType.text,
                            hintext: localization.selectcontry,
                          ),
                        ],
                      ),
                    ),
                    Gap(7),
                    Row(
                      children: [
                        Text(
                          localization.gender,
                          style: isArabic
                              ? AppStyle.arabictext.copyWith(
                                  color: Colors.black54,
                                )
                              : AppStyle.halfblacktext,
                        ),
                        Text(" 👀 "),
                        Text(
                          localization.noalterd,
                          style: isArabic
                              ? AppStyle.arabictext.copyWith(
                                  fontSize: 14,
                                  color: Colors.black54,
                                )
                              : AppStyle.halfblacktext.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    Gap(5),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              isSelected.value = 1;
                              genderError.value = "";
                            },
                            child: Obx(
                              () => Container(
                                height: height * 0.075,
                                width: width * 0.45,
                                decoration: BoxDecoration(
                                  color: isSelected.value == 1
                                      ? Colors.blue.shade100
                                      : AppColours.greycolour,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Gap(
                                      isArabic ? width * 0.099 : width * 0.050,
                                    ),
                                    Text(
                                      localization.man,
                                      style: isArabic
                                          ? AppStyle.arabictext.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                            )
                                          : AppStyle.btext,
                                    ),
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
                              genderError.value = "";
                            },
                            child: Obx(
                              () => Container(
                                height: height * 0.075,
                                width: width * 0.45,
                                decoration: BoxDecoration(
                                  color: isSelected.value == 2
                                      ? Colors.blue.shade100
                                      : AppColours.greycolour,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Gap(
                                      isArabic ? width * 0.099 : width * 0.050,
                                    ),
                                    Text(
                                      localization.fmale,
                                      style: isArabic
                                          ? AppStyle.arabictext.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            )
                                          : AppStyle.btext,
                                    ),
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
                    ),
                    Obx(
                      () => genderError.value.isEmpty
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(left: 8, top: 4),
                              child: Text(
                                genderError.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                    ),

                    Gap(height * 0.015),
                    Center(
                      child: MyElevatedButton(
                        width: width,
                        btext: Obx(
                          () => isloading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  localization.sbmet,
                                  style: isArabic
                                      ? AppStyle.arabictext.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        )
                                      : AppStyle.btext.copyWith(
                                          color: Colors.white,
                                        ),
                                ),
                        ),

                        // onPressed: () {
                        //   bool formValid = _formkey.currentState!.validate();

                        //   if (isSelected.value == 0) {
                        //     genderError.value = "Please select your gender";
                        //     return;
                        //   }

                        //   if (formValid) {
                        //     isloading.value = true;

                        //     // ✅ STORED VALUES (Future use)
                        //     String name = nameController.text;
                        //     String dob = dobController.text;
                        //     String country = countryController.text;

                        //     String gender = isSelected.value == 1
                        //         ? "male"
                        //         : "female";

                        //     print(name);
                        //     print(dob);
                        //     print(country);
                        //     print(gender);

                        //     Timer(const Duration(seconds: 2), () {
                        //       isloading.value = false;
                        //       Get.toNamed(AppRoutes.bottomnav);
                        //       Get.snackbar(
                        //         localization.mubark,
                        //         localization.profiledone,
                        //         colorText: Colors.white,
                        //         backgroundColor: Colors.black,
                        //       );
                        //     });
                        //   }
                        // },
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            isloading.value = true;
                            await storeuserprofile();
                            isloading.value = false;
                            // Timer(Duration(seconds: 2), () {
                            //   isloading.value = false;
                            //   Get.snackbar(
                            //     "Congratulations",
                            //     "Your profile is done",
                            //     colorText: Colors.white,
                            //     backgroundColor: Colors.black,
                            //   );
                            // });
                          }
                        },
                      ),
                    ),
                    Gap(height * 0.020),
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
