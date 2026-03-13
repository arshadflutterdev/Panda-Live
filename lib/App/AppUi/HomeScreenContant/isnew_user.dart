// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:gap/gap.dart';
// import 'package:pandlive/App/Routes/app_routes.dart';

// class VerificationScreen extends StatefulWidget {
//   const VerificationScreen({super.key});

//   @override
//   State<VerificationScreen> createState() => _VerificationScreenState();
// }

// class _VerificationScreenState extends State<VerificationScreen> {
//   File? idFront, idBack, facePic;
//   bool isUploading = false;

//   Future<void> pickImage(String type) async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         if (type == 'front')
//           idFront = File(pickedFile.path);
//         else if (type == 'back')
//           idBack = File(pickedFile.path);
//         else
//           facePic = File(pickedFile.path);
//       });
//     }
//   }

//   Future<String> uploadFile(File file, String fileName) async {
//     Reference ref = FirebaseStorage.instance.ref().child(
//       "VerificationDocs/${FirebaseAuth.instance.currentUser!.uid}/$fileName",
//     );
//     UploadTask uploadTask = ref.putFile(file);
//     TaskSnapshot snapshot = await uploadTask;
//     return await snapshot.ref.getDownloadURL();
//   }

//   Future<void> submitApplication() async {
//     if (idFront == null || idBack == null || facePic == null) {
//       Get.snackbar(
//         "Error",
//         "Please upload all photos",
//         backgroundColor: Colors.red,
//       );
//       return;
//     }

//     setState(() => isUploading = true);

//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;

//       // 1. Current user ka data fetch karein (Jo aapne images mein dikhaya)
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection("userProfile")
//           .doc(uid)
//           .get();

//       if (!userDoc.exists) {
//         throw "User profile not found in Firestore";
//       }

//       Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

//       // 2. Storage mein upload karein
//       String frontUrl = await uploadFile(idFront!, "id_front.jpg");
//       String backUrl = await uploadFile(idBack!, "id_back.jpg");
//       String faceUrl = await uploadFile(facePic!, "face_pic.jpg");

//       // 3. Subcollection "isUserValid" mein application save karein
//       // Hum wahi fields use kar rahe hain jo aapke Firestore screenshot mein hain
//       await FirebaseFirestore.instance
//           .collection("userProfile")
//           .doc(uid)
//           .collection("isUserValid")
//           .doc("verification_details")
//           .set({
//             "userId": userData["userId"] ?? uid,
//             "name": userData["name"] ?? "Unknown",
//             "shortId": userData["shortId"] ?? 0,
//             "country": userData["country"] ?? "N/A",
//             "gender": userData["gender"] ?? "N/A",
//             "idCardFront": frontUrl,
//             "idCardBack": backUrl,
//             "facePic": faceUrl,
//             "status": "pending",
//             "submittedAt": FieldValue.serverTimestamp(),
//           });

//       // 4. Main userProfile ka status "pending" (String) kar dein
//       // Note: Pehle ye false (bool) tha, ab ye String ban jayega
//       await FirebaseFirestore.instance
//           .collection("userProfile")
//           .doc(uid)
//           .update({"isVerified": "pending"});

//       Get.offAllNamed(
//         AppRoutes.bottomnav,
//       ); // Success ke baad home ya navbar pe bhejein
//       Get.snackbar(
//         "Success",
//         "Application submitted!",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       print("Verification Error: $e");
//       Get.snackbar("Error", "Submission failed: ${e.toString()}");
//     } finally {
//       setState(() => isUploading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Account Verification"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: isUploading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   const Text(
//                     "Upload your ID Documents for Verification",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const Gap(20),
//                   _buildUploadCard(
//                     "ID Card Front",
//                     idFront,
//                     () => pickImage('front'),
//                   ),
//                   const Gap(15),
//                   _buildUploadCard(
//                     "ID Card Back",
//                     idBack,
//                     () => pickImage('back'),
//                   ),
//                   const Gap(15),
//                   _buildUploadCard(
//                     "Face Selfie",
//                     facePic,
//                     () => pickImage('face'),
//                   ),
//                   const Gap(30),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: submitApplication,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                       ),
//                       child: const Text(
//                         "Submit Application",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildUploadCard(String title, File? file, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 150,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[300]!),
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.grey[50],
//         ),
//         child: file == null
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
//                   Gap(10),
//                   Text(title),
//                 ],
//               )
//             : ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.file(file, fit: BoxFit.cover),
//               ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gap/gap.dart';
import 'package:pandlive/App/Routes/app_routes.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  File? idFront, idBack, facePic;
  bool isUploading = false;

  // Image pick karne aur compress karne ka method
  Future<void> pickImage(String type) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25, // Firestore limit ki wajah se quality kam rakhi hai
      maxWidth:
          600, // Dimensions choti rakhi hain taake Base64 string bohot lambi na ho
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

  // File ko Base64 string mein convert karne ka function
  Future<String> fileToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> submitApplication() async {
    if (idFront == null || idBack == null || facePic == null) {
      Get.snackbar(
        "Required",
        "All photos are mandatory",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // 1. User Profile Data fetch karein
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .get();

      if (!userDoc.exists) throw "User profile not found";
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // 2. Images ko Base64 mein convert karein (Kyuki Storage use nahi ho rahi)
      String frontBase64 = await fileToBase64(idFront!);
      String backBase64 = await fileToBase64(idBack!);
      String faceBase64 = await fileToBase64(facePic!);

      // 3. Subcollection mein data save karein
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .collection("isUserValid")
          .doc("verification_details")
          .set({
            "userId": uid,
            "name": userData["name"] ?? "Unknown",
            "shortId": userData["shortId"] ?? 0,
            "country": userData["country"] ?? "N/A",
            "idCardFront": frontBase64, // Ab ye URL nahi, String data hai
            "idCardBack": backBase64,
            "facePic": faceBase64,
            "status": "pending",
            "submittedAt": FieldValue.serverTimestamp(),
          });

      // 4. Main Profile Status Update
      await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .update({"isVerified": "pending"});

      Get.offAllNamed(AppRoutes.bottomnav);
      Get.snackbar(
        "Success",
        "Application submitted for review!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Firestore limit reached or connection error.");
      print("Error: $e");
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Identity Verification",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: isUploading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Document Upload",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Please upload clear photos of your ID card",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Gap(30),

                  _buildUploadTile(
                    "National ID (Front Side)",
                    idFront,
                    () => pickImage('front'),
                  ),
                  const Gap(20),
                  _buildUploadTile(
                    "National ID (Back Side)",
                    idBack,
                    () => pickImage('back'),
                  ),
                  const Gap(20),
                  _buildUploadTile(
                    "Live Selfie",
                    facePic,
                    () => pickImage('face'),
                  ),

                  const Gap(40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: submitApplication,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "SUBMIT FOR REVIEW",
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildUploadTile(String title, File? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const Gap(8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: file == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: Colors.blue[400],
                      ),
                      const Gap(8),
                      const Text(
                        "Click to upload",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
