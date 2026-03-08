import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

// ... imports wahi rahengy
// ... existing imports ...

class _UpdatesScreenState extends State<UpdatesScreen> {
  bool get isArabic => Get.locale?.languageCode == "ar";

  // --- Icon aur Color decide karne wala function ---
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(isArabic ? "التحديثات الرسمية" : "Official Updates"),
        // ... (Appbar actions same rahengy)
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

          var docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              var style = _getNotificationStyle(
                data['type'],
              ); // Type ke mutabiq style

              return GestureDetector(
                onTap: () {
                  // Details screen par bhejna
                  Get.to(() => NotificationDetailScreen(data: data));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: style['color'],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(style['icon'], color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data['body'] ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
      appBar: AppBar(
        title: Text(isArabic ? "التفاصيل" : "Details"),
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
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            // Agar Payment ka Screenshot hai to dikhao
            if (data['image'] != null && data['image'] != "")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              ),

            // Agar extra notes hain
            if (data['details'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Notes: ${data['details']}",
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
