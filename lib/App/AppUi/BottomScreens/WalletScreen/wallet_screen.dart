import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/withdrawal_screen.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  RxInt awardCoins = 0.obs;
  RxInt dollars = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    isLoading.value = true;
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .get();

      if (snapshot.exists) {
        awardCoins.value = snapshot.data()?["coins"] ?? 0;
        dollars.value = snapshot.data()?["dollars"] ?? 0;
      }
    } catch (e) {
      print("Error fetching wallet: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Ultra-clean background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isArabic ? "محفظتي الرقمية" : "Digital Wallet",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.blueAccent),
            onPressed: fetchWalletData,
          ),
        ],
      ),
      body: Obx(
        () => isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- COINS SECTION (No Image, Elegant) ---
                    _buildBalanceCard(
                      context: context,
                      title: isArabic ? "رصيد العملات" : "Coins Balance",
                      balance: awardCoins.value.toString(),
                      icon: Icons.monetization_on_rounded,
                      primaryColor: const Color(0xFFFFB800), // Rich Gold
                      secondaryColor: const Color(0xFFFFF1CC),
                      btnText: isArabic ? "تحويل الآن" : "Convert Now",
                      onTap: () => _showRedeemDialog(isArabic),
                    ),

                    const Gap(25),

                    // --- DOLLARS SECTION (Clean, Minimalist) ---
                    _buildBalanceCard(
                      context: context,
                      title: isArabic ? "الأرباح الكلية" : "Total Earnings",
                      balance: "\$${dollars.value.toStringAsFixed(2)}",
                      icon: Icons.account_balance_wallet_rounded,
                      primaryColor: const Color(0xFFE91E63), // Vibrant Pink
                      secondaryColor: const Color(0xFFFCE4EC),
                      btnText: isArabic ? "طلب سحب" : "Request Payout",
                      onTap: () {
                        if (dollars.value >= 2) {
                          Get.to(
                            () => WithdrawalFormScreen(),
                            arguments: {"amount": dollars.value},
                          );
                        } else {
                          Get.snackbar(
                            "Low Balance",
                            "Minimum \$2 required for withdrawal",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                    ),

                    const Gap(35),

                    // --- TRANSACTION HISTORY TITLE ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isArabic ? "سجل المعاملات" : "Transaction History",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {}, // Future view all
                          child: Text(
                            isArabic ? "عرض الكل" : "View All",
                            style: const TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),

                    // Empty State Placeholder (Professional)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.history_rounded,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                          const Gap(15),
                          Text(
                            isArabic
                                ? "لا توجد معاملات أخيرة"
                                : "No recent activity found",
                            style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            isArabic
                                ? "ابدأ البث لكسب المزيد"
                                : "Start going live to earn rewards",
                            style: GoogleFonts.inter(
                              color: Colors.grey[400],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Common Widget for Attractive Balance Cards
  Widget _buildBalanceCard({
    required BuildContext context,
    required String title,
    required String balance,
    required IconData icon,
    required Color primaryColor,
    required Color secondaryColor,
    required String btnText,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: primaryColor, size: 28),
              ),
              const Gap(15),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          Text(
            balance,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              btnText,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Redeem Logic Dialog (Enhanced UI)
  void _showRedeemDialog(bool isArabic) {
    Get.defaultDialog(
      title: isArabic ? "استبدال العملات" : "Redeem Coins",
      titleStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
      backgroundColor: Colors.white,
      middleText: isArabic
          ? "سيتم تحويل 45,000 عملة إلى 45 دولارًا"
          : "45,000 Coins will be converted to \$45.00",
      middleTextStyle: GoogleFonts.inter(color: Colors.grey[700]),
      textConfirm: isArabic ? "تأكيد التحويل" : "Confirm Convert",
      textCancel: isArabic ? "إلغاء" : "Cancel",
      confirmTextColor: Colors.white,
      cancelTextColor: const Color(0xFFFFB800),
      buttonColor: const Color(0xFFFFB800),
      radius: 16,
      onConfirm: () async {
        if (awardCoins.value >= 45000) {
          final uid = FirebaseAuth.instance.currentUser!.uid;
          await FirebaseFirestore.instance
              .collection("userProfile")
              .doc(uid)
              .update({
                "coins": FieldValue.increment(-45000),
                "dollars": FieldValue.increment(45),
              });
          Get.back();
          fetchWalletData();
          Get.snackbar(
            "Success",
            "Redeemed successfully!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.back();
          Get.snackbar(
            "Error",
            "Need at least 45k coins",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
