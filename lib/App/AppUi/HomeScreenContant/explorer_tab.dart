import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  List<String> images = [
    AppImages.eman,
    AppImages.egirl0,
    AppImages.eman0,
    AppImages.egirl2,
    AppImages.egirl2,
    AppImages.egirl3,
    AppImages.eman1,
    AppImages.egirl2,
    AppImages.egirl4,
    AppImages.egirl5,
    AppImages.egirl6,
    AppImages.eman0,
    AppImages.egirl2,
    AppImages.egirl3,
    AppImages.eman1,
    AppImages.egirl4,
  ];
  //live user list
  List<String> usernames = [
    "Ali",
    "Emily",
    "Usman",
    "Sophia",
    "Ayesha",
    "Olivia",
    "Hassan",
    "Emma",
    "Zara",
    "Mia",
    "Lily",
    "Ahmed",
    "Noor",
    "Ava",
    "Salman",
    "Sofia",
  ];
  List<String> usernamesArabic = [
    "علي", // Ali
    "إميلي", // Emily
    "عثمان", // Usman
    "صوفيا", // Sophia
    "عائشة", // Ayesha
    "أوليفيا", // Olivia
    "حسن", // Hassan
    "إيما", // Emma
    "زارا", // Zara
    "ميا", // Mia
    "ليلي", // Lily
    "أحمد", // Ahmed
    "نور", // Noor
    "آفا", // Ava
    "سلمان", // Salman
    "صوفيا", // Sofia
  ];

  //list countries flag
  List<String> countries = [
    AppImages.pak,
    AppImages.usa,
    AppImages.saudi,
    AppImages.uae,
    AppImages.india,
    AppImages.pak,
    AppImages.usa,
    AppImages.saudi,
    AppImages.uae,
    AppImages.india,
    AppImages.pak,
    AppImages.usa,
    AppImages.saudi,
    AppImages.uae,
    AppImages.india,
    AppImages.pak,
  ];
  //views
  List<int> views = [10, 15, 20, 30, 5, 3, 25, 12, 18, 7, 22, 14, 9, 35, 8, 28];

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          Get.defaultDialog(
            cancel: TextButton(onPressed: () {}, child: Text("Cancel")),
          );
        },
        child: Image(image: AssetImage(AppImages.golive), color: Colors.white),
      ),
      backgroundColor: Colors.white,

      body: GridView.builder(
        itemCount: images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          crossAxisCount: 2,
          childAspectRatio: 0.99,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.watchstream,
                arguments: {
                  "images": images[index],
                  "names": usernames[index],
                  "arabicnam": usernamesArabic[index],
                  "country": countries[index],
                  "views": views[index],
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(images[index]),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColours.greycolour,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(isArabic ? "عش الآن" : "Live now"),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text(
                          isArabic ? usernamesArabic[index] : usernames[index],
                          style: isArabic
                              ? AppStyle.arabictext.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )
                              : TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Gap(5),
                        Image(
                          image: AssetImage(countries[index]),
                          height: 20,
                          width: 20,
                        ),
                        Spacer(),
                        Icon(Icons.remove_red_eye, color: Colors.white),
                        Gap(3),
                        Text(
                          views[index].toString(),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
