import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetailsEdit extends StatefulWidget {
  const UserDetailsEdit({super.key});

  @override
  State<UserDetailsEdit> createState() => _UserDetailsEditState();
}

class _UserDetailsEditState extends State<UserDetailsEdit> {
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final dobController = TextEditingController();

  String gender = "";
  String referral = "";
  String userImage = "";
  int shortId = 0;
  bool isVerified = false;

  bool isLoading = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection("userProfile")
        .doc(uid)
        .get();

    if (snapshot.exists) {
      setState(() {
        nameController.text = snapshot["name"] ?? "";
        countryController.text = snapshot["country"] ?? "";
        dobController.text = snapshot["dob"] ?? "";

        gender = snapshot["gender"] ?? "";
        referral = snapshot["myReferralCode"] ?? "";
        userImage = snapshot["userimage"] ?? "";
        shortId = snapshot["shortId"] ?? 0;
        isVerified = snapshot["isVerified"] ?? false;

        isLoading = false;
      });
    }
  }

  Future<void> updateUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("userProfile").doc(uid).update({
      "name": nameController.text,
      "country": countryController.text,
      "dob": dobController.text,
    });

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profile Updated")));
  }

  Widget textField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget detailTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "$title : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
        actions: [
          /// Edit Button
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  /// Profile Image
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userImage.isNotEmpty
                            ? NetworkImage(userImage)
                            : null,
                        child: userImage.isEmpty
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),

                      if (isVerified)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nameController.text,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 6),

                      if (isVerified)
                        const Icon(Icons.verified, color: Colors.blue),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Editable Fields
                  textField("Name", nameController),
                  textField("Country", countryController),
                  textField("Date of Birth", dobController),

                  /// Non Editable Fields
                  detailTile("Gender", gender),
                  detailTile("User ID", shortId.toString()),
                  detailTile("Referral Code", referral),

                  const SizedBox(height: 20),

                  /// Save Button
                  if (isEditing)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: updateUser,
                        child: const Text("Save Changes"),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
