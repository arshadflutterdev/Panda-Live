import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class ExplorerScreen extends StatefulWidget {
  final RxString searchText;
  const ExplorerScreen({super.key, required this.searchText});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  final liveStream = FirebaseFirestore.instance.collection("LiveStream");
  late DateTime stableThreshold;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    stableThreshold = DateTime.now().subtract(const Duration(minutes: 1));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    final localization = AppLocalizations.of(context)!;
    final query = widget.searchText.value.toLowerCase();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          Get.defaultDialog(
            backgroundColor: Colors.white,
            title: isArabic
                ? "هل أنت مستعد للبث المباشر؟"
                : "Ready to Go Live?",
            titleStyle: isArabic
                ? AppStyle.arabictext.copyWith(fontSize: 22)
                : TextStyle(),
            content: Text(
              isArabic
                  ? "أضواء، كاميرا... ستبدأ البث المباشر!"
                  : "Lights, Camera… You’re Going Live!",
              textAlign: TextAlign.center, // ← ye add karo
              style: isArabic
                  ? AppStyle.arabictext.copyWith(fontSize: 22)
                  : AppStyle.btext,
            ),

            cancel: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                localization.bcancel,
                style: isArabic ? AppStyle.arabictext : TextStyle(),
              ),
            ),
            confirm: TextButton(
              onPressed: () async {
                final User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  Get.back();
                  await FirebaseFirestore.instance
                      .collection("LiveStream")
                      .doc(currentUser.uid)
                      .set({
                        "hostname": currentUser.displayName ?? 'Guest',
                        "uid": currentUser.uid,
                        "channelId": "testingChannel",
                        "image": currentUser.photoURL ?? "",
                        "views": 0,
                        "startedAt": FieldValue.serverTimestamp(),
                        "lastHeartbeat": FieldValue.serverTimestamp(),
                      });

                  Get.toNamed(
                    AppRoutes.golive,
                    arguments: {
                      "channelId": "testingChannel",
                      "hostname": currentUser.displayName ?? "no name",
                      "hostphoto": currentUser.photoURL ?? "",
                    },
                  );
                }
              },

              child: Text(
                isArabic ? "يتأكد" : "Confirm",
                style: isArabic ? AppStyle.arabictext : TextStyle(),
              ),
            ),
          );
        },
        child: Image(image: AssetImage(AppImages.golive), color: Colors.white),
      ),
      backgroundColor: Colors.white,

      body: StreamBuilder<QuerySnapshot>(
        stream: liveStream
            .where("uid", isNotEqualTo: currentUserId)
            .where("lastHeartbeat", isGreaterThan: stableThreshold)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          } else if (snapshot.hasError) {
            return Text("Error in data");
          } else if (!snapshot.hasData) {
            return Text("There is no data");
          } else {
            final docs = snapshot.data?.docs ?? [];
            print("here is docs list ${docs.length}");
            if (docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_camera_front_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const Gap(10),
                    Text(
                      isArabic
                          ? "لا يوجد بث مباشر حالياً"
                          : "No one is live right now",
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                    Text(isArabic ? "ابدأ بثك الخاص" : "Start your own stream"),
                  ],
                ),
              );
            }

            return GridView.builder(
              itemCount: docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                crossAxisCount: 2,
                childAspectRatio: 0.99,
              ),
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    if (data["agoraUid"] == null) {
                      Get.snackbar(
                        "Wait",
                        "Host is still connecting...",
                        backgroundColor: Colors.black87,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    Get.toNamed(
                      AppRoutes.watchstream,
                      arguments: {
                        "uid": data["uid"],
                        "channelId": data["channelId"],
                        "hostname": data["hostname"],
                        "hostphoto": data["image"],
                        "agoraUid":
                            data["agoraUid"], // This is the ID we saved in GoLiveScreen
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: data["image"] != null
                            ? NetworkImage(data["image"])
                            : AssetImage(AppImages.bgimage) as ImageProvider,
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
                              Expanded(
                                child: Text(
                                  maxLines: 2,

                                  data["hostname"] ?? "Guest",
                                  style: isArabic
                                      ? AppStyle.arabictext.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        )
                                      : TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                ),
                              ),

                              Gap(5),

                              Spacer(),
                              Icon(Icons.remove_red_eye, color: Colors.white),
                              Gap(3),
                              Text(
                                (data["views"] ?? 0).toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
