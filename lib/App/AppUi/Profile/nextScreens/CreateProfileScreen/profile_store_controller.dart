import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileStoreController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  RxInt isSelected = 0.obs;
  final arg = Get.arguments;

  final user = FirebaseAuth.instance.currentUser!.uid;
  RxString userphoto = "".obs;
  Rxn<File> image = Rxn<File>();
  // refrel system
  String generateReferralCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  Future<void> storeuserprofile() async {
    final shortId = arg["shortId"];
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    String myReferralCode = generateReferralCode();

    try {
      final adduser = {
        "name": nameController.text.toString(),
        "dob": dobController.text.toString(),
        "country": countryController.text.toString(),
        "gender": isSelected.value == 1 ? "Male" : "Female",
        "userimage": image.value != null
            ? image.value!.path
            : userphoto.isNotEmpty
            ? userphoto.value
            : "no phote",

        "createdAt": FieldValue.serverTimestamp(),
        "userId": user,
        "myReferralCode": myReferralCode,
        "shortId": shortId,
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
