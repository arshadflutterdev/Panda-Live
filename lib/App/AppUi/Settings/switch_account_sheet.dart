import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SwitchAccountSheet {
  static void show(
    BuildContext context, {
    required VoidCallback onAccountSwitched,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final currentUser = FirebaseAuth.instance.currentUser;

        return FutureBuilder<DocumentSnapshot>(
          // Current Active User ka Profile Data Firestore se lane ke liye
          future: FirebaseFirestore.instance
              .collection('userProfile')
              .doc(currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            String userName = "TikTak User";
            String userImage = "";

            if (snapshot.hasData && snapshot.data!.exists) {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              userName = data['name'] ?? "No Name";
              userImage = data['userimage'] ?? ""; // App data model key mapping
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle/Bar indicator on top
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Switch Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 1. Current Active Account ListTile
                  ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: userImage.isNotEmpty
                          ? NetworkImage(userImage)
                          : const AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                    ),
                    title: Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: const Text(
                      'Logged in',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                    trailing: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 24,
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                      ); // Already logged in, just close sheet
                    },
                  ),

                  // TODO: Yahan saved multi-accounts ki loop aayegi local storage se read kr k
                  const Divider(height: 24, thickness: 0.5),

                  // 2. Add Account Button
                  ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.black87,
                        size: 24,
                      ),
                    ),
                    title: const Text(
                      'Add Account',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Login / Register Screen for new account session
                      print("Navigate to Login Screen");
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
