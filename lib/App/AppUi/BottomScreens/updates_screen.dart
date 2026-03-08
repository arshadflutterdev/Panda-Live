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

class _UpdatesScreenState extends State<UpdatesScreen> {
  // Static list ko hata kar Firestore se data lein gey

  bool get isArabic => Get.locale?.languageCode == "ar";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // ... (Aapka purana AppBar code)
      ),

      // Static ListView ki jagah StreamBuilder
      body: StreamBuilder<QuerySnapshot>(
        // Admin ne jo 'announcements' bheji hongi wo yahan se aayengi
        stream: FirebaseFirestore.instance
            .collection('userProfile')
            .doc(
              FirebaseAuth.instance.currentUser?.uid,
            ) // Specific user ki notifications
            .collection('notifications')
            .orderBy('time', descending: true) // Nayi update sab se upar
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                isArabic ? "لا توجد تحديثات" : "No updates available",
              ),
            );
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;

              // Date format karne ke liye
              DateTime date = (data['time'] as Timestamp).toDate();
              String formattedDate = "${date.day}/${date.month}";

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Icon (Announcement type ke mutabiq icon set kr skty hain)
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.orange, // Default color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.campaign,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data['title'] ?? "", // Admin panel wala title
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Official Badge
                              _buildOfficialBadge(),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['body'] ??
                                "", // Admin panel wala subtitle/body
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
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
          fontSize: 11,
          color: Colors.blue.shade800,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
