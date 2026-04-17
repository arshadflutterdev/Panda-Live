import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Image upload ke liye
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  String initialName = "";
  String initialBio = "";
  String currentImageUrl = "";
  File? _selectedImage;
  bool isLoading = false;

  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    var doc = await FirebaseFirestore.instance
        .collection('userProfile')
        .doc(_uid)
        .get();
    if (doc.exists) {
      setState(() {
        initialName = doc['name'] ?? "";
        initialBio = doc['bio'] ?? "";
        currentImageUrl = doc['userimage'] ?? "";

        nameController.text = initialName;
        bioController.text = initialBio.isEmpty ? "No bio yet" : initialBio;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // --- Image Upload Logic (Aapke Controller jaisa) ---
  Future<String?> _uploadImageToStorage(File imageFile) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("user_profiles")
          .child("$_uid.jpg");
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL(); // Naya URL return karega
    } catch (e) {
      print("Storage Error: $e");
      return null;
    }
  }

  _handleUpdate() async {
    // Check if anything changed
    if (nameController.text.trim() == initialName &&
        bioController.text.trim() == initialBio &&
        _selectedImage == null) {
      Get.snackbar(
        "No Changes",
        "You didn't make any changes.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      String finalImageUrl = currentImageUrl;

      // 1. Agar nayi image select ki hai to upload karein
      if (_selectedImage != null) {
        String? uploadedUrl = await _uploadImageToStorage(_selectedImage!);
        if (uploadedUrl != null) {
          finalImageUrl = uploadedUrl;
        }
      }

      // 2. Firestore update karein
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(_uid)
          .update({
            'name': nameController.text.trim(),
            'bio': bioController.text.trim(),
            'userimage': finalImageUrl, // Naya ya purana URL
          });

      Get.back();
      Get.snackbar(
        "Success",
        "Profile updated!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Update failed!");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Image Picker UI
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!) as ImageProvider
                          : (currentImageUrl.isNotEmpty
                                ? CachedNetworkImageProvider(currentImageUrl)
                                : null),
                      child: (currentImageUrl.isEmpty && _selectedImage == null)
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            _buildInputField("Name", nameController),
            const Divider(height: 30, indent: 25, endIndent: 25),
            _buildInputField("Bio", bioController),

            const SizedBox(height: 50),

            // Update Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isLoading ? null : _handleUpdate,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
