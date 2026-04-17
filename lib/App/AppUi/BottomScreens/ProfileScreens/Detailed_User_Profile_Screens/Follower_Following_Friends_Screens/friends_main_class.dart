import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/main_profile_screen.dart';

class FriendsListScreen extends StatelessWidget {
  final String targetUid;
  FriendsListScreen({super.key, required this.targetUid});

  final _db = FirebaseFirestore.instance;
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Friends",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Step 1: Following list fetch karna
        stream: _db
            .collection('userProfile')
            .doc(targetUid)
            .collection('following')
            .snapshots(),
        builder: (context, followingSnap) {
          if (followingSnap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (!followingSnap.hasData || followingSnap.data!.docs.isEmpty) {
            return _buildEmptyState("No following found");
          }

          return StreamBuilder<QuerySnapshot>(
            // Step 2: Followers list fetch karna intersection ke liye
            stream: _db
                .collection('userProfile')
                .doc(targetUid)
                .collection('followers')
                .snapshots(),
            builder: (context, followersSnap) {
              if (!followersSnap.hasData) return const SizedBox();

              // Friends Logic: Wo log jo dono list mein hain
              var followingIds = followingSnap.data!.docs
                  .map((d) => d.id)
                  .toSet();
              var followerIds = followersSnap.data!.docs
                  .map((d) => d.id)
                  .toSet();
              var friendsIds = followingIds.intersection(followerIds).toList();

              if (friendsIds.isEmpty) {
                return _buildEmptyState("No mutual friends yet");
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: friendsIds.length,
                itemBuilder: (context, index) {
                  var fId = friendsIds[index];
                  // Data Following document se nikal rahay hain
                  var doc = followingSnap.data!.docs.firstWhere(
                    (d) => d.id == fId,
                  );
                  var data = doc.data() as Map<String, dynamic>;

                  return ListTile(
                    onTap: () => Get.to(() => ProfileScreen(uid: fId)),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(data['profilePic'] ?? ''),
                    ),
                    title: Text(
                      data['name'] ?? 'User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      "@${data['shortId'] ?? 'user'}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    trailing: _buildActionButton(fId, data['name'] ?? 'User'),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // --- TikTok Style Friends Button ---
  Widget _buildActionButton(String friendId, String friendName) {
    // Agar hum kisi aur ki profile dekh rahe hain to unfriend button nahi dikhana
    if (targetUid != _currentUserId) return const SizedBox();

    return SizedBox(
      height: 32,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: () => _confirmUnfriend(friendId, friendName),
        child: const Text(
          "Friends",
          style: TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // --- Confirmation Box ---
  void _confirmUnfriend(String friendId, String friendName) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Unfriend $friendName?", textAlign: TextAlign.center),
        content: Text(
          "Are you sure you want to remove $friendName from your friends list?",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              _handleUnfriend(friendId);
              Get.back();
            },
            child: const Text(
              "Unfriend",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- Database Logic ---
  void _handleUnfriend(String friendId) async {
    try {
      // 1. Meri Following se delete
      await _db
          .collection('userProfile')
          .doc(_currentUserId)
          .collection('following')
          .doc(friendId)
          .delete();
      // 2. Uske Followers se meri entry delete
      await _db
          .collection('userProfile')
          .doc(friendId)
          .collection('followers')
          .doc(_currentUserId)
          .delete();

      Get.snackbar(
        "Success",
        "Removed from friends",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Action failed");
    }
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
