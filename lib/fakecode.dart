import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class GoliveScreenfake extends StatefulWidget {
  const GoliveScreenfake({super.key});

  @override
  State<GoliveScreenfake> createState() => _GoliveScreenfakeState();
}

class _GoliveScreenfakeState extends State<GoliveScreenfake> {
  TextEditingController commentController = TextEditingController();

  //comments list
  List<String> liveComments = [
    "🔥🔥 bohat zabardast live hai, maza aa gaya!",
    "Love from Pakistan 🇵🇰❤️ host full energy me hai",
    "Audio clear hai, video bhi smooth chal rahi 👍",
    "Please shoutout kar do 🙌",
    "Ye topic bohat interesting hai 💯",
  ];
  //comment krney waalu k naam
  List<String> commentnames = ["Ali", "Ayesha", "Hassan", "Zara", "Usman"];
  // Comments in Arabic
  List<String> liveCommentsArabic = [
    "🔥🔥 البث المباشر رائع جدًا، استمتعت حقًا!",
    "تحية من باكستان 🇵🇰❤️ المضيف نشيط جدًا",
    "الصوت واضح والفيديو سلس 👍",
    "من فضلك اعطني تحية 🙌",
    "الموضوع ممتع جدًا 💯",
  ];
  RxBool isloading = false.obs;
  // Commenter names in Arabic
  List<String> commentnamesArabic = ["علي", "عائشة", "حسن", "زارا", "عثمان"];

  // --- Countdown Variables ---
  RxInt countdown = 5.obs; // 5 seconds countdown
  RxBool showCountdown = true.obs;

  late Timer liveTimer;
  RxInt liveSeconds = 0.obs;
  String get liveTime {
    final minutes = liveSeconds.value ~/ 60;
    final seconds = liveSeconds.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  late Timer viewss;
  RxInt fakeviews = 5.obs;

  void initState() {
    super.initState();

    // --- Countdown Timer ---
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 1) {
        countdown.value--;
      } else {
        countdown.value = 0;
        showCountdown.value = false;
        timer.cancel();

        // Start live timer
        liveTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          liveSeconds.value++;
        });

        // Start fake views increment
        viewss = Timer.periodic(Duration(seconds: 4), (timer) {
          fakeviews.value += Random().nextInt(3);
        });
      }
    });

    // Existing loading timer
    Timer.periodic(Duration(seconds: 5), (timer) => isloading.value = true);
  }

  void dispose() {
    liveTimer.cancel();
    viewss.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    bool isArabic = Get.locale?.languageCode == "ar";

    return WillPopScope(
      child: Scaffold(
        body: Stack(
          children: [
            // --- Original background and live UI ---
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppImages.eman1),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: height * 0.040,
                    left: 10,
                    right: 10,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.white,
                                  ),
                                  Gap(3),
                                  Obx(
                                    () => Text(
                                      fakeviews.value.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          height: 38,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(10),
                              ),
                            ),
                            onPressed: () {},
                            child: Obx(
                              () => Text(
                                "Live $liveTime",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(5),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                          onPressed: () {
                            Get.defaultDialog(
                              backgroundColor: Colors.white,
                              radius: 12,
                              title: isArabic
                                  ? "هل تريد إنهاء البث المباشر؟"
                                  : "End Live Stream?",
                              titleStyle: isArabic
                                  ? AppStyle.arabictext.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  isArabic
                                      ? "أنت على وشك إنهاء البث المباشر.\nسيتم إعلام المشاهدين بذلك."
                                      : "You are about to end your live stream.\nViewers will be notified, dear.",
                                  textAlign: TextAlign.center,
                                  style: isArabic
                                      ? AppStyle.arabictext.copyWith(
                                          fontSize: 16,
                                        )
                                      : const TextStyle(fontSize: 15),
                                ),
                              ),
                              cancel: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  isArabic ? "ابقَ" : "Stay",
                                  style: isArabic
                                      ? AppStyle.arabictext.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        )
                                      : const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                ),
                              ),
                              confirm: TextButton(
                                onPressed: () {
                                  Get.back();
                                  Get.back();
                                  Get.back();
                                  // --- Optional: Add code here to notify viewers if using backend ---
                                },
                                child: Text(
                                  isArabic ? "إنهاء" : "End",
                                  style: isArabic
                                      ? AppStyle.arabictext.copyWith(
                                          fontSize: 18,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        )
                                      : const TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: height * 0.029,
                    child: Container(
                      width: width,
                      color: Colors.transparent,
                      constraints: BoxConstraints(maxHeight: height * 0.4),
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: liveComments.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Text(
                                isArabic
                                    ? commentnamesArabic[index]
                                    : commentnames[index],
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber,
                                      )
                                    : TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber,
                                      ),
                              ),
                              Text(": "),
                              Expanded(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                  ),
                                  child: Text(
                                    isArabic
                                        ? liveCommentsArabic[index]
                                        : liveComments[index],
                                    style: isArabic
                                        ? AppStyle.arabictext.copyWith(
                                            color: Colors.white,
                                          )
                                        : TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Countdown Overlay ---
            Obx(() {
              if (showCountdown.value) {
                return Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: countdown.value / 5,
                            color: Colors.red,
                            strokeWidth: 8,
                          ),
                          Text(
                            countdown.value.toString(),
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
