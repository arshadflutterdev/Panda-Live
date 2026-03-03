import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WithdrawlHistory extends StatefulWidget {
  const WithdrawlHistory({super.key});

  @override
  State<WithdrawlHistory> createState() => _WithdrawlHistoryState();
}

class _WithdrawlHistoryState extends State<WithdrawlHistory> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Status color logic
  Color getStatusColor(String status) {
    String s = status.toLowerCase();
    if (s.contains("pending")) return Colors.orange.shade800;
    if (s.contains("complete")) return Colors.green.shade800;
    if (s.contains("reject")) return Colors.red.shade800;
    return Colors.grey;
  }

  // Request cancel karne aur dollars wapas add karne ka function
  Future<void> cancelRequest(String currentStatus) async {
    try {
      // 1. Amount nikalna
      RegExp regExp = RegExp(r'\d+');
      var match = regExp.firstMatch(currentStatus);

      if (match != null) {
        int refundAmount = int.parse(match.group(0)!);

        bool confirm =
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: const Text("Confirm Cancel"),
                content: Text(
                  "Kya aap \$${refundAmount} refund lena chahte hain?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Nahi"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      "Haan, Cancel karain",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ) ??
            false;

        if (confirm) {
          // 2. Firebase Update
          await FirebaseFirestore.instance
              .collection('userProfile')
              .doc(uid)
              .update({
                'withdrawlstatus': "No Request",
                'dollars': FieldValue.increment(refundAmount),
              });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("\$${refundAmount} wapas bhej diye gaye hain."),
              ),
            );

            // 3. Auto-Back to Profile Page
            // Ye line user ko wapas profile page par le jayegi jahan balance update ho chuka hoga
            Navigator.pop(context);
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Withdrawal History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userProfile')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String status = userData['withdrawlstatus'] ?? "";

            // Agar koi request na ho
            if (status.isEmpty || status == "No Request") {
              return const Center(
                child: Text(
                  "No request submitted",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ACTIVE REQUEST",
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Status",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(
                                    status,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: getStatusColor(status),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: getStatusColor(status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                        // Cancel Button
                        // Sirf 'Pending' wali request cancel ho sakti hai
                        if (status.toLowerCase().contains("pending"))
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => cancelRequest(status),
                                icon: const Icon(Icons.close, size: 20),
                                label: const Text("Cancel & Refund Dollars"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade50,
                                  foregroundColor: Colors.red,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Colors.red.shade200,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "This request cannot be cancelled",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("No data found"));
        },
      ),
    );
  }
}
