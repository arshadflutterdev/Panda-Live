import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added missing import
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinPlansScreen extends StatelessWidget {
  const CoinPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isArabic ? "متجر العملات" : "Coin Store",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Gap(100),
            _buildHeader(isArabic),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('coin_plans')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.amber),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState(isArabic);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var planData = doc.data() as Map<String, dynamic>?;

                      if (planData == null) return const SizedBox();

                      // Safely check status
                      bool isActive =
                          planData['isActive'] == true ||
                          planData['isActive'].toString() == "true";

                      if (!isActive) return const SizedBox();

                      return _buildPlanCard(
                        planData,
                        doc.id,
                        isArabic,
                        context,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isArabic) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.stars_rounded, size: 50, color: Colors.black),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? "اشحن العملات" : "Refill Coins",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                Text(
                  isArabic
                      ? "كن مميزاً في البث المباشر"
                      : "Be a star in live streams",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    Map<String, dynamic> plan,
    String docId,
    bool isArabic,
    BuildContext context,
  ) {
    final String coins = plan['coins']?.toString() ?? "0";
    final String price = plan['amount']?.toString() ?? "0";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.monetization_on_rounded,
                  color: Colors.amber,
                  size: 35,
                ),
                const Gap(15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$coins ${isArabic ? "عملة" : "Coins"}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isArabic ? "شحن فوري" : "Instant Delivery",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _checkBalanceAndBuy(
                    context,
                    plan,
                    docId,
                    coins,
                    price,
                    isArabic,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      "\$$price",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkBalanceAndBuy(
    BuildContext context,
    Map<String, dynamic> plan,
    String docId,
    String coins,
    String price,
    bool isArabic,
  ) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Colors.amber)),
      barrierDismissible: false,
    );

    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      var userDoc = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .get();

      if (Get.isDialogOpen!) Get.back();

      if (userDoc.exists) {
        // Handle dollars as double or int safely
        num userBalance = userDoc.data()?["dollars"] ?? 0;
        double planPrice = double.tryParse(price) ?? 0.0;

        if (userBalance < planPrice) {
          Get.snackbar(
            isArabic ? "رصيد غير كافٍ" : "Insufficient Balance",
            isArabic
                ? "ليس لديك $price دولار في حسابك"
                : "You don't have \$$price in your account",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(15),
          );
          return;
        }

        _showConfirmDialog(context, coins, price, isArabic, () {
          // Add your logic to deduct dollars and add coins here
          debugPrint("Proceeding with purchase of $coins coins");
        });
      }
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      debugPrint("Error: $e");
    }
  }

  void _showConfirmDialog(
    BuildContext context,
    String coins,
    String price,
    bool isArabic,
    VoidCallback onConfirm,
  ) {
    Get.defaultDialog(
      title: isArabic ? "تأكيد الشراء" : "Confirm Purchase",
      middleText: isArabic
          ? "هل تريد شراء $coins عملة مقابل \$$price؟"
          : "Buy $coins coins for \$$price?",
      backgroundColor: const Color(0xFF1E293B),
      titleStyle: const TextStyle(color: Colors.white),
      middleTextStyle: const TextStyle(color: Colors.white70),
      textConfirm: isArabic ? "شراء" : "Buy Now",
      textCancel: isArabic ? "إلغاء" : "Cancel",
      confirmTextColor: Colors.black,
      buttonColor: Colors.amber,
      onConfirm: () {
        Get.back();
        onConfirm();
      },
    );
  }

  Widget _buildEmptyState(bool isArabic) {
    return Center(
      child: Text(
        isArabic ? "لا توجد خطط" : "No plans available",
        style: const TextStyle(color: Colors.white24),
      ),
    );
  }
}
