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
  Timer? heartbeatTimer;

  void _startHeartbeat() {
    heartbeatTimer?.cancel();
    heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (isJoined.value) {
        try {
          FirebaseFirestore.instance
              .collection("LiveStream")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
                "lastHeartbeat":
                    FieldValue.serverTimestamp(), // This is the heartbeat
              }, SetOptions(merge: true));
        } catch (e) {
          debugPrint("Heartbeat failed: $e");
        }
      }
    });
  }

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
  final String tempToken =
      "007eJxTYKhpaqydHvbuTO70p/EHWyRDX9g+288WUN1d17/jidGqpmQFBssU4yRzc9M0Y2PLFJOUxDSLJEPTNMNk8xSD5GTzNOO0oqOlmQ2BjAw9P+4yMjJAIIjPx1CSWlySmZfunJGYl5eaw8AAAH0YJrE=";
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
          isJoined.value = true;
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
              if (state == ConnectionStateType.connectionStateReconnecting) {
                debugPrint("Host is losing internet...");
                Get.snackbar(
                  "Slow Connection",
                  "Please check your internet.",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
              if (state == ConnectionStateType.connectionStateFailed) {
                Get.snackbar(
                  "Connection Failed",
                  "Could not establish a connection. Please check your internet.",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                _shutdownHost();
                Get.back();
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
      token: tempToken,
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

  Timer? liveTimer;
  RxInt liveSeconds = 0.obs;
  String get liveTime {
    final minutes = liveSeconds.value ~/ 60;
    final seconds = liveSeconds.value % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  final arg = Get.arguments;
  late Timer viewss;

  RxBool isloading = false.obs;
  //Real Cont update for viewrs
  var getComment = FirebaseFirestore.instance.collection("LiveStream");
  late Stream<QuerySnapshot> _commentStream;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    channelId = data["channelId"] ?? "default channel";
    hostname = data["hostname"] ?? "Guest";
    hostphoto = data["hostphoto"] ?? "";
    initAgoraEngine(); // Starts Agora connection
    _commentStream = FirebaseFirestore.instance
        .collection("LiveStream")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Comments")
        .orderBy("sendAt", descending: true)
        .snapshots();
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

  Timer? _backgroundExitTimer;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _engine.muteLocalVideoStream(
        true,
      ); // Stop sending video when app is minimized
      _engine.muteLocalAudioStream(true);
      _backgroundExitTimer = Timer(Duration(seconds: 60), () {
        _shutdownHost();
      });
    } else if (state == AppLifecycleState.resumed) {
      _engine.muteLocalVideoStream(false); // Resume video
      _engine.muteLocalAudioStream(false);
    } else if (state == AppLifecycleState.detached) {
      // Option B: The app is being killed. We MUST attempt to delete the doc.
      // We don't await here because the OS might kill the process immediately,
      // but calling it here gives it the best chance to fire off the request.
      _shutdownHost();
    } else if (state == AppLifecycleState.resumed) {
      _backgroundExitTimer?.cancel();
      // Back to the app
      _engine.muteLocalVideoStream(false);
      _engine.muteLocalAudioStream(false);
    }
  }

  // Helper to start timers only when live
  void _startLiveTimers() {
    _startHeartbeat();
    liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      liveSeconds.value++;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    heartbeatTimer?.cancel();
    _backgroundExitTimer?.cancel();
    if (liveTimer?.isActive ?? false) {
      liveTimer?.cancel();
    }
    _shutdownHost();

    super.dispose();
  }

  bool isShutdown = false;
  Future<void> _shutdownHost() async {
    if (isShutdown) return;
    isShutdown = true;

    // Stop all timers regardless of whether they are active or not
    liveTimer?.cancel();
    heartbeatTimer?.cancel();
    _backgroundExitTimer?.cancel();

    try {
      // Run these even if the timer wasn't active
      await _engine.leaveChannel();
      await _engine.release();
      await removeLivestatus();
      debugPrint("Cleanup complete");
    } catch (e) {
      debugPrint("Error during shutdown: $e");
    }

    // Ensure we go back to the previous screen
    if (Get.currentRoute == AppRoutes.golive) {
      Get.back();
    }
  }

  Future<void> removeLivestatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("LiveStream")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
      debugPrint("Firestore doc deleted successfully");
    }
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
                    bottom: height * 0.050,
                    left: 5,
                    right: 5,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _engine.switchCamera();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 25,
                            child: Image(
                              image: AssetImage(AppImages.switchcamera),
                              color: Colors.white,
                              height: 30,
                            ),
                          ),
                        ),
                        Gap(5),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                                onPressed: () async {
                                  Get.back();
                                  await _shutdownHost();

                                  print("Stream shutdown successfully");
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
                        Gap(5),
                        GestureDetector(
                          onTap: () {
                            isMute.value = !isMute.value;
                            _engine.muteLocalAudioStream(isMute.value);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 25,

                            child: Icon(
                              isMute.value ? Icons.mic_off : Icons.mic,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
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
                      ],
                    ),
                  ),
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom +
                        height * 0.12,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _commentStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return SizedBox();
                        }
                        return Container(
                          width: width,
                          color: Colors.transparent,
                          constraints: BoxConstraints(maxHeight: height * 0.4),
                          child: ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final data =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Wrap(
                                  children: [
                                    Text(
                                      data["userName"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Text(
                                      " : ",
                                      style: TextStyle(color: Colors.amber),
                                    ),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                      ),

                                      child: Text(
                                        data["comment"],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
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
