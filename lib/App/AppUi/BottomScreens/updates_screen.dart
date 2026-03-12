import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/google_ads.dart'; // Apna sahi path check kar lena

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  bool get isArabic => Get.locale?.languageCode == "ar";

  // --- Dynamic Icon, Color & Emoji Logic ---
  Map<String, dynamic> _getNotificationStyle(String? type, String? title) {
    String titleLower = (title ?? "").toLowerCase();

    // 1. Withdrawal Rejected Check (Sad Emoji)
    if (titleLower.contains("rejected") || titleLower.contains("refuse")) {
      return {
        "isEmoji": true,
        "isImage": false,
        "emoji": "😞",
        "color": Colors.red.shade50,
      };
    }

    // 2. Type based logic
    switch (type) {
      case 'payment':
        return {
          "isEmoji": false,
          "isImage": false,
          "icon": Icons.account_balance_wallet,
          "color": Colors.green,
        };
      case 'announcement':
        return {
          "isEmoji": false,
          "isImage": false,
          "icon": Icons.campaign,
          "color": Colors.orange,
        };
      case 'security':
        return {
          "isEmoji": false,
          "isImage": false,
          "icon": Icons.security,
          "color": Colors.red,
        };
      default:
        // Default Case: Yahan aapki Coins wali Image aayegi
        return {
          "isEmoji": false,
          "isImage": true,
          "imagePath": AppImages.coins,
          "color": Colors.blue.shade50,
        };
    }
  }

  Widget _buildOfficialBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isArabic ? "رسمي" : "Official",
        style: TextStyle(
          fontSize: 10,
          color: Colors.blue.shade800,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          isArabic ? "التحديثات الرسمية" : "Official Updates",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userProfile')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('notifications')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(isArabic ? "لا توجد رسائل" : "No messages yet"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String type = data['type'] ?? "";
              String title = data['title'] ?? "";
              var style = _getNotificationStyle(type, title);

              String displayHeader = (type == 'announcement')
                  ? (isArabic ? "إعلان رسمي" : "Official Announcement")
                  : title;

              String displaySubtitle = (type == 'announcement')
                  ? title
                  : (data['body'] ?? "");

              return GestureDetector(
                onTap: () {
                  AdController().tryShowAd();
                  Get.to(() => NotificationDetailScreen(data: data));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Vertically Center Content
                    children: [
                      // --- Image / Icon / Emoji Box ---
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: style['isEmoji'] || style['isImage']
                              ? style['color']
                              : (style['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: style['isEmoji']
                            ? Center(
                                child: Text(
                                  style['emoji'],
                                  style: const TextStyle(fontSize: 28),
                                ),
                              )
                            : style['isImage']
                            ? Padding(
                                padding: const EdgeInsets.all(
                                  10.0,
                                ), // Image size control
                                child: Image.asset(style['imagePath']),
                              )
                            : Icon(
                                style['icon'],
                                color: style['color'],
                                size: 26,
                              ),
                      ),
                      const SizedBox(width: 12),

                      // --- Text Content ---
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    displayHeader,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                if (type == 'announcement')
                                  _buildOfficialBadge(),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              displaySubtitle,
                              maxLines: 1, // Long Title Truncate
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: type == 'announcement'
                                    ? Colors.blue.shade700
                                    : Colors.black87,
                                fontWeight: type == 'announcement'
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- Right Arrow (Height ke hisab se Center) ---
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const NotificationDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    return WillPopScope(
      child: Scaffold(
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
          title: Text(isArabic ? "التفاصيل" : "Details"),
          backgroundColor: Colors.white,
          elevation: 0.5,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'] ?? "",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data['time'] != null
                    ? (data['time'] as Timestamp).toDate().toString().split(
                        '.',
                      )[0]
                    : "",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Divider(height: 30),
              Text(
                data['body'] ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              if (data['image'] != null && data['image'] != "") ...[
                const SizedBox(height: 25),
                const Text(
                  "Attachment:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(data['image']),
                ),
              ],
            ],
          ),
        ),
      ),
      onWillPop: () async {
        AdController().tryShowAd();
        return true;
      },
    );
  }
}
