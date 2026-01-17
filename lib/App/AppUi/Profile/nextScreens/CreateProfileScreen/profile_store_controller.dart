import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileStoreController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  RxInt isSelected = 0.obs;
  final user = FirebaseAuth.instance.currentUser!.uid;
  RxString userphoto = "".obs;
  Rxn<File> image = Rxn<File>();
  Future<void> storeuserprofile() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final adduser = {
        "name": nameController.text.toString(),
        "dob": dobController.text.toString(),
        "country": countryController.text.toString(),
        "gender": isSelected.value == 1 ? "Male" : "Female",
        "userimage": userphoto.isNotEmpty
            ? userphoto.value
            : image.value != null
            ? image.value!.path
            : "",
        "createdAt": FieldValue.serverTimestamp(),
        "userId": user,
      };
      await firestore.collection("userProfile").doc(user).set(adduser);
      Get.snackbar(
        "Congratulation",
        "All set! Your profile is now complete.",
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        "Error",
        "Failed to save user information",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
