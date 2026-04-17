import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/main_profile_screen.dart';

class FollowersListScreen extends StatelessWidget {
  final String targetUid;
  FollowersListScreen({super.key, required this.targetUid});

  final _db = FirebaseFirestore.instance;
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Followers",
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
        // Target user ki followers sub-collection ko stream karein
        stream: _db
            .collection('userProfile')
            .doc(targetUid)
            .collection('followers')
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

          var followersList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: followersList.length,
            itemBuilder: (context, index) {
              var data = followersList[index].data() as Map<String, dynamic>;
              String fId = followersList[index].id;

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
                trailing: _buildFollowerActionButton(fId, data),
              );
            },
          );
        },
      ),
    );
  }

  // --- Follow Back / Friends Button Logic ---
  Widget _buildFollowerActionButton(
    String userId,
    Map<String, dynamic> userData,
  ) {
    // Agar hum apni list dekh rahe hain, to check karein ke kya humne unhe follow kiya hai
    return StreamBuilder<DocumentSnapshot>(
      stream: _db
          .collection('userProfile')
          .doc(_currentUserId)
          .collection('following')
          .doc(userId)
          .snapshots(),
      builder: (context, snap) {
        bool amIFollowing = snap.hasData && snap.data!.exists;

        // TikTok Logic:
        // 1. Agar mutual hai to "Friends"
        // 2. Agar sirf usne follow kiya hai to "Follow Back"
        return SizedBox(
          height: 32,
          width: 110,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: amIFollowing
                  ? Colors.grey[100]
                  : Colors.pinkAccent,
              elevation: 0,
              side: amIFollowing
                  ? BorderSide(color: Colors.grey.shade300)
                  : BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {
              if (amIFollowing) {
                _showUnfollowDialog(userId, userData['name'] ?? 'User');
              } else {
                _handleFollowBack(userId, userData);
              }
            },
            child: Text(
              amIFollowing ? "Friends" : "Follow Back",
              style: TextStyle(
                color: amIFollowing ? Colors.black : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleFollowBack(String userId, Map<String, dynamic> userData) async {
    // Apni following mein add karein
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
    // Dusre bande ke followers mein apni entry (Controller logic follow karein)
    Get.snackbar("Success", "You started following ${userData['name']}");
  }

  void _showUnfollowDialog(String userId, String name) {
    Get.dialog(
      AlertDialog(
        title: Text("Unfriend $name?"),
        content: const Text(
          "Do you want to remove this person from your friends?",
        ),
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
            child: const Text("Unfriend", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("No followers yet", style: TextStyle(color: Colors.grey)),
    );
  }
}
