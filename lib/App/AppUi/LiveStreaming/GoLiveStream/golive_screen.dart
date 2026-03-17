import 'dart:async';
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
  //lets start for 3 hours a day

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

  //here is function to earn coins
  Timer? coinstimer;
  final int coinsperminute = 50;
  void startCoinsTimer() {
    coinstimer?.cancel();
    coinstimer = Timer.periodic(Duration(minutes: 1), (_) => awardCoins());
  }

  Future<void> awardCoins() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final userId = user.uid;

      final userDoc = FirebaseFirestore.instance
          .collection("userProfile")
          .doc(userId);
      DateTime now = DateTime.now();
      String today =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userDoc);

        if (!snapshot.exists ||
            snapshot.data() == null ||
            snapshot.data()?["coins"] == null) {
          // Agar document pehle nahi hai, create kar do with 10 coins
          transaction.set(userDoc, {
            "coins": coinsperminute,
            "dailyCoinsEarned": coinsperminute,
            "lastAwardDate": today,
            "cycleStartDate": today,
          }, SetOptions(merge: true));
          debugPrint("Fields initialized for the first time!");
          return;
        }
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        int totalCoins = data["coins"] ?? 0;
        int dailyEarned = data["dailyCoinsEarned"] ?? 0;
        String lastDate = data["lastAwardDate"] ?? "";
        String cycleStartedDatestr = data["cycleStartDate"] ?? today;
        DateTime cycleStart = DateTime.parse(cycleStartedDatestr);
        // Sirf date compare karne ke liye midnight normalize karna zaruri hai
        int daysDifference = DateTime(now.year, now.month, now.day)
            .difference(
              DateTime(cycleStart.year, cycleStart.month, cycleStart.day),
            )
            .inDays;
        if (daysDifference >= 5) {
          if (totalCoins < 45000) {
            totalCoins = 0; // Target poora nahi hua, coins zero
            debugPrint(
              "Target missed ($totalCoins < 45000). Resetting coins to 0.",
            );
          } else {
            debugPrint("Target Achieved! Coins Safe.");
          }
          cycleStartedDatestr = today;
          dailyEarned = 0;
        }
        if (lastDate != today) {
          dailyEarned = 0;
        }
        if (dailyEarned < 9000) {
          int remainingCoins = 9000 - dailyEarned;
          int coinsToAdd = (remainingCoins >= coinsperminute)
              ? coinsperminute
              : remainingCoins;
          transaction.update(userDoc, {
            "coins": totalCoins + coinsToAdd,
            "dailyCoinsEarned": dailyEarned + coinsToAdd,
            "lastAwardDate": today,
            "cycleStartDate": cycleStartedDatestr,
          });
          debugPrint(
            "Host awarded $coinsToAdd coins. Daily total: ${dailyEarned + coinsToAdd}",
          );
        } else {
          // int coins = snapshot.data()?["coins"] ?? 0;
          // transaction.update(userDoc, {"coins": coins + coinsperminute});
          debugPrint("Daily limit reached. No more coins for today.");
        }
      });

      debugPrint("Host awarded $coinsperminute coins!");
    } catch (e) {
      debugPrint("error awarding coins: $e");
    }
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
      "007eJxTYMhavqWwqPbIwua2X5fu7+7ouNlrJFKvUnnLaMJqncWh680VGCxTjJPMzU3TjI0tU0xSEtMskgxN0wyTzVMMkpPN04zTrgjtzGwIZGQ40qjMzMgAgSA+H0NJanFJZl66c0ZiXl5qDgMDAGbnJaE=";
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
          startCoinsTimer();
          // _startLiveTimers();
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
    await _engine.enableAudio();
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileSpeechStandard,
      scenario: AudioScenarioType.audioScenarioDefault,
    );

    // Noise suppression, echo cancellation, auto gain control
    await _engine.setParameters('{"che.audio.enableNoiseSuppression":true}');
    await _engine.setParameters('{"che.audio.enableAEC":true}');
    await _engine.setParameters('{"che.audio.enableAGC":true}');
    await _engine.enableVideo();
    // Default beauty settings
    await _engine.setBeautyEffectOptions(
      enabled: true,
      options: const BeautyOptions(
        lighteningContrastLevel:
            LighteningContrastLevel.lighteningContrastNormal,
        lighteningLevel: 0.7, // Skin tone brightness
        smoothnessLevel: 0.5, // Skin smoothness
        rednessLevel: 0.1, // Blush
      ),
    );
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
  final List<Map<String, dynamic>> filters = [
    {
      'name': 'Original',
      'img':
          'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=200',
      'smooth': 0.0,
      'light': 0.0,
      'enabled': false,
    },
    {
      'name': 'Natural',
      'img':
          'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=200',
      'smooth': 0.5,
      'light': 0.6,
      'enabled': true,
    },
    {
      'name': 'Bright',
      'img':
          'https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&w=200',
      'smooth': 0.6,
      'light': 0.8,
      'enabled': true,
    },
    {
      'name': 'Glossy',
      'img':
          'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg?auto=compress&cs=tinysrgb&w=200',
      'smooth': 0.8,
      'light': 0.5,
      'enabled': true,
    },
    {
      'name': 'Whiten',
      'img':
          'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=200',
      'smooth': 0.4,
      'light': 0.9,
      'enabled': true,
    },
    {
      'name': 'Soft',
      'img':
          'https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=200',
      'smooth': 0.9,
      'light': 0.3,
      'enabled': true,
    },
    {
      'name': 'Fair',
      'img':
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=200',
      'smooth': 0.7,
      'light': 0.7,
      'enabled': true,
    },
    {
      'name': 'Radiant',
      'img':
          'https://images.pexels.com/photos/1516680/pexels-photo-1516680.jpeg?auto=compress&cs=tinysrgb&w=200',
      'smooth': 0.5,
      'light': 0.5,
      'enabled': true,
    },
  ];
  // final List<Map<String, dynamic>> filters = [
  //   {
  //     'name': 'Original',
  //     'img': 'assets/f0.png',
  //     'smooth': 0.0,
  //     'light': 0.0,
  //     'enabled': false,
  //   },
  //   {
  //     'name': 'Natural',
  //     'img': 'assets/f1.png',
  //     'smooth': 0.5,
  //     'light': 0.6,
  //     'enabled': true,
  //   }, // Default
  //   {
  //     'name': 'Bright',
  //     'img': 'assets/f2.png',
  //     'smooth': 0.6,
  //     'light': 0.8,
  //     'enabled': true,
  //   },
  //   {
  //     'name': 'Glossy',
  //     'img': 'assets/f3.png',
  //     'smooth': 0.8,
  //     'light': 0.5,
  //     'enabled': true,
  //   },
  //   {
  //     'name': 'Whiten',
  //     'img': 'assets/f4.png',
  //     'smooth': 0.4,
  //     'light': 0.9,
  //     'enabled': true,
  //   },
  //   {
  //     'name': 'Soft',
  //     'img': 'assets/f5.png',
  //     'smooth': 0.9,
  //     'light': 0.3,
  //     'enabled': true,
  //   },
  //   {
  //     'name': 'Fair',
  //     'img': 'assets/f6.png',
  //     'smooth': 0.7,
  //     'light': 0.7,
  //     'enabled': true,
  //   },
  //   {
  //     'name': 'Radiant',
  //     'img': 'assets/f7.png',
  //     'smooth': 0.5,
  //     'light': 0.5,
  //     'enabled': true,
  //   },
  // ];

  // Default selection index 1 rakhein (Natural filter ke liye)
  RxInt selectedFilterIndex = 1.obs;

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

  //filters
  // Beauty levels ke liye variables (Optional: aap GetX use kar sakte hain)
  RxDouble smoothness = 0.5.obs;
  RxDouble lightening = 0.7.obs;

  void applyFilter(
    int index,
    double smooth,
    double light,
    bool isEnabled,
  ) async {
    selectedFilterIndex.value = index;

    if (_engine != null) {
      await _engine.setBeautyEffectOptions(
        enabled: isEnabled,
        options: BeautyOptions(
          lighteningContrastLevel:
              LighteningContrastLevel.lighteningContrastNormal,
          lighteningLevel: light,
          smoothnessLevel: smooth,
          rednessLevel: 0.1, // Slight pinkish touch for natural look
        ),
      );
    }
  }

  RxBool showFilterList = false.obs;

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
  void _startLiveTimers() async {
    _startHeartbeat();

    liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
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
    coinstimer?.cancel();
    liveTimer?.cancel();

    if (isShutdown) return;
    isShutdown = true;

    // Stop all timers regardless of whether they are active or not
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
                  Obx(
                    () => showFilterList.value
                        ? Positioned(
                            bottom: height * 0.18,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 110,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                itemCount: filters.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => applyFilter(
                                      index,
                                      filters[index]['smooth'],
                                      filters[index]['light'],
                                      filters[index]['enabled'],
                                    ),
                                    child: Obx(
                                      () => Column(
                                        children: [
                                          // ListView.builder ke andar decoration ko replace karein
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 5,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                              border: Border.all(
                                                color:
                                                    selectedFilterIndex.value ==
                                                        index
                                                    ? Colors.pinkAccent
                                                    : Colors.white,
                                                width:
                                                    selectedFilterIndex.value ==
                                                        index
                                                    ? 3
                                                    : 1.5,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Image.network(
                                                filters[index]['img'],
                                                fit: BoxFit.cover,
                                                // Loading state handle karein taake user ko khali dabba na dikhe
                                                loadingBuilder:
                                                    (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null)
                                                        return child;
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      );
                                                    },
                                                // Agar internet ka masla ho toh error icon show karein
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 6),
                                          Text(
                                            filters[index]['name'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight:
                                                  selectedFilterIndex.value ==
                                                      index
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 2,
                                                  color: Colors.black,
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
                            ),
                          )
                        : SizedBox.shrink(),
                  ),

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
                            showFilterList.value = !showFilterList.value;
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 25,
                            child: Icon(
                              Icons.face,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
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
                                ? AppStyle.arabictext.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )
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
