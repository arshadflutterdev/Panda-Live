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
    // 1. Validation Check
    if (topic.isEmpty || detail.isEmpty) {
      Get.snackbar(
        "Khali Field",
        "Meherbani karke saari maloomat darj karein.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        Get.snackbar("Error", "User login nahi hai.");
        return;
      }

      // 2. Fetch User Profile
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        Get.snackbar("Error", "User profile nahi mil rahi.");
        return;
      }

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String userName = userData['name'] ?? "Unknown";
      int shortId = userData['shortId'] ?? 0;
      String country = userData['country'] ?? "Not Specified";

      // 3. Save to Firestore
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
            'images': [],
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
          });

      // --- SUCCESS MESSAGE ---
      Get.snackbar(
        "Shukriya",
        "Aapki request submit ho gayi hai!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      // Submit hone ke baad screen wapas le jayein
      Get.back();
    } catch (e) {
      // --- INTERNET / SERVER ERROR MESSAGE ---
      print("Firestore Error: $e");
      Get.snackbar(
        "Submit Nahi Hua",
        "Internet ka masla hai ya server busy hai. Dobara try karein.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.wifi_off, color: Colors.white),
      );
    } finally {
      // Spinner ko har haal mein band karna hai
      isLoading.value = false;
    }
  }
}
