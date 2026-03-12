// ... baki imports wahi rahenge
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:pandlive/google_ads.dart';

// ... (Imports wahi rahenge jo pehle thay)

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final HelpController _helpController = Get.put(HelpController());
  final TextEditingController detailCtrl = TextEditingController();

  String? selectedTopic;
  String? selectedPlatform;

  final List<String> topics = [
    'General Inquiry',
    'Bug Report',
    'Account Verification (Blue Tick) 🌟',
  ];
  final List<String> platforms = [
    'TikTok',
    'Instagram',
    'YouTube',
    'Facebook',
    'Other',
  ];

  // Media Files
  File? accountVideo, faceVideo, accountPic, facePic;
  final ImagePicker picker = ImagePicker();

  Future<void> pickMedia(bool isVideo, String type) async {
    final XFile? file = isVideo
        ? await picker.pickVideo(source: ImageSource.gallery)
        : await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (file != null) {
      setState(() {
        if (type == "accVid") accountVideo = File(file.path);
        if (type == "faceVid") faceVideo = File(file.path);
        if (type == "accPic") accountPic = File(file.path);
        if (type == "facePic") facePic = File(file.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            AdController().tryShowAd();
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text("Help & Support"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Topic",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDropdown(
              topics,
              selectedTopic,
              (val) => setState(() => selectedTopic = val),
            ),

            if (selectedTopic == 'Account Verification (Blue Tick) 🌟') ...[
              const SizedBox(height: 20),
              const Text(
                "Select Platform",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                platforms,
                selectedPlatform,
                (val) => setState(() => selectedPlatform = val),
              ),

              const SizedBox(height: 20),
              const Text(
                "Upload Required Media",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.4,
                children: [
                  _mediaTile(
                    "Account Video",
                    Icons.videocam,
                    accountVideo != null,
                    () => pickMedia(true, "accVid"),
                  ),
                  _mediaTile(
                    "Face Video",
                    Icons.face,
                    faceVideo != null,
                    () => pickMedia(true, "faceVid"),
                  ),
                  _mediaTile(
                    "Account SS",
                    Icons.image,
                    accountPic != null,
                    () => pickMedia(false, "accPic"),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),
            const Text(
              "Describe Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: detailCtrl,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter details here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: _helpController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (selectedTopic ==
                              'Account Verification (Blue Tick) 🌟') {
                            _helpController.submitVerification(
                              platform: selectedPlatform ?? "Unknown",
                              detail: detailCtrl.text,
                              accountVid: accountVideo,
                              faceVid: faceVideo,
                              accountImg: accountPic,
                              faceImg: facePic,
                            );
                          } else {
                            // Normal issue logic
                          }
                        },
                        child: const Text(
                          "Submit Request",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> list,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          items: list
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _mediaTile(
    String title,
    IconData icon,
    bool isDone,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDone ? Colors.green.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDone ? Colors.green : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDone ? Icons.check_circle : icon,
              color: isDone ? Colors.green : Colors.blue,
            ),
            Text(title, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class HelpController extends GetxController {
  var isLoading = false.obs;

  Future<void> submitVerification({
    required String platform,
    required String detail,
    File? accountVid,
    File? faceVid,
    File? accountImg,
    File? faceImg,
  }) async {
    isLoading.value = true;
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      Map<String, String> urls = {};

      // Helper function to upload files
      Future<String> uploadFile(File file, String folder) async {
        String fileName = "${DateTime.now().millisecondsSinceEpoch}.dat";
        Reference ref = FirebaseStorage.instance.ref().child(
          "Verification/$uid/$folder/$fileName",
        );
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      }

      // Uploading all files if they exist
      if (accountVid != null)
        urls['accountVideo'] = await uploadFile(accountVid, "videos");
      if (faceVid != null)
        urls['faceVideo'] = await uploadFile(faceVid, "videos");
      if (accountImg != null)
        urls['accountPic'] = await uploadFile(accountImg, "images");
      if (faceImg != null)
        urls['facePic'] = await uploadFile(faceImg, "images");

      // Saving to Firestore Sub-collection
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .collection(
            'verification_requests',
          ) // Jaisa notification hai waisa hi ye banega
          .add({
            'platform': platform,
            'details': detail,
            'mediaUrls': urls,
            'status': 'pending',
            'requestedAt': FieldValue.serverTimestamp(),
          });

      Get.back();
      Get.snackbar(
        "Success",
        "Your verification request has been submitted!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to upload: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Normal help request function
  Future<void> submitIssue({
    required String topic,
    required String detail,
    List<File>? images,
  }) async {
    // ... (aapka purana normal help request logic yahan aayega)
  }
}
