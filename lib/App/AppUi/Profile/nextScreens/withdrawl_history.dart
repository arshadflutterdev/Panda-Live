import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';

class WithdrawlHistory extends StatefulWidget {
  const WithdrawlHistory({super.key});

  @override
  State<WithdrawlHistory> createState() => _WithdrawlHistoryState();
}

class _WithdrawlHistoryState extends State<WithdrawlHistory> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Status ke hisaab se color decide karne ka function
  Color getStatusColor(String status) {
    String s = status.toLowerCase();
    if (s.contains("pending")) return Colors.orange.shade800;
    if (s.contains("complete")) return Colors.green.shade800;
    if (s.contains("reject")) return Colors.red.shade800;
    return Colors.grey;
  }

  // Request cancel karne ka function
  Future<void> cancelRequest(String currentStatus) async {
    bool isArabic = Get.locale?.languageCode == "ar";
    try {
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
                title: Text(
                  isArabic ? "تأكيد الإلغاء" : "Confirm Cancel",
                  style: TextStyle(
                    fontSize: 16,
                    // Arabic ke liye font size thoda bada rakhna behtar hota hai
                  ),
                ),
                content: Text(
                  isArabic
                      ? "هل تريد استرداد مبلغ \$$refundAmount؟" // Arabic: "Kya aap $refundAmount refund lena chahte hain?"
                      : "Do you want to refund \$$refundAmount?", // English
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          isArabic ? "لا" : "No",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          isArabic ? "بالتأكيد" : "Sure",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ) ??
            false;

        if (confirm) {
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
                content: Text(
                  isArabic
                      ? "تمت إعادة مبلغ \$$refundAmount." // Arabic version
                      : "\$$refundAmount has been refunded.", // English version
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
            Navigator.pop(context); // Wapas Profile Page par bhejne ke liye
          }
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text(
          isArabic ? "سجلات السحب" : "Withdrawal Records",
          style: isArabic
              ? GoogleFonts.amiri(fontWeight: FontWeight.bold)
              : TextStyle(fontWeight: FontWeight.bold),
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

            if (status.isEmpty || status == "No Request") {
              return Center(
                child: Text(
                  isArabic ? "لم يتم تقديم أي طلب" : "No request submitted",
                  style: isArabic
                      ? GoogleFonts.amiri(color: Colors.grey, fontSize: 18)
                      : TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? "حالة السحب" : "WITHDRAWAL STATUS",
                    style: TextStyle(
                      letterSpacing: isArabic
                          ? 0.0
                          : 1.2, // Arabic mein letter spacing ki zaroorat nahi hoti
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      fontFamily: isArabic
                          ? GoogleFonts.amiri().fontFamily
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      children: [
                        // --- Upper Row (Status Badge) ---
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isArabic ? "الحالة الحالية" : "Current Status",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  // Agar aap chahte hain ke Arabic font thoda different dikhe
                                  fontFamily: isArabic
                                      ? GoogleFonts.amiri().fontFamily
                                      : null,
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

                        // --- Lower Section (Dynamic Messages) ---

                        // 1. Case: PENDING
                        if (status.toLowerCase().contains("pending"))
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => cancelRequest(status),
                                icon: const Icon(Icons.close, size: 20),
                                label: Text(
                                  isArabic
                                      ? "إلغاء واسترداد الأموال"
                                      : "Cancel & Refund Dollars",
                                  style: TextStyle(
                                    fontSize: isArabic
                                        ? 14
                                        : 12, // Arabic font thoda clear rakhne ke liye
                                    fontFamily: isArabic
                                        ? GoogleFonts.amiri().fontFamily
                                        : null,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade50,
                                  foregroundColor: Colors.red,
                                  elevation: 0,
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
                        // 2. Case: COMPLETE (Accept)
                        else if (status.toLowerCase().contains("complete"))
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.stars,
                                  color: Colors.green,
                                  size: 40,
                                ),
                                const SizedBox(height: 10),

                                Text(
                                  isArabic ? "تهانينا!" : "Congratulations!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 18,
                                    // Arabic ke liye font behtar karne ke liye
                                    fontFamily: isArabic
                                        ? GoogleFonts.amiri().fontFamily
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  isArabic
                                      ? "تمت معالجة دفعتك وإرسالها بنجاح."
                                      : "Your payment has been successfully processed and sent.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    // Arabic font ko behtar dikhane ke liye family add kar sakte hain
                                    fontFamily: isArabic
                                        ? GoogleFonts.amiri().fontFamily
                                        : null,
                                    fontSize: isArabic
                                        ? 16
                                        : 14, // Arabic aksar thoda bada font maangta hai readability ke liye
                                  ),
                                ),
                              ],
                            ),
                          )
                        // 3. Case: REJECT
                        else if (status.toLowerCase().contains("reject"))
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  isArabic
                                      ? "تم رفض الطلب"
                                      : "Request Rejected",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontFamily: isArabic
                                        ? GoogleFonts.amiri().fontFamily
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  isArabic
                                      ? "تم رفض طلبك من قبل المسؤول. يرجى التواصل مع الدعم إذا كان لديك أي أسئلة."
                                      : "Your request was rejected by the admin. Please contact support if you have questions.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontFamily: isArabic
                                        ? GoogleFonts.amiri().fontFamily
                                        : null,
                                    fontSize: isArabic
                                        ? 14
                                        : 12, // Arabic readability ke liye thoda adjustment
                                  ),
                                ),
                              ],
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
