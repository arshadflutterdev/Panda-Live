import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:permission_handler/permission_handler.dart';

class GoliveScreen extends StatefulWidget {
  const GoliveScreen({super.key});

  @override
  State<GoliveScreen> createState() => _GoliveScreenState();
}

class _GoliveScreenState extends State<GoliveScreen>
    with WidgetsBindingObserver {
  RxBool isMute = false.obs;
  var data = Get.arguments;
  late String channelId;
  late String hostname;
  late String hostphoto;
  final updateview = FirebaseFirestore.instance
      .collection("LiveStream")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  RxList<int> remoteUsers = <int>[].obs; // Stores UIDs of real viewers
  late RtcEngine _engine;
  final String appId = "5eda14d417924d9baf39e83613e8f8f5";
  // final String channelName = "testingChannel";
  VideoViewController? _localviewController;

  Future<void> initAgoraEngine() async {
    // 1. Permissions
    await [Permission.camera, Permission.microphone].request();

    // 2. Initialize Engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    // 3. Register Handler (The MOST important part)
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");

          FirebaseFirestore.instance
              .collection("LiveStream")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
                "agoraUid": connection.localUid,
                "isLive": true,
              }, SetOptions(merge: true));
          // STEP A: Create the controller ONLY when the connection is active

          // STEP B: Update GetX to rebuild the UI
          isJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          if (!remoteUsers.contains(remoteUid)) {
            remoteUsers.add(remoteUid);
          }
        },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              remoteUsers.remove(remoteUid);
            },
        onConnectionStateChanged:
            (
              RtcConnection connection,
              ConnectionStateType state,
              ConnectionChangedReasonType reason,
            ) {
              if (state == ConnectionStateType.connectionStateFailed) {
                Get.snackbar(
                  "Connection Failed",
                  "Could not establish a connection. Please check your internet.",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                _shutdownHost();
                Get.offAllNamed(AppRoutes.explore);
              }
            },

        onError: (ErrorCodeType err, String msg) {
          debugPrint("Agora Error: $err - $msg");
        },
      ),
    );

    // 4. Config Hardware
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();
    _localviewController = VideoViewController(
      rtcEngine: _engine,
      canvas: const VideoCanvas(uid: 0),
    );

    // 5. Join Channel (Await it!)
    await joinChannel();

    // NOTE: Remove setupVideoView() from the bottom of this function.
  }

  Future<void> joinChannel() async {
    await _engine.joinChannel(
      token:
          "007eJxTYLBTUEjz6NANly05L5OmbHQz74ZwMdsiJpML7PzuPoWn1iowWKYYJ5mbm6YZG1ummKQkplkkGZqmGSabpxgkJ5unGafxLi3IbAhkZPhYHM/MyACBID4fQ0lqcUlmXrpzRmJeXmoOAwMAIqYfsA==",
      channelId: channelId,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
  }

  RxInt countdown = 5.obs;
  RxBool showCountdown = true.obs;
  RxBool isJoined = false.obs; // This is the key!

  late Timer liveTimer;
  RxInt liveSeconds = 0.obs;
  String get liveTime {
    final minutes = liveSeconds.value ~/ 60;
    final seconds = liveSeconds.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  late Timer viewss;

  RxBool isloading = false.obs;
  //Real Cont update for viewrs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    channelId = data["channelId"] ?? "default channel";
    hostname = data["hostname"] ?? "Guest";
    hostphoto = data["hostphoto"] ?? "";
    initAgoraEngine(); // Starts Agora connection

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 1) {
        countdown.value--;
      } else {
        // 5 seconds are over
        countdown.value = 0;

        // ONLY hide the countdown if Agora has also joined successfully
        if (isJoined.value == true) {
          showCountdown.value = false;
          timer.cancel();
          _startLiveTimers(); // Start your fake views and clock
        } else {
          // If 5 seconds passed but Agora is slow, we wait.
          debugPrint("Waiting for Agora to join...");
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _engine.muteLocalVideoStream(
        true,
      ); // Stop sending video when app is minimized
      _engine.muteLocalAudioStream(true);
    } else if (state == AppLifecycleState.resumed) {
      _engine.muteLocalVideoStream(false); // Resume video
      _engine.muteLocalAudioStream(false);
    }
  }

  // Helper to start timers only when live
  void _startLiveTimers() {
    liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      liveSeconds.value++;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (liveTimer.isActive) liveTimer.cancel();
    _shutdownHost();

    super.dispose();
  }

  bool isShutdown = false;
  Future<void> _shutdownHost() async {
    if (isShutdown) return;
    isShutdown = true;
    if (liveTimer.isActive) liveTimer.cancel();
    await _engine.leaveChannel();
    await _engine.release();
    await removeLivestatus(); // Delete Firestore doc
  }

  Future<void> removeLivestatus() async {
    FirebaseFirestore.instance
        .collection("LiveStream")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    bool isArabic = Get.locale?.languageCode == "ar";
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Obx(
            () => Container(
              child: Stack(
                children: [
                  isJoined.value && _localviewController != null
                      ? AgoraVideoView(controller: _localviewController!)
                      : Obx(() {
                          if (showCountdown.value || !isJoined.value) {
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
                  //here I will handle the design
                  Positioned(
                    bottom: height * 0.020,
                    left: 5,
                    right: 5,

                    child: Container(
                      height: height * 0.0900,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _engine.switchCamera();
                            },
                            icon: Image(
                              color: Colors.white,
                              height: height * 0.035,
                              image: AssetImage(AppImages.switchcamera),
                            ),
                          ),
                          TextButton(
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
                                  onPressed: () async {
                                    await _shutdownHost();
                                    Get.offAllNamed(AppRoutes.explore);
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
                            child: Text(
                              isArabic ? "نهاء البث" : "EndStream",
                              style: isArabic
                                  ? AppStyle.arabictext
                                  : TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          Obx(
                            () => IconButton(
                              onPressed: () {
                                isMute.value = !isMute.value;
                              },
                              icon: Icon(
                                isMute.value ? Icons.mic_off : Icons.mic,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                  StreamBuilder(
                                    stream: updateview.snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          !snapshot.data!.exists) {
                                        return const Text(
                                          "0",
                                          style: TextStyle(color: Colors.white),
                                        );
                                      }
                                      var data =
                                          snapshot.data!.data()
                                              as Map<String, dynamic>;
                                      int views = data["views"] ?? 0;
                                      return Text(
                                        views.toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                  Gap(3),
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

                        // IconButton(
                        //   style: IconButton.styleFrom(
                        //     backgroundColor: Colors.black54,
                        //   ),
                        //   onPressed: () {
                        //     Get.defaultDialog(
                        //       backgroundColor: Colors.white,
                        //       radius: 12,
                        //       title: isArabic
                        //           ? "هل تريد إنهاء البث المباشر؟"
                        //           : "End Live Stream?",
                        //       titleStyle: isArabic
                        //           ? AppStyle.arabictext.copyWith(
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.bold,
                        //             )
                        //           : const TextStyle(
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //       content: Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //           horizontal: 8,
                        //         ),
                        //         child: Text(
                        //           isArabic
                        //               ? "أنت على وشك إنهاء البث المباشر.\nسيتم إعلام المشاهدين بذلك."
                        //               : "You are about to end your live stream.\nViewers will be notified, dear.",
                        //           textAlign: TextAlign.center,
                        //           style: isArabic
                        //               ? AppStyle.arabictext.copyWith(
                        //                   fontSize: 16,
                        //                 )
                        //               : const TextStyle(fontSize: 15),
                        //         ),
                        //       ),
                        //       cancel: TextButton(
                        //         onPressed: () {
                        //           Get.back();
                        //         },
                        //         child: Text(
                        //           isArabic ? "ابقَ" : "Stay",
                        //           style: isArabic
                        //               ? AppStyle.arabictext.copyWith(
                        //                   fontSize: 18,
                        //                   fontWeight: FontWeight.w600,
                        //                 )
                        //               : const TextStyle(
                        //                   fontSize: 18,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //         ),
                        //       ),
                        //       confirm: TextButton(
                        //         onPressed: () async {
                        //           await _shutdownHost();
                        //           Get.offAllNamed(AppRoutes.explore);
                        //           // --- Optional: Add code here to notify viewers if using backend ---
                        //         },
                        //         child: Text(
                        //           isArabic ? "إنهاء" : "End",
                        //           style: isArabic
                        //               ? AppStyle.arabictext.copyWith(
                        //                   fontSize: 18,
                        //                   color: Colors.red,
                        //                   fontWeight: FontWeight.w600,
                        //                 )
                        //               : const TextStyle(
                        //                   fontSize: 18,
                        //                   color: Colors.red,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   icon: Icon(Icons.close, color: Colors.white),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
