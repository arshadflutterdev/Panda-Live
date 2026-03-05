import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Copy karne ke liye
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({super.key});

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Share karne ka function
  void shareInvite(String code, bool isArabic) {
    String message = isArabic
        ? "انضم إلي في تطبيق Panda Live! استمتع واربح الكوينز. استخدم الكود الخاص بي: $code \nرابط التطبيق: https://play.google.com/store/apps/details?id=com.panda.live"
        : "Join me on Panda Live App! Have fun and earn coins. Use my referral code: $code \nDownload Link: https://play.google.com/store/apps/details?id=com.panda.live";

    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isArabic ? "دعوة صديق" : "Invite Friends"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userProfile')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var data = snapshot.data!.data() as Map<String, dynamic>;
          String myCode = data['myReferralCode'] ?? "------";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                // Upper Image/Illustration
                const Icon(
                  Icons.group_add_rounded,
                  size: 100,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 20),

                Text(
                  isArabic
                      ? "ادعُ أصدقاءك واحصل على كوينز!"
                      : "Invite Friends & Get Coins!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: isArabic
                        ? GoogleFonts.amiri().fontFamily
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isArabic
                      ? "شارك كود الدعوة الخاص بك مع أصدقائك. عندما يسجلون، ستحصل على كوينز مجانية."
                      : "Share your referral code with friends. When they sign up, you'll earn bonus coins.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 40),

                // Referral Code Box
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade100, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isArabic ? "كود الدعوة الخاص بك" : "YOUR REFERRAL CODE",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            myCode,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: myCode));
                              Get.snackbar(
                                isArabic ? "تم النسخ" : "Copied",
                                isArabic
                                    ? "تم نسخ الكود إلى الحافظة"
                                    : "Code copied to clipboard",
                                colorText: Colors.white,
                                backgroundColor: Colors.black87,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            icon: const Icon(Icons.copy, color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Invite Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () => shareInvite(myCode, isArabic),
                    icon: const Icon(Icons.share),
                    label: Text(
                      isArabic ? "أرسل الدعوة الآن" : "Send Invite Now",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
