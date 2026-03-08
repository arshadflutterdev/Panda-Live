import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  bool get isArabic => Get.locale?.languageCode == "ar";

  // --- Dynamic Icon & Color Logic ---
  Map<String, dynamic> _getNotificationStyle(String? type) {
    switch (type) {
      case 'payment':
        return {"icon": Icons.account_balance_wallet, "color": Colors.green};
      case 'announcement':
        return {"icon": Icons.campaign, "color": Colors.orange};
      case 'security':
        return {"icon": Icons.security, "color": Colors.red};
      default:
        return {"icon": Icons.notifications, "color": Colors.blue};
    }
  }

  // --- Official Badge Widget ---
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
          fontSize: 11,
          color: Colors.blue.shade800,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          isArabic ? "التحديثات الرسمية" : "Official Updates",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userProfile')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('notifications')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(isArabic ? "لا توجد تحديثات" : "No updates yet"),
            );
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              String type = data['type'] ?? "";
              var style = _getNotificationStyle(type);

              // --- Announcement Logic: Header & Subtitle ---
              String displayHeader;
              String displaySubtitle;
              if (type == 'announcement') {
                displayHeader = isArabic
                    ? "إعلان رسمي"
                    : "Official Announcement";
                displaySubtitle = data['title'] ?? ""; // Title becomes Subtitle
              } else {
                displayHeader = data['title'] ?? "";
                displaySubtitle = data['body'] ?? "";
              }

              return GestureDetector(
                onTap: () => Get.to(() => NotificationDetailScreen(data: data)),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon Box
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: style['color'],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          style['icon'],
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  displayHeader,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                _buildOfficialBadge(),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              displaySubtitle,
                              style: TextStyle(
                                fontWeight: type == 'announcement'
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: type == 'announcement'
                                    ? Colors.blue.shade700
                                    : Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                            if (type == 'announcement') ...[
                              const SizedBox(height: 4),
                              Text(
                                data['body'] ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isArabic ? "التفاصيل" : "Details"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['title'] ?? "",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              data['time'] != null
                  ? (data['time'] as Timestamp).toDate().toString().split(
                      '.',
                    )[0]
                  : "",
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 30),
            Text(
              data['body'] ?? "",
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            if (data['image'] != null && data['image'] != "") ...[
              const Text(
                "Attachment:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(data['image'], fit: BoxFit.cover),
              ),
            ],
            if (data['details'] != null && data['details'] != "")
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Notes: ${data['details']}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
