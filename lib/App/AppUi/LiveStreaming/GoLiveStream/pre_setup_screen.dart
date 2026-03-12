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

  // Language Check Logic
  bool get isArabic => Get.locale?.languageCode == 'ar';

  final List<Map<String, dynamic>> filters = [
    {"name": "Natural", "icon": Icons.face},
    {"name": "Beauty", "icon": Icons.auto_fix_high},
    {"name": "Warm", "icon": Icons.wb_sunny},
    {"name": "Cool", "icon": Icons.ac_unit},
    {"name": "Bright", "icon": Icons.light_mode},
    {"name": "Glass", "icon": Icons.blur_on},
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
    await _engine.setBeautyEffectOptions(
      enabled: true,
      options: const BeautyOptions(),
    );
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
          lighteningLevel: 0.7,
          smoothnessLevel: 0.8,
          rednessLevel: 0.3,
        );
        break;
      case "Warm":
        options = const BeautyOptions(
          lighteningContrastLevel:
              LighteningContrastLevel.lighteningContrastNormal,
          lighteningLevel: 0.5,
          smoothnessLevel: 0.5,
          rednessLevel: 0.8,
        );
        break;
      case "Cool":
        options = const BeautyOptions(
          lighteningContrastLevel:
              LighteningContrastLevel.lighteningContrastNormal,
          lighteningLevel: 0.8,
          smoothnessLevel: 0.4,
          rednessLevel: 0.1,
        );
        break;
      case "Bright":
        options = const BeautyOptions(
          lighteningContrastLevel:
              LighteningContrastLevel.lighteningContrastHigh,
          lighteningLevel: 0.9,
          smoothnessLevel: 0.3,
        );
        break;
      case "Glass":
        options = const BeautyOptions(
          lighteningContrastLevel:
              LighteningContrastLevel.lighteningContrastHigh,
          lighteningLevel: 0.6,
          smoothnessLevel: 0.9,
        );
        break;
      default:
        options = const BeautyOptions(
          lighteningContrastLevel:
              LighteningContrastLevel.lighteningContrastLow,
          lighteningLevel: 0.0,
          smoothnessLevel: 0.0,
        );
    }
    await _engine.setBeautyEffectOptions(enabled: true, options: options);
  }

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
                ? SizedBox.expand(
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  ),
            _buildTopBar(),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIcon(Icons.close, _showExitDialog),
          Row(
            children: [
              _circleIcon(isMuted ? Icons.mic_off : Icons.mic, () {
                setState(() => isMuted = !isMuted);
              }),
              const Gap(15),
              _circleIcon(Icons.flip_camera_ios, () async {
                await _engine.switchCamera();
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            selectedFilter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(15),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedFilter == filters[index]['name'];
                return GestureDetector(
                  onTap: () => _applyFilter(filters[index]['name']),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: isSelected
                              ? Colors.redAccent
                              : Colors.white24,
                          child: Icon(
                            filters[index]['icon'],
                            color: Colors.white,
                          ),
                        ),
                        const Gap(5),
                        Text(
                          filters[index]['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Gap(25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: _handleGoLive,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isArabic ? "ابدأ البث المباشر الآن" : "GO LIVE NOW",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.black45,
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Future<void> _handleGoLive() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.redAccent)),
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
              "isMuted": isMuted,
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
        Get.snackbar(
          isArabic ? "خطأ" : "Error",
          isArabic ? "تعذر بدء البث" : "Could not start stream",
        );
      }
    }
  }

  void _showExitDialog() {
    Get.defaultDialog(
      title: isArabic ? "خروج؟" : "Exit?",
      middleText: isArabic ? "هل تريد إغلاق الإعداد؟" : "Close the setup?",
      onConfirm: () {
        Get.back();
        Get.back();
      },
      textConfirm: isArabic ? "نعم" : "Yes",
      textCancel: isArabic ? "لا" : "No",
      buttonColor: Colors.redAccent,
      confirmTextColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _engine.stopPreview();
    _engine.release();
    super.dispose();
  }
}
