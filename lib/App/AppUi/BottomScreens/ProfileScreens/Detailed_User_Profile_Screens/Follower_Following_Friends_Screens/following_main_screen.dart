import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/main_profile_screen.dart';

class FollowingListScreen extends StatelessWidget {
  final String targetUid;
  FollowingListScreen({super.key, required this.targetUid});

  final _db = FirebaseFirestore.instance;
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Following",
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
        // Direct target user ki following sub-collection ko stream karein
        stream: _db
            .collection('userProfile')
            .doc(targetUid)
            .collection('following')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          var followingList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: followingList.length,
            itemBuilder: (context, index) {
              var data = followingList[index].data() as Map<String, dynamic>;
              String fId = followingList[index].id;

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
                trailing: _buildFollowingButton(fId, data),
              );
            },
          );
        },
      ),
    );
  }

  // --- Following/Follow Toggle Button ---
  Widget _buildFollowingButton(String userId, Map<String, dynamic> userData) {
    // Agar ye meri apni following list hai, to hamesha "Following" button dikhao
    if (targetUid == _currentUserId) {
      return _actionButton(
        text: "Following",
        isFollowing: true,
        onTap: () => _showUnfollowDialog(userId, userData['name'] ?? 'User'),
      );
    }

    // Agar hum kisi aur ki list dekh rahe hain, to check karna hoga ke hum usay follow karte hain ya nahi
    return StreamBuilder<DocumentSnapshot>(
      stream: _db
          .collection('userProfile')
          .doc(_currentUserId)
          .collection('following')
          .doc(userId)
          .snapshots(),
      builder: (context, snap) {
        bool isMeFollowing = snap.hasData && snap.data!.exists;

        return _actionButton(
          text: isMeFollowing ? "Following" : "Follow",
          isFollowing: isMeFollowing,
          onTap: () => isMeFollowing
              ? _showUnfollowDialog(userId, userData['name'] ?? 'User')
              : _handleFollow(userId, userData),
        );
      },
    );
  }

  Widget _actionButton({
    required String text,
    required bool isFollowing,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 32,
      width: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isFollowing ? Colors.grey[100] : Colors.pinkAccent,
          elevation: 0,
          side: isFollowing
              ? BorderSide(color: Colors.grey.shade300)
              : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: isFollowing ? Colors.black : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // --- Logic Functions ---
  void _handleFollow(String userId, Map<String, dynamic> userData) async {
    // Follow logic: Apni following mein add karein aur uske followers mein
    await _db
        .collection('userProfile')
        .doc(_currentUserId)
        .collection('following')
        .doc(userId)
        .set({
          'name': userData['name'],
          'profilePic': userData['profilePic'],
          'uid': userId,
          'shortId': userData['shortId'],
        });
    // Yahan apni details bhi uske followers mein dalni hongi (Ye aapke controller mein already logic hogi)
  }

  void _showUnfollowDialog(String userId, String name) {
    Get.dialog(
      AlertDialog(
        title: Text("Unfollow $name?"),
        content: const Text("Do you want to stop following this user?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              _db
                  .collection('userProfile')
                  .doc(_currentUserId)
                  .collection('following')
                  .doc(userId)
                  .delete();
              _db
                  .collection('userProfile')
                  .doc(userId)
                  .collection('followers')
                  .doc(_currentUserId)
                  .delete();
              Get.back();
            },
            child: const Text("Unfollow", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "Not following anyone yet",
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
