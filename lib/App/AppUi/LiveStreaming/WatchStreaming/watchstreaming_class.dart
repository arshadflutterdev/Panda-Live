import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';

import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class WatchstreamingClass extends StatefulWidget {
  const WatchstreamingClass({super.key});

  @override
  State<WatchstreamingClass> createState() => _WatchstreamingClassState();
}

class _WatchstreamingClassState extends State<WatchstreamingClass> {
  final arg = Get.arguments;
  RxBool isfollowing = false.obs;
  TextEditingController commentController = TextEditingController();

  late RtcEngine _engine;
  final String appId = "5eda14d417924d9baf39e83613e8f8f5";
  final String channelName = "testingChannel";
  final String appToken =
      "007eJxTYGiYa1Zzb+EvSU955zt1DCJf/iY+dlHPmzDDc4au6hT+KY4KDKapKYmGJikmhuaWRiYplkmJacaWqRbGZobGqRZpFmmmx/4VZjYEMjL8qb/BysgAgSA+H0NJanFJZl66c0ZiXl5qDgMDAH4iI9Q=";

  var remoteviewController = Rxn<VideoViewController>();
  Future<void> joinasaudi() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    await _engine.enableVideo();
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          if (remoteUid == arg["agoraUid"]) {
            remoteviewController.value = VideoViewController.remote(
              rtcEngine: _engine,
              canvas: VideoCanvas(uid: remoteUid),
              connection: connection,
            );
          }
        },

        onRemoteVideoStateChanged:
            (connection, remoteUid, state, reason, elapsed) {
              if (remoteUid == arg["agoraUid"] &&
                  state == RemoteVideoState.remoteVideoStateDecoding) {
                if (remoteviewController.value == null) {
                  remoteviewController.value = VideoViewController.remote(
                    rtcEngine: _engine,
                    canvas: VideoCanvas(uid: remoteUid),
                    connection: connection,
                  );
                }
              }
            },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              if (remoteUid == arg["agoraUid"]) {
                remoteviewController.value = null;

                Get.back();
              }
            },
      ),
    );
    await _engine.joinChannel(
      token: appToken,
      channelId: channelName,
      uid: 0,
      options: ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        publishCameraTrack: false,
        publishMicrophoneTrack: false,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  Future<void> updateviews(int amount) async {
    try {
      FirebaseFirestore.instance
          .collection("LiveStream")
          .doc(arg["uid"])
          .update({"views": FieldValue.increment(amount)});
    } catch (e) {
      debugPrint("views related issue $e");
    }
  }

  final currenduser = FirebaseAuth.instance.currentUser!.uid;
  Future<void> checkFollowers() async {
    var doc = await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(arg["uid"])
        .collection("Followers")
        .doc(currenduser)
        .get();
    isfollowing.value = doc.exists;
  }

  Future<void> toggleFollow() async {
    // 1. Instantly flip the UI button state
    isfollowing.toggle();

    // 2. Setup references for the Host (The person being watched)
    var hostProfileRef = FirebaseFirestore.instance
        .collection("userProfile")
        .doc(arg["uid"]);
    var hostFollowersSub = hostProfileRef
        .collection("Followers")
        .doc(currenduser);

    // 3. Setup references for Me (The person watching)
    var myProfileRef = FirebaseFirestore.instance
        .collection("userProfile")
        .doc(currenduser);
    var myFollowingSub = myProfileRef.collection("Following").doc(arg["uid"]);

    try {
      if (isfollowing.value) {
        // --- ACTION: FOLLOW ---

        // Add me to the Host's "Followers" list
        await hostFollowersSub.set({
          "followerId": currenduser,
          "followAt": FieldValue.serverTimestamp(),
        });
        // Add the Host to my "Following" list
        await myFollowingSub.set({
          "hostId": arg["uid"],
          "followAt": FieldValue.serverTimestamp(),
        });

        // Update the totals on the main profile documents (Safe create if missing)
        await hostProfileRef.set({
          "totalFollowers": FieldValue.increment(1),
        }, SetOptions(merge: true));
        await myProfileRef.set({
          "totalFollowing": FieldValue.increment(1),
        }, SetOptions(merge: true));
      } else {
        // --- ACTION: UNFOLLOW ---
        await hostFollowersSub.delete();
        await myFollowingSub.delete();

        // Get the current count first to make sure we don't go below 0
        var hostDoc = await hostProfileRef.get();
        int currentHostFollowers = hostDoc.data()?['totalFollowers'] ?? 0;

        // Only decrement if the count is greater than 0
        if (currentHostFollowers > 0) {
          await hostProfileRef.set({
            "totalFollowers": FieldValue.increment(-1),
          }, SetOptions(merge: true));
        } else {
          // If it's already 0 or negative, force it to stay at 0
          await hostProfileRef.set({
            "totalFollowers": 0,
          }, SetOptions(merge: true));
        }

        // Do the same for your "following" count
        var myDoc = await myProfileRef.get();
        int currentMyFollowing = myDoc.data()?['totalFollowing'] ?? 0;

        if (currentMyFollowing > 0) {
          await myProfileRef.set({
            "totalFollowing": FieldValue.increment(-1),
          }, SetOptions(merge: true));
        } else {
          await myProfileRef.set({
            "totalFollowing": 0,
          }, SetOptions(merge: true));
        }
      }
    } catch (e) {
      // If something goes wrong (no internet, etc), flip the button back
      isfollowing.toggle();
      debugPrint("Follow Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    checkFollowers();

    joinasaudi();
    updateviews(1);
  }

  @override
  void dispose() {
    updateviews(-1);
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Obx(
              () => remoteviewController.value != null
                  ? AgoraVideoView(controller: remoteviewController.value!)
                  : Text("No one live now"),
            ),
          ),
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
                          backgroundColor: Colors.white,
                          backgroundImage: arg["image"] != null
                              ? NetworkImage(arg["image"]) as ImageProvider
                              : AssetImage(AppImages.coins),
                        ),
                        Gap(5),
                        Text(
                          arg["hostname"] ?? "no name",
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
                          image: AssetImage(AppImages.chat),
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
                      toggleFollow();
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
                  style: IconButton.styleFrom(backgroundColor: Colors.black54),
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
                  style: IconButton.styleFrom(backgroundColor: Colors.black54),
                  onPressed: () {
                    commentController.clear();
                  },
                  icon: Icon(Icons.send_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
