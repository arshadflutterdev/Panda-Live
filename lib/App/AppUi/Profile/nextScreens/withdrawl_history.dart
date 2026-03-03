import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WithdrawlHistory extends StatefulWidget {
  const WithdrawlHistory({super.key});

  @override
  State<WithdrawlHistory> createState() => _WithdrawlHistoryState();
}

class _WithdrawlHistoryState extends State<WithdrawlHistory> {
  // Current user ki ID nikalne ke liye
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Status ke hisaab se color set karne ka function
  Color getStatusColor(String status) {
    if (status.contains("Pending")) return Colors.orange;
    if (status.contains("Complete")) return Colors.green;
    if (status.contains("Reject")) return Colors.red;
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Withdrawal Status")),
      body: StreamBuilder<DocumentSnapshot>(
        // Screenshot ke mutabiq userProfile collection se data le rahe hain
        stream: FirebaseFirestore.instance
            .collection('userProfile')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No data found"));
          }

          // Data map mein convert kar rahe hain
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String status = userData['withdrawalstatus'] ?? "No Request";

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: getStatusColor(status).withOpacity(0.2),
                    child: Icon(Icons.history, color: getStatusColor(status)),
                  ),
                  title: const Text("Withdrawal Request"),
                  subtitle: Text("Status: $status"),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Details",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
