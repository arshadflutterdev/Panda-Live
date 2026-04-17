import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // Maujooda data load karein
    _loadUserData();
  }

  _loadUserData() async {
    var doc = await FirebaseFirestore.instance
        .collection('userProfile')
        .doc(_uid)
        .get();
    if (doc.exists) {
      nameController.text = doc['name'] ?? '';
      bioController.text = doc['bio'] ?? '';
    }
  }

  _updateProfile() async {
    setState(() => isLoading = true);
    await FirebaseFirestore.instance.collection('userProfile').doc(_uid).update(
      {'name': nameController.text.trim(), 'bio': bioController.text.trim()},
    );
    setState(() => isLoading = false);
    Get.back();
    Get.snackbar("Success", "Profile Updated!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: isLoading ? null : _updateProfile,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture Section
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/images/default_user.png',
                    ), // Yahan Network Image lagayein
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black.withOpacity(0.6),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Name Input
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bio Input
            TextField(
              controller: bioController,
              maxLength: 80,
              decoration: const InputDecoration(
                labelText: "Bio",
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
