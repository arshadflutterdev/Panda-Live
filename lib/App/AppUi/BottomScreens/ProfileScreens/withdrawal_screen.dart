import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawalFormScreen extends StatelessWidget {
  final int amount = Get.arguments['amount'] ?? 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController binanceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Check if the current language is Arabic
    bool isArabic = Get.locale?.languageCode == "ar";

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? "سحب بينانس" : "Binance Withdrawal"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: isArabic
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // Withdrawal Amount Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber),
                ),
                child: Column(
                  children: [
                    Text(
                      isArabic ? "مبلغ السحب" : "Withdrawal Amount",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "\$$amount.00",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Warning Message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isArabic
                            ? "هام: تأكد من استخدام حساب بينانس صالح. إذا كانت المعلومات خاطئة، فسيتم فقدان المبلغ."
                            : "Important: Make sure to use a valid Binance Account. If the information is wrong, your amount will be washed/lost.",
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Input Fields
              Text(
                isArabic ? "اسم حساب بينانس" : "Binance Account Name",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  hintText: isArabic
                      ? "أدخل اسمك الكامل في بينانس"
                      : "Enter your full name on Binance",
                  border: const OutlineInputBorder(),
                  prefixIcon: isArabic
                      ? null
                      : const Icon(Icons.person_outline),
                  suffixIcon: isArabic
                      ? const Icon(Icons.person_outline)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                isArabic ? "معرف بينانس / معرف الدفع" : "Binance ID / Pay ID",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: binanceIdController,
                keyboardType: TextInputType.number,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  hintText: isArabic
                      ? "أدخل معرف بينانس المكون من 9 أرقام"
                      : "Enter your 9-digit Binance ID",
                  border: const OutlineInputBorder(),
                  prefixIcon: isArabic
                      ? null
                      : const Icon(Icons.account_balance_wallet_outlined),
                  suffixIcon: isArabic
                      ? const Icon(Icons.account_balance_wallet_outlined)
                      : null,
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty ||
                        binanceIdController.text.trim().isEmpty) {
                      Get.snackbar(
                        isArabic ? "مطلوب" : "Required",
                        isArabic
                            ? "يرجى تقديم جميع تفاصيل بينانس"
                            : "Please provide all Binance details",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    try {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseFirestore.instance
                          .collection("userProfile")
                          .doc(uid)
                          .update({
                            "withdrawlstatus": "Pending (\$$amount)",
                            "binanceName": nameController.text.trim(),
                            "binanceId": binanceIdController.text.trim(),
                            "dollars": 0,
                          });

                      Get.back();
                      Get.snackbar(
                        isArabic ? "نجاح" : "Success",
                        isArabic
                            ? "تم تقديم طلب السحب بنجاح"
                            : "Withdrawal request submitted successfully",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } catch (e) {
                      Get.snackbar(
                        isArabic ? "خطأ" : "Error",
                        isArabic
                            ? "حدث خطأ ما. حاول مرة أخرى لاحقاً."
                            : "Something went wrong. Try again later.",
                      );
                    }
                  },
                  child: Text(
                    isArabic
                        ? "تأكيد وإرسال الطلب"
                        : "Confirm & Submit Request",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
