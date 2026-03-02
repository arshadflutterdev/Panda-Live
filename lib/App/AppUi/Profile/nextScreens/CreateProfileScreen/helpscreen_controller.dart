import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Make sure this is imported

class HelpController extends GetxController {
  var isLoading = false.obs;

  Future<void> submitIssue({
    required String topic,
    required String detail,
    required List<File> images,
  }) async {
    if (topic.isEmpty || detail.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 1. Get current User ID
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      List<String> imageUrls = [];

      // 2. Upload Images to Storage
      for (var image in images) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('help_images')
            .child(uid) // Store images in a folder named after the user
            .child('$fileName.jpg');

        await ref.putFile(image);
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // 3. Save to Subcollection: userProfile -> {uid} -> help_requests
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .collection('help_requests')
          .add({
            'topic': topic,
            'detail': detail,
            'images': imageUrls,
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
          });

      Get.snackbar(
        "Success",
        "Issue submitted successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back();
    } catch (e) {
      print("Firebase Error: $e");
      Get.snackbar("Error", "Something went wrong.");
    } finally {
      isLoading.value = false;
    }
  }
}
