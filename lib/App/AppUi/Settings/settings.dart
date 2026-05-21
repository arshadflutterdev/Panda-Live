import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pandlive/App/AppUi/Settings/link_phone_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @pragma('vm:entry-point')
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isPrivateAccount = false; // Account lock karne ke liye state
  String _currentPhoneNumber = 'Not Linked';
  @override
  void initState() {
    super.initState();
    _fetchUserPhoneNumber();
  }

  Future<void> _fetchUserPhoneNumber() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var doc = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(user.uid)
          .get();
      if (doc.exists &&
          doc.data() != null &&
          doc.data()!.containsKey('phoneNumber')) {
        setState(() {
          _currentPhoneNumber = doc.data()!['phoneNumber'] ?? 'Not Linked';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // TikTak app ke liye clean white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings and Privacy',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics:
            const BouncingScrollPhysics(), // Snappy iOS-like scrolling UI effect
        children: [
          const SizedBox(height: 12),

          // ================= ACCOUNT SECTION =================
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            icon: Icons.phone_android_rounded,
            title: 'Link Mobile Number',
            subtitle: _currentPhoneNumber, // Live state maintain hogi
            onTap: () async {
              // Navigation se result back receive krna
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LinkPhoneScreen(),
                ),
              );

              if (result != null && result is String) {
                setState(() {
                  _currentPhoneNumber = result;
                });
              }
            },
          ),
          _buildSettingsTile(
            icon: Icons.switch_account_rounded,
            title: 'Switch Account',
            onTap: () {
              // TODO: Switch account bottom sheet logic
              print("Switch Account Clicked");
            },
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 32, thickness: 0.5, color: Colors.black12),
          ),

          // ================= PRIVACY SECTION =================
          _buildSectionHeader('Privacy'),

          // Privacy Toggle (Lock Account to Make it Personal)
          SwitchListTile(
            secondary: Icon(
              _isPrivateAccount ? Icons.lock_rounded : Icons.lock_open_rounded,
              color: _isPrivateAccount ? Colors.redAccent : Colors.grey[700],
            ),
            title: const Text(
              'Private Account',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            subtitle: const Text(
              'Only approved users can see your videos',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            value: _isPrivateAccount,
            activeColor: Colors.redAccent, // Snappy highlight color
            onChanged: (bool value) {
              setState(() {
                _isPrivateAccount = value;
              });
              // TODO: Backend privacy status update logic
            },
          ),

          _buildSettingsTile(
            icon: Icons.privacy_tip_rounded,
            title: 'Privacy Settings',
            onTap: () {
              // TODO: Navigate to Privacy Settings Screen
              print("Privacy Settings Clicked");
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Section Header Generator (Account, Privacy etc)
  // Section Header Generator (Account, Privacy etc)
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.grey[500],
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // Standard Custom ListTile Template
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.grey[700], size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: Colors.black26,
      ),
    );
  }
}
