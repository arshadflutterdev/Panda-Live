// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gap/gap.dart';
// import 'package:pandlive/App/Routes/app_routes.dart';

// class LiveSetupScreen extends StatefulWidget {
//   const LiveSetupScreen({super.key});

//   @override
//   State<LiveSetupScreen> createState() => _LiveSetupScreenState();
// }

// class _LiveSetupScreenState extends State<LiveSetupScreen> {
//   String selectedFilter = "Natural";
//   bool isMuted = false;

//   final List<Map<String, dynamic>> filters = [
//     {"name": "Natural", "icon": Icons.face},
//     {"name": "Beauty", "icon": Icons.auto_fix_high},
//     {"name": "Warm", "icon": Icons.wb_sunny},
//     {"name": "Cool", "icon": Icons.ac_unit},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) async {
//         if (didPop) return;
//         _showExitDialog();
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//           children: [
//             // 1. Camera Preview (Yahan Agora ka Preview widget aayega)
//             const Center(
//               child: Icon(Icons.camera_alt, color: Colors.white24, size: 100),
//             ),

//             // 2. Top Controls
//             Positioned(
//               top: 50,
//               left: 20,
//               right: 20,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                     onPressed: () => _showExitDialog(),
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       isMuted ? Icons.mic_off : Icons.mic,
//                       color: Colors.white,
//                     ),
//                     onPressed: () => setState(() => isMuted = !isMuted),
//                   ),
//                 ],
//               ),
//             ),

//             // 3. Bottom Panel (Filters + Go Live)
//             Positioned(
//               bottom: 40,
//               left: 0,
//               right: 0,
//               child: Column(
//                 children: [
//                   // Filter Selection
//                   SizedBox(
//                     height: 90,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       itemCount: filters.length,
//                       itemBuilder: (context, index) {
//                         bool isSelected =
//                             selectedFilter == filters[index]['name'];
//                         return GestureDetector(
//                           onTap: () => setState(
//                             () => selectedFilter = filters[index]['name'],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 20),
//                             child: Column(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 28,
//                                   backgroundColor: isSelected
//                                       ? Colors.redAccent
//                                       : Colors.white24,
//                                   child: Icon(
//                                     filters[index]['icon'],
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const Gap(5),
//                                 Text(
//                                   filters[index]['name'],
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const Gap(30),

//                   // START LIVE BUTTON (Main Action)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: ElevatedButton(
//                       onPressed: () => _handleGoLive(),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.redAccent,
//                         minimumSize: const Size(double.infinity, 55),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       child: const Text(
//                         "GO LIVE NOW",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Step 3: Setup se Actual Live jana
//   Future<void> _handleGoLive() async {
//     final User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       // Loader dikhayen
//       Get.dialog(
//         const Center(child: CircularProgressIndicator(color: Colors.redAccent)),
//         barrierDismissible: false,
//       );

//       try {
//         // Firestore mein entry ab yahan hogi
//         await FirebaseFirestore.instance
//             .collection("LiveStream")
//             .doc(currentUser.uid)
//             .set({
//               "hostname": currentUser.displayName ?? 'Guest',
//               "uid": currentUser.uid,
//               "channelId": "testingChannel",
//               "image": currentUser.photoURL ?? "",
//               "views": 0,
//               "filter": selectedFilter, // Selected filter save karein
//               "startedAt": FieldValue.serverTimestamp(),
//               "lastHeartbeat": FieldValue.serverTimestamp(),
//             });

//         Get.back(); // Loader band karein

//         // Asli Live Screen par bhej dein
//         Get.offNamed(
//           AppRoutes.golive,
//           arguments: {
//             "channelId": "testingChannel",
//             "hostname": currentUser.displayName ?? "no name",
//             "hostphoto": currentUser.photoURL ?? "",
//             "selectedFilter": selectedFilter,
//             "isMuted": isMuted,
//           },
//         );
//       } catch (e) {
//         Get.back();
//         Get.snackbar("Error", "Could not start stream: $e");
//       }
//     }
//   }

//   void _showExitDialog() {
//     Get.defaultDialog(
//       title: "Exit Setup?",
//       middleText: "Are you sure you want to go back?",
//       textConfirm: "Yes",
//       textCancel: "No",
//       confirmTextColor: Colors.white,
//       onConfirm: () {
//         Get.back(); // Dialog band
//         Get.back(); // Setup screen band
//       },
//     );
//   }
// }
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
  RtcEngine? _engine;
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
    initAgoraPreview();
  }

  // Sirf Camera Preview start karne ke liye logic
  Future<void> initAgoraPreview() async {
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(
      const RtcEngineContext(
        appId: "5eda14d417924d9baf39e83613e8f8f5", // Aapka App ID
      ),
    );

    await _engine!.enableVideo();
    await _engine!.startPreview(); // Yeh sirf local camera on karega

    // Default beauty options
    await _applyFilter("Natural");

    if (mounted) {
      setState(() {
        _isReadyToPreview = true;
      });
    }
  }

  // Filter apply karne ka function
  Future<void> _applyFilter(String filterName) async {
    setState(() => selectedFilter = filterName);

    BeautyOptions options;
    switch (filterName) {
      case "Beauty":
        options = const BeautyOptions(
          lighteningLevel: 0.7,
          smoothnessLevel: 0.8,
          rednessLevel: 0.3,
        );
        break;
      case "Warm":
        options = const BeautyOptions(lighteningLevel: 0.3, rednessLevel: 0.5);
        break;
      default:
        options = const BeautyOptions(
          lighteningLevel: 0.0,
          smoothnessLevel: 0.0,
        );
    }

    await _engine?.setBeautyEffectOptions(enabled: true, options: options);
  }

  // Go Live Button Logic
  Future<void> _handleGoLive() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Loader show karein
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.redAccent)),
      barrierDismissible: false,
    );

    try {
      // --- CRITICAL STEP: Release Engine ---
      // Taake GoLiveScreen par naya engine crash na ho
      if (_engine != null) {
        await _engine!.stopPreview();
        await _engine!.release();
        _engine = null;
      }

      String channelId = "live_${currentUser.uid}";

      // Firestore mein basic entry (agoraUid null rakhein)
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
            "agoraUid": null, // Host join hone par update hoga
            "startedAt": FieldValue.serverTimestamp(),
            "lastHeartbeat": FieldValue.serverTimestamp(),
          });

      Get.back(); // Close loader

      // Transition to GoLiveScreen
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
      Get.snackbar("Error", "Setup failed: $e");
    }
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
            // Agora Video Preview
            _isReadyToPreview && _engine != null
                ? SizedBox.expand(
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  ),

            _buildUIOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildUIOverlay() {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Bar
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconButton(Icons.close, _showExitDialog),
                Row(
                  children: [
                    _iconButton(isMuted ? Icons.mic_off : Icons.mic, () {
                      setState(() => isMuted = !isMuted);
                    }),
                    const Gap(15),
                    _iconButton(Icons.flip_camera_ios, () async {
                      await _engine?.switchCamera();
                    }),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Controls
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                _buildFilterList(),
                const Gap(30),
                _buildGoLiveButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterList() {
    return SizedBox(
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
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: isSelected
                        ? Colors.redAccent
                        : Colors.white24,
                    child: Icon(filters[index]['icon'], color: Colors.white),
                  ),
                  const Gap(5),
                  Text(
                    filters[index]['name'],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoLiveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        onPressed: _handleGoLive,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "GO LIVE NOW",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.black45,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  void _showExitDialog() {
    Get.defaultDialog(
      title: "Exit Setup?",
      middleText: "Go back to explorer?",
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
    _engine?.stopPreview();
    _engine?.release();
    super.dispose();
  }
}
