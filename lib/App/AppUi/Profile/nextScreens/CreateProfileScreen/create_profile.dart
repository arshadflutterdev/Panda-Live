import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pandlive/App/AppUi/Profile/nextScreens/CreateProfileScreen/profile_store_controller.dart';
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
  final pController = Get.find<ProfileStoreController>();

  RxString genderError = "".obs;

  Future<void> imagepic() async {
    ImagePicker picker = ImagePicker();
    final XFile? images = await picker.pickImage(source: ImageSource.gallery);
    if (images == null) {
      return;
    }

    pController.image.value = File(images!.path);
    print("here is image path ${pController.image.value}");
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
  final user = FirebaseAuth.instance.currentUser!.uid;

  final argu = Get.arguments as Map<String, dynamic>? ?? {};
  @override
  void initState() {
    super.initState();

    pController.userphoto.value = argu["userphoto"] ?? "";
    if (argu['username'] != null) {
      nameController.text = argu['username'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = argu["userId"] ?? "";
    print("on profile screen id $userId");

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
                                      image:
                                          (pController
                                              .userphoto
                                              .value
                                              .isNotEmpty)
                                          ? NetworkImage(
                                              pController.userphoto.value,
                                            )
                                          : pController.image.value != null
                                          ? FileImage(pController.image.value!)
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
                              return null;
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
                              pController.isSelected.value = 1;
                              genderError.value = "";
                            },
                            child: Obx(
                              () => Container(
                                height: height * 0.075,
                                width: width * 0.45,
                                decoration: BoxDecoration(
                                  color: pController.isSelected.value == 1
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
                              pController.isSelected.value = 2;
                              genderError.value = "";
                            },
                            child: Obx(
                              () => Container(
                                height: height * 0.075,
                                width: width * 0.45,
                                decoration: BoxDecoration(
                                  color: pController.isSelected.value == 2
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
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            if (pController.isSelected.value == 0) {
                              genderError.value = "Please select your gender";
                              return; // ❗ stop submit
                            }

                            // 1. Check age
                            if (dobController.text.isNotEmpty) {
                              final parts = dobController.text.split(
                                '-',
                              ); // expecting dd-mm-yyyy
                              final day = int.tryParse(parts[0]) ?? 1;
                              final month = int.tryParse(parts[1]) ?? 1;
                              final year = int.tryParse(parts[2]) ?? 1900;

                              final dob = DateTime(year, month, day);
                              final now = DateTime.now();
                              final age =
                                  now.year -
                                  dob.year -
                                  ((now.month < dob.month ||
                                          (now.month == dob.month &&
                                              now.day < dob.day))
                                      ? 1
                                      : 0);

                              if (age < 16) {
                                Get.snackbar(
                                  "Oops!",
                                  "You must be at least 16 to create a profile",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return; // stop submission
                              }
                            }

                            isloading.value = true;
                            try {
                              await pController.storeuserprofile();
                              Get.offAllNamed(AppRoutes.bottomnav);
                            } finally {
                              isloading.value = false;
                            }
                          }
                        },

                        // onPressed: () async {
                        //   if (_formkey.currentState!.validate()) {
                        //     isloading.value = true;
                        //     try {
                        //       await storeuserprofile();
                        //       Get.offAllNamed(AppRoutes.bottomnav);
                        //     } finally {
                        //       isloading.value = false;
                        //     }
                        //   }
                        // },
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
