import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:pandlive/App/Routes/app_routes.dart';

class LiveSetupScreen extends StatefulWidget {
  const LiveSetupScreen({super.key});

  @override
  State<LiveSetupScreen> createState() => _LiveSetupScreenState();
}

class _LiveSetupScreenState extends State<LiveSetupScreen> {
  String selectedFilter = "Natural";
  bool isMuted = false;

  final List<Map<String, dynamic>> filters = [
    {"name": "Natural", "icon": Icons.face},
    {"name": "Beauty", "icon": Icons.auto_fix_high},
    {"name": "Warm", "icon": Icons.wb_sunny},
    {"name": "Cool", "icon": Icons.ac_unit},
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _showExitDialog();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // 1. Camera Preview (Yahan Agora ka Preview widget aayega)
            const Center(
              child: Icon(Icons.camera_alt, color: Colors.white24, size: 100),
            ),

            // 2. Top Controls
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => _showExitDialog(),
                  ),
                  IconButton(
                    icon: Icon(
                      isMuted ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                    onPressed: () => setState(() => isMuted = !isMuted),
                  ),
                ],
              ),
            ),

            // 3. Bottom Panel (Filters + Go Live)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Filter Selection
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filters.length,
                      itemBuilder: (context, index) {
                        bool isSelected =
                            selectedFilter == filters[index]['name'];
                        return GestureDetector(
                          onTap: () => setState(
                            () => selectedFilter = filters[index]['name'],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
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
                  const Gap(30),

                  // START LIVE BUTTON (Main Action)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      onPressed: () => _handleGoLive(),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 3: Setup se Actual Live jana
  Future<void> _handleGoLive() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Loader dikhayen
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.redAccent)),
        barrierDismissible: false,
      );

      try {
        // Firestore mein entry ab yahan hogi
        await FirebaseFirestore.instance
            .collection("LiveStream")
            .doc(currentUser.uid)
            .set({
              "hostname": currentUser.displayName ?? 'Guest',
              "uid": currentUser.uid,
              "channelId": "testingChannel",
              "image": currentUser.photoURL ?? "",
              "views": 0,
              "filter": selectedFilter, // Selected filter save karein
              "startedAt": FieldValue.serverTimestamp(),
              "lastHeartbeat": FieldValue.serverTimestamp(),
            });

        Get.back(); // Loader band karein

        // Asli Live Screen par bhej dein
        Get.offNamed(
          AppRoutes.golive,
          arguments: {
            "channelId": "testingChannel",
            "hostname": currentUser.displayName ?? "no name",
            "hostphoto": currentUser.photoURL ?? "",
            "selectedFilter": selectedFilter,
            "isMuted": isMuted,
          },
        );
      } catch (e) {
        Get.back();
        Get.snackbar("Error", "Could not start stream: $e");
      }
    }
  }

  void _showExitDialog() {
    Get.defaultDialog(
      title: "Exit Setup?",
      middleText: "Are you sure you want to go back?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Dialog band
        Get.back(); // Setup screen band
      },
    );
  }
}
