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
    // 1. Khali fields check karein
    if (topic.isEmpty || detail.isEmpty) {
      Get.snackbar(
        "Incomplete Submission",
        "Please complete all required fields before submitting",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 2. User login hai ya nahi?
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        Get.snackbar("Error", "App not logged In.");
        return;
      }

      // 3. User ka profile data nikaalein (Name, ID, Country)
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .get();

      String userName = "Unknown User";
      int shortId = 0;
      String country = "Not Specified";

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userName = userData['name'] ?? "Unknown";
        shortId = userData['shortId'] ?? 0;
        country = userData['country'] ?? "Not Specified";
      }

      // 4. Firestore mein Data Save karein
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .collection('help_requests')
          .add({
            'userId': uid,
            'userName': userName,
            'shortId': shortId,
            'country': country,
            'topic': topic,
            'detail': detail,
            'images': [], // Abhi storage off hai isliye empty list
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
          });

      // 5. Success Message dikhaein
      Get.snackbar(
        "All Set!",
        "Your request was submitted successfully. We’ll update you soon.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 2),
      );

      // 6. Thoda wait karein taake user snackbar dekh sake, phir back jayein
      await Future.delayed(const Duration(seconds: 2));
      Get.back();
    } catch (e) {
      // 7. Internet ya kisi aur error ka message
      print("Firestore Error: $e");
      Get.snackbar(
        "Submission Failed",
        "There seems to be an internet connection issue. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.wifi_off, color: Colors.white),
      );
    } finally {
      // Spinner band karein
      isLoading.value = false;
    }
  }
}
