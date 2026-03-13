import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  File? idFront, idBack, facePic;
  bool isUploading = false;

  Future<void> pickImage(String type) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        if (type == 'front')
          idFront = File(pickedFile.path);
        else if (type == 'back')
          idBack = File(pickedFile.path);
        else
          facePic = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadFile(File file, String fileName) async {
    Reference ref = FirebaseStorage.instance.ref().child(
      "VerificationDocs/${FirebaseAuth.instance.currentUser!.uid}/$fileName",
    );
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> submitApplication() async {
    if (idFront == null || idBack == null || facePic == null) {
      Get.snackbar(
        "Error",
        "Please upload all required photos",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // 1. Fetch Existing Data from userProfile (for reference)
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .get();

      var userData = userDoc.data() as Map<String, dynamic>;

      // 2. Upload to Storage
      String frontUrl = await uploadFile(idFront!, "id_front.jpg");
      String backUrl = await uploadFile(idBack!, "id_back.jpg");
      String faceUrl = await uploadFile(facePic!, "face_pic.jpg");

      // 3. Save to Subcollection inside userProfile
      // Path: userProfile -> {uid} -> isUserValid -> info
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .collection("isUserValid")
          .doc(
            "verification_data",
          ) // Fixed ID taake history overwrite na ho ya naya doc ban jaye
          .set({
            "userId": userData["userId"] ?? uid,
            "name": userData["name"] ?? "N/A",
            "idCardFront": frontUrl,
            "idCardBack": backUrl,
            "facePic": faceUrl,
            "status": "pending",
            "submittedAt": FieldValue.serverTimestamp(),
          });

      // 4. Main userProfile status update karna (ExplorerScreen isi ko check karegi)
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .update({"isVerified": "pending"});

      Get.back(); // Verification Screen se wapis
      Get.snackbar(
        "Success",
        "Application submitted for review!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Failed to submit: ${e.toString()}");
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Verification"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isUploading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Upload your ID Documents for Verification",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Gap(20),
                  _buildUploadCard(
                    "ID Card Front",
                    idFront,
                    () => pickImage('front'),
                  ),
                  const Gap(15),
                  _buildUploadCard(
                    "ID Card Back",
                    idBack,
                    () => pickImage('back'),
                  ),
                  const Gap(15),
                  _buildUploadCard(
                    "Face Selfie",
                    facePic,
                    () => pickImage('face'),
                  ),
                  const Gap(30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: submitApplication,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Submit Application",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildUploadCard(String title, File? file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[50],
        ),
        child: file == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                  Gap(10),
                  Text(title),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(file, fit: BoxFit.cover),
              ),
      ),
    );
  }
}
