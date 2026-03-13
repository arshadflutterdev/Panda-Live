import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/HomeScreenContant/isnew_user.dart';
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

            // ExplorerScreen.dart mein Confirm button ka logic
            // confirm: TextButton(
            //   onPressed: () {
            //     Get.back(); // Dialog band karein
            //     // Seedha Setup Screen par bhejein, Firestore mein abhi kuch nahi likhna
            //     Get.toNamed(AppRoutes.liveSetup);
            //   },
            //   child: Text(
            //     isArabic ? "يتأكد" : "Confirm",
            //     style: isArabic ? AppStyle.arabictext : const TextStyle(),
            //   ),
            // ),
            confirm: TextButton(
              onPressed: () async {
                final User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser == null) return;

                // 1. Loading Indicator start karein
                Get.dialog(
                  const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                  barrierDismissible: false,
                );

                try {
                  // 2. Verification status check karein
                  DocumentSnapshot vDoc = await FirebaseFirestore.instance
                      .collection("userProfile")
                      .doc(currentUser.uid)
                      .collection("isUserValid")
                      .doc("verification_details")
                      .get();

                  Get.back(); // Loading dialog band karein

                  if (vDoc.exists && vDoc.data() != null) {
                    final data = vDoc.data() as Map<String, dynamic>;
                    String status = data['status']?.toString() ?? "pending";

                    if (status == "approved") {
                      // --- USER APPROVED: AB LIVE DATA SAVE KAREIN ---
                      Get.back(); // Main Confirmation Dialog band karein

                      // Firestore mein LiveStream ki entry karein
                      await FirebaseFirestore.instance
                          .collection("LiveStream")
                          .doc(currentUser.uid)
                          .set({
                            "hostname": currentUser.displayName ?? 'Guest',
                            "uid": currentUser.uid,
                            "channelId":
                                "testingChannel", // Aapka dynamic channel ID
                            "image": currentUser.photoURL ?? "",
                            "views": 0,
                            "startedAt": FieldValue.serverTimestamp(),
                            "lastHeartbeat": FieldValue.serverTimestamp(),
                          });

                      // Screen transition with arguments
                      Get.toNamed(
                        AppRoutes.golive,
                        arguments: {
                          "channelId": "testingChannel",
                          "hostname": currentUser.displayName ?? "Guest",
                          "hostphoto": currentUser.photoURL ?? "",
                        },
                      );
                    } else if (status == "pending") {
                      Get.back(); // Main Dialog band
                      Get.snackbar(
                        isArabic ? "قيد المراجعة" : "Under Review",
                        isArabic
                            ? "طلبك لا يزال قيد المعالجة."
                            : "Your application is still being processed.",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.back();
                      Get.to(() => const VerificationScreen());
                    }
                  } else {
                    // Document nahi hai matlab user ne apply nahi kiya
                    Get.back();
                    Get.to(() => const VerificationScreen());
                  }
                } catch (e) {
                  if (Get.isDialogOpen!) Get.back();
                  print("Live Stream Error: $e");
                  Get.snackbar(
                    "Error",
                    "Something went wrong. Please try again.",
                  );
                }
              },
              child: Text(
                isArabic ? "يتأكد" : "Confirm",
                style: isArabic ? AppStyle.arabictext : const TextStyle(),
              ),
            ),

            // confirm: TextButton(
            //   onPressed: () async {
            //     final User? currentUser = FirebaseAuth.instance.currentUser;
            //     if (currentUser != null) {
            //       Get.back();
            //       await FirebaseFirestore.instance
            //           .collection("LiveStream")
            //           .doc(currentUser.uid)
            //           .set({
            //             "hostname": currentUser.displayName ?? 'Guest',
            //             "uid": currentUser.uid,
            //             "channelId": "testingChannel",
            //             "image": currentUser.photoURL ?? "",
            //             "views": 0,
            //             "startedAt": FieldValue.serverTimestamp(),
            //             "lastHeartbeat": FieldValue.serverTimestamp(),
            //           });

            //       Get.toNamed(
            //         AppRoutes.golive,
            //         arguments: {
            //           "channelId": "testingChannel",
            //           "hostname": currentUser.displayName ?? "no name",
            //           "hostphoto": currentUser.photoURL ?? "",
            //         },
            //       );
            //     }
            //   },

            //   child: Text(
            //     isArabic ? "يتأكد" : "Confirm",
            //     style: isArabic ? AppStyle.arabictext : TextStyle(),
            //   ),
            // ),
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
            return Obx(() {
              final docs = snapshot.data?.docs ?? [];
              final query = widget.searchText.value.toLowerCase();
              final filteredDocs = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final hostname = (data["hostname"] ?? "")
                    .toString()
                    .toLowerCase();
                return hostname.contains(query);
              }).toList();

              print("here is docs list ${docs.length}");
              if (filteredDocs.isEmpty) {
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
                      Text(
                        isArabic ? "ابدأ بثك الخاص" : "Start your own stream",
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                itemCount: filteredDocs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final data =
                      filteredDocs[index].data() as Map<String, dynamic>;
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
                                    data["hostname"] ?? "Guest",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: isArabic
                                        ? AppStyle.arabictext.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          )
                                        : TextStyle(
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
            });
          }
        },
      ),
    );
  }
}
