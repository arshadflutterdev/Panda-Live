import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pandlive/App/Routes/app_routes.dart';

class LiveSetupScreen extends StatefulWidget {
  const LiveSetupScreen({super.key});

  @override
  State<LiveSetupScreen> createState() => _LiveSetupScreenState();
}

class _LiveSetupScreenState extends State<LiveSetupScreen> {
  late RtcEngine _engine;
  bool _isReadyToPreview = false;
  String selectedFilter = "Natural";
  bool isMuted = false;

  final List<Map<String, dynamic>> filters = [
    {"name": "Natural", "icon": Icons.face},
    {"name": "Beauty", "icon": Icons.auto_fix_high},
    {"name": "Warm", "icon": Icons.wb_sunny},
    {"name": "Cool", "icon": Icons.ac_unit},
  ];

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(appId: "5eda14d417924d9baf39e83613e8f8f5"),
    );

    await _engine.enableVideo();
    await _engine.startPreview();

    setState(() {
      _isReadyToPreview = true;
    });
  }

  Future<void> _applyFilter(String filterName) async {
    setState(() => selectedFilter = filterName);

    BeautyOptions options;
    switch (filterName) {
      case "Beauty":
        options = const BeautyOptions(
          lighteningContrastLevel:
              LighteningContrastLevel.lighteningContrastHigh,
          lighteningLevel: 0.8,
          smoothnessLevel: 0.9,
          rednessLevel: 0.5,
        );
        break;
      case "Warm":
        options = const BeautyOptions(
          lighteningContrastLevel:
              LighteningContrastLevel.lighteningContrastNormal,
          lighteningLevel: 0.5,
          smoothnessLevel: 0.5,
          rednessLevel: 0.9,
        );
        break;
      case "Cool":
        options = const BeautyOptions(
          lighteningContrastLevel:
              LighteningContrastLevel.lighteningContrastNormal,
          lighteningLevel: 0.7,
          smoothnessLevel: 0.4,
          rednessLevel: 0.1,
        );
        break;
      default:
        options = const BeautyOptions(
          lighteningContrastLevel:
              LighteningContrastLevel.lighteningContrastLow,
          lighteningLevel: 0.0,
          smoothnessLevel: 0.0,
          rednessLevel: 0.0,
        );
    }

    await _engine.setBeautyEffectOptions(enabled: true, options: options);
  }

  // --- BUILD METHOD (Iska hona zaroori hai) ---
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitDialog();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _isReadyToPreview
                ? AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  ),

            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _showExitDialog,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: Icon(
                        isMuted ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() => isMuted = !isMuted),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filters.length,
                      itemBuilder: (context, index) {
                        bool isSelected =
                            selectedFilter == filters[index]['name'];
                        return GestureDetector(
                          onTap: () => _applyFilter(filters[index]['name']),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.redAccent
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.white24,
                                    child: Icon(
                                      filters[index]['icon'],
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Gap(5),
                                Text(
                                  filters[index]['name'],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.redAccent
                                        : Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      onPressed: _handleGoLive,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "GO LIVE NOW",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoLive() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      try {
        String channelId = "live_${currentUser.uid}";
        await FirebaseFirestore.instance
            .collection("LiveStream")
            .doc(currentUser.uid)
            .set({
              "hostname": currentUser.displayName ?? 'Guest',
              "uid": currentUser.uid,
              "channelId": channelId,
              "image": currentUser.photoURL ?? "",
              "views": 0,
              "filter": selectedFilter,
              "startedAt": FieldValue.serverTimestamp(),
              "lastHeartbeat": FieldValue.serverTimestamp(),
            });
        Get.back();
        Get.offNamed(
          AppRoutes.golive,
          arguments: {
            "channelId": channelId,
            "hostname": currentUser.displayName ?? "no name",
            "hostphoto": currentUser.photoURL ?? "",
            "selectedFilter": selectedFilter,
            "isMuted": isMuted,
          },
        );
      } catch (e) {
        Get.back();
        Get.snackbar("Error", "$e");
      }
    }
  }

  void _showExitDialog() {
    Get.defaultDialog(
      title: "Exit?",
      middleText: "Band karein?",
      onConfirm: () {
        Get.back();
        Get.back();
      },
      textConfirm: "Yes",
      textCancel: "No",
    );
  }

  @override
  void dispose() {
    _engine.stopPreview();
    _engine.release();
    super.dispose();
  }
}
