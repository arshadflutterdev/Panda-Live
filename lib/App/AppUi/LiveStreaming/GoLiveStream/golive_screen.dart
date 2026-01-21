import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:permission_handler/permission_handler.dart';

class GoliveScreen extends StatefulWidget {
  const GoliveScreen({super.key});

  @override
  State<GoliveScreen> createState() => _GoliveScreenState();
}

class _GoliveScreenState extends State<GoliveScreen> {
  var data = Get.arguments;
  late String channelId;
  late String hostname;
  late String hostphoto;

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

          // STEP A: Create the controller ONLY when the connection is active
          _localviewController = VideoViewController(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
          );

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
        onError: (ErrorCodeType err, String msg) {
          debugPrint("Agora Error: $err - $msg");
        },
      ),
    );

    // 4. Config Hardware
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

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
  RxInt fakeviews = 5.obs;
  RxBool isloading = false.obs;
  @override
  void initState() {
    super.initState();
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

  // Helper to start timers only when live
  void _startLiveTimers() {
    liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      liveSeconds.value++;
    });

    viewss = Timer.periodic(const Duration(seconds: 4), (timer) {
      fakeviews.value += Random().nextInt(3);
    });
  }

  @override
  void dispose() {
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
                                IconButton(
                                  onPressed: () {
                                    _engine.switchCamera();
                                  },
                                  icon: Icon(
                                    Icons.cameraswitch,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.white,
                                ),

                                Gap(3),
                                Obx(
                                  () => Text(
                                    remoteUsers.length.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
