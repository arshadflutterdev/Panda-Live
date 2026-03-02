// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Make sure this is imported

// class HelpController extends GetxController {
//   var isLoading = false.obs;

//   Future<void> submitIssue({
//     required String topic,
//     required String detail,
//     required List<File> images,
//   }) async {
//     if (topic.isEmpty || detail.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Please fill all fields",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     try {
//       isLoading.value = true;

//       // 1. Get current User ID
//       String? uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid == null) {
//         Get.snackbar("Error", "User not logged in");
//         return;
//       }

//       List<String> imageUrls = [];

//       // 2. Upload Images to Storage
//       for (var image in images) {
//         String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//         Reference ref = FirebaseStorage.instance
//             .ref()
//             .child('help_images')
//             .child(uid) // Store images in a folder named after the user
//             .child('$fileName.jpg');

//         await ref.putFile(image);
//         String downloadUrl = await ref.getDownloadURL();
//         imageUrls.add(downloadUrl);
//       }

//       // 3. Save to Subcollection: userProfile -> {uid} -> help_requests
//       await FirebaseFirestore.instance
//           .collection('userProfile')
//           .doc(uid)
//           .collection('help_requests')
//           .add({
//             'topic': topic,
//             'detail': detail,
//             'images': imageUrls,
//             'status': 'pending',
//             'createdAt': FieldValue.serverTimestamp(),
//           });

//       Get.snackbar(
//         "Success",
//         "Issue submitted successfully!",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );

//       Get.back();
//     } catch (e) {
//       print("Firebase Error: $e");
//       Get.snackbar("Error", "Something went wrong.");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelpController extends GetxController {
  var isLoading = false.obs;

  Future<void> submitIssue({
    required String topic,
    required String detail,
    required dynamic images,
  }) async {
    if (topic.isEmpty || detail.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 1. Get Current User UID
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      // 2. Fetch User Profile Data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        Get.snackbar("Error", "User profile not found");
        return;
      }

      // Extract data from document
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String userName = userData['name'] ?? "Unknown";
      int shortId = userData['shortId'] ?? 0;
      String country = userData['country'] ?? "Not Specified";

      // 3. Save Issue to Subcollection with User Details
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .collection('help_requests')
          .add({
            'userId': uid, // UID for tracking
            'userName': userName, // User ka naam
            'shortId': shortId, // User ki ID
            'country': country, // User ki country
            'topic': topic,
            'detail': detail,
            'images': [], // Currently empty because storage is off
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
          });

      Get.snackbar(
        "Success",
        "Issue submitted by $userName",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back();
    } catch (e) {
      print("Firestore Error: $e");
      Get.snackbar("Error", "Check your internet connection.");
    } finally {
      isLoading.value = false;
    }
  }
}
