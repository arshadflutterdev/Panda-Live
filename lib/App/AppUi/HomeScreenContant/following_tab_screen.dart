import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final liveStream = FirebaseFirestore.instance.collection("LiveStream");
  late DateTime stableThreshold;
  String? currentUserId;
  RxList<String> followingIdsList = <String>[].obs;
  bool isloadingFollowing = true;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    stableThreshold = DateTime.now().subtract(const Duration(minutes: 1));
    loadfollowusers();
  }

  Future<void> loadfollowusers() async {
    if (currentUserId == null) return;
    var followingsnapshot = await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(currentUserId)
        .collection("Following")
        .get();

    followingIdsList.value = followingsnapshot.docs
        .map((doc) => doc.id)
        .toList();
    isloadingFollowing = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    final height = AppHeightwidth.screenHeight(context);
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,

      body: isloadingFollowing
          ? Center(child: CircularProgressIndicator())
          : followingIdsList.isEmpty
          ? Center(child: Text("there no streamer"))
          : StreamBuilder<QuerySnapshot>(
              stream: liveStream
                  .where("uid", whereIn: followingIdsList)
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
                          Image(
                            image: AssetImage(AppImages.notfollow),
                            height: height * 0.30,
                          ),
                          const Gap(10),
                          Text(
                            isArabic
                                ? "لا يوجد بث مباشر من المتابعين حالياً"
                                : "No live streams from people you follow",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isArabic
                                ? "ابدأ بمتابعة منشئي المحتوى لمشاهدة البث المباشر"
                                : "Follow creators to see their live streams",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
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
                                  : AssetImage(AppImages.bgimage)
                                        as ImageProvider,
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
                                    child: Text(
                                      isArabic ? "عش الآن" : "Live now",
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
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
                                    Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                    ),
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
