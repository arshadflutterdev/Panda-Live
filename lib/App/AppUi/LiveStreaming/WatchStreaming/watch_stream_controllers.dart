import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchStreamControllers extends GetxController {
  RxBool isfollowing = false.obs;
  final currenduser = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController commentController = TextEditingController();

  final arg = Get.arguments;
  Future<void> toggleFollow() async {
    // 1. Instantly flip the UI button state
    isfollowing.toggle();

    // 2. Setup references for the Host (The person being watched)
    var hostProfileRef = FirebaseFirestore.instance
        .collection("userProfile")
        .doc(arg["uid"]);
    var hostFollowersSub = hostProfileRef
        .collection("Followers")
        .doc(currenduser);

    // 3. Setup references for Me (The person watching)
    var myProfileRef = FirebaseFirestore.instance
        .collection("userProfile")
        .doc(currenduser);
    var myFollowingSub = myProfileRef.collection("Following").doc(arg["uid"]);

    try {
      if (isfollowing.value) {
        // --- ACTION: FOLLOW ---

        // Add me to the Host's "Followers" list
        await hostFollowersSub.set({
          "followerId": currenduser,
          "followAt": FieldValue.serverTimestamp(),
        });
        // Add the Host to my "Following" list
        await myFollowingSub.set({
          "hostId": arg["uid"],
          "hostname": arg["hostname"],
          "hostimage": arg["image"],
          "followAt": FieldValue.serverTimestamp(),
        });

        // Update the totals on the main profile documents (Safe create if missing)
        await hostProfileRef.set({
          "totalFollowers": FieldValue.increment(1),
        }, SetOptions(merge: true));
        await myProfileRef.set({
          "totalFollowing": FieldValue.increment(1),
        }, SetOptions(merge: true));
      } else {
        // --- ACTION: UNFOLLOW ---
        await hostFollowersSub.delete();
        await myFollowingSub.delete();

        // Get the current count first to make sure we don't go below 0
        var hostDoc = await hostProfileRef.get();
        int currentHostFollowers = hostDoc.data()?['totalFollowers'] ?? 0;

        // Only decrement if the count is greater than 0
        if (currentHostFollowers > 0) {
          await hostProfileRef.set({
            "totalFollowers": FieldValue.increment(-1),
          }, SetOptions(merge: true));
        } else {
          // If it's already 0 or negative, force it to stay at 0
          await hostProfileRef.set({
            "totalFollowers": 0,
          }, SetOptions(merge: true));
        }

        // Do the same for your "following" count
        var myDoc = await myProfileRef.get();
        int currentMyFollowing = myDoc.data()?['totalFollowing'] ?? 0;

        if (currentMyFollowing > 0) {
          await myProfileRef.set({
            "totalFollowing": FieldValue.increment(-1),
          }, SetOptions(merge: true));
        } else {
          await myProfileRef.set({
            "totalFollowing": 0,
          }, SetOptions(merge: true));
        }
      }
    } catch (e) {
      // If something goes wrong (no internet, etc), flip the button back
      isfollowing.toggle();
      debugPrint("Follow Error: $e");
    }
  }

  Future<void> checkFollowers() async {
    var doc = await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(arg["uid"])
        .collection("Followers")
        .doc(currenduser)
        .get();
    isfollowing.value = doc.exists;
  }
  //below are related comments

  RxString commentuser = "Guest".obs;
  Future<void> commentUsers() async {
    var doc = await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(currenduser)
        .get();
    if (doc.exists) {
      commentuser.value = doc.data()?["name"] ?? "No Name";
    }
  }

  Future<void> sendComment() async {
    if (commentController.text.isEmpty) return;
    String comment = commentController.text.toString();
    commentController.clear();
    try {
      await FirebaseFirestore.instance
          .collection("LiveStream")
          .doc(arg["uid"])
          .collection("Comments")
          .add({
            "userName": commentuser.value,
            "userId": currenduser,
            "comment": comment,
            "sendAt": FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint("Comment error: $e");
    }
  }
}
