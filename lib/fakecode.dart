import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class WatchstreamingClass extends StatefulWidget {
  const WatchstreamingClass({super.key});

  @override
  State<WatchstreamingClass> createState() => _WatchstreamingClassState();
}

class _WatchstreamingClassState extends State<WatchstreamingClass> {
  TextEditingController commentController = TextEditingController();
  RxBool isfollowing = false.obs;
  final arg = Get.arguments as Map<String, dynamic>? ?? {};
  String get images => arg["images"] ?? "";
  String get namess => arg["names"] ?? "";
  String get arnames => arg["arabicnam"] ?? "";
  String get country => arg["country"] ?? "";
  String get view => arg["views"] ?? "";

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
  //hon gal hosi arabic ech
  // Comments in Arabic
  List<String> liveCommentsArabic = [
    "🔥🔥 البث المباشر رائع جدًا، استمتعت حقًا!",
    "تحية من باكستان 🇵🇰❤️ المضيف نشيط جدًا",
    "الصوت واضح والفيديو سلس 👍",
    "من فضلك اعطني تحية 🙌",
    "الموضوع ممتع جدًا 💯",
  ];

  // Commenter names in Arabic
  List<String> commentnamesArabic = ["علي", "عائشة", "حسن", "زارا", "عثمان"];

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(images)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(images),
                          ),
                          Gap(5),
                          Text(
                            isArabic ? arnames : namess,
                            style: isArabic
                                ? AppStyle.arabictext.copyWith(
                                    fontSize: 20,
                                    color: Colors.white,
                                  )
                                : TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                          ),
                          Gap(2),
                          Image(
                            image: AssetImage(country),
                            height: 18,
                            width: 18,
                          ),
                        ],
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
                      onPressed: () {
                        isfollowing.value = !isfollowing.value;
                      },
                      child: Obx(
                        () => isfollowing.value
                            ? Text(
                                isArabic ? "التالي" : "Following",
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )
                                    : TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                              )
                            : Text(
                                isArabic ? "يتبع" : "Follow",
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )
                                    : TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
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
                            ? "هل تريد مغادرة البث المباشر؟"
                            : "Leave Live Stream?",
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            isArabic
                                ? "أنت تشاهد البث المباشر.\nإذا غادرت الآن، قد تفوت شيئًا ممتعًا!"
                                : "You're watching a live stream.\nIf you leave now, you might miss something exciting!",
                            textAlign: TextAlign.center,
                            style: isArabic
                                ? AppStyle.arabictext.copyWith(fontSize: 16)
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
                          },
                          child: Text(
                            isArabic ? "غادر" : "Leave",
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
              bottom: 10,
              left: 2,
              right: 2,
              child: Row(
                children: [
                  Expanded(
                    child: MyTextFormField(
                      controller: commentController,
                      keyboard: TextInputType.text,
                      hintext: isArabic
                          ? "اكتب تعليقاً..."
                          : "Write a comment...",
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                    onPressed: () {
                      commentController.clear();
                    },
                    icon: Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),

            Positioned(
              left: 10,
              right: 10,
              bottom: height * 0.099,
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
                            decoration: BoxDecoration(color: Colors.black12),
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
    );
  }
}
