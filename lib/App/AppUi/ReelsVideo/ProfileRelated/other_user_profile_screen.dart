import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class OtherUserProfile extends StatefulWidget {
  final String targetUserId; // Jiski profile dekhni hai

  const OtherUserProfile({super.key, required this.targetUserId});

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  RxMap userData = {}.obs;
  RxBool isLoading = true.obs;
  RxInt followers = 0.obs;
  RxInt following = 0.obs;

  @override
  void initState() {
    super.initState();
    fetchOtherUserData();
  }

  Future<void> fetchOtherUserData() async {
    try {
      // 1. Get User Basic Info
      var snapshot = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(widget.targetUserId)
          .get();

      if (snapshot.exists) {
        userData.value = snapshot.data()!;
      }

      // 2. Get Followers/Following Count
      var followersSnap = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(widget.targetUserId)
          .collection("Followers")
          .get();

      var followingSnap = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(widget.targetUserId)
          .collection("Following")
          .get();

      followers.value = followersSnap.docs.length;
      following.value = followingSnap.docs.length;
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile", style: AppStyle.btext),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        if (userData.isEmpty) {
          return const Center(child: Text("User not found"));
        }

        return Column(
          children: [
            const Gap(20),
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        userData['userimage'] != null &&
                            userData['userimage'].toString().startsWith('http')
                        ? NetworkImage(userData['userimage'])
                        : const AssetImage(AppImages.girl) as ImageProvider,
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userData['name'] ?? "No Name",
                        style: AppStyle.logo.copyWith(fontSize: 22),
                      ),
                      if (userData['isVerified'] == true)
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 20,
                        ),
                    ],
                  ),
                  Text(
                    "ID: ${userData['shortId'] ?? 'N/A'}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Gap(30),
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn("Followers", followers.value),
                _buildStatColumn("Following", following.value),
              ],
            ),
            const Gap(40),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement Follow Logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        "Follow",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement Message Logic
                      },
                      child: const Text("Message"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
