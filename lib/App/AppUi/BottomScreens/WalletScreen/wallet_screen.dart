import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/withdrawal_screen.dart';
import 'package:pandlive/App/Routes/app_routes.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  RxInt awardCoins = 0.obs;
  RxInt dollars = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    fetchWalletData();
  }

  // Refresh Logic
  Future<void> fetchWalletData() async {
    isLoading.value = true;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .get();
      if (snapshot.exists) {
        awardCoins.value = snapshot.data()?["coins"] ?? 0;
        dollars.value = snapshot.data()?["dollars"] ?? 0;
      }
    } catch (e) {
      debugPrint("Error fetching wallet: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Color getStatusColor(String status) {
    String s = status.toLowerCase();
    if (s.contains("pending")) return Colors.orange.shade700;
    if (s.contains("complete")) return Colors.green.shade700;
    if (s.contains("reject")) return Colors.red.shade700;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isArabic ? "المحفظة" : "My Wallet",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: fetchWalletData,
            icon: const Icon(Icons.refresh_rounded, color: Colors.blueAccent),
          ),
        ],
      ),
      body: Obx(
        () => isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- TOP BALANCE CARDS (Horizontal Layout) ---
                    Row(
                      children: [
                        Expanded(
                          child: _buildMiniCard(
                            title: isArabic ? "العملات" : "Total Coins",
                            value: awardCoins.value.toString(),
                            icon: Icons.stars_rounded,
                            color: Colors.amber.shade700,
                            btnText: isArabic ? "تبديل" : "Redeem",
                            onTap: () => _showRedeemDialog(isArabic),
                          ),
                        ),
                        const Gap(12),

                        Expanded(
                          child: _buildMiniCard(
                            title: isArabic ? "الأرباح" : "Earnings",
                            value: "\$${dollars.value}",
                            icon: Icons.account_balance_wallet_rounded,
                            color: Colors.blueAccent,
                            btnText: isArabic ? "سحب" : "Withdraw",
                            onTap: () {
                              if (dollars.value >= 2) {
                                Get.to(
                                  () => WithdrawalFormScreen(),
                                  arguments: {"amount": dollars.value},
                                );
                              } else {
                                Get.snackbar(
                                  "Low Balance",
                                  "Minimum \$2 required",
                                  backgroundColor: Colors.black87,
                                  colorText: Colors.white,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const Gap(20),

                    // --- BUY COINS BUTTON (Premium Gradient) ---
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.buycoins);
                        // Navigate to Buy Coins Screen

                        print("Buy Coins Clicked");
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_shopping_cart_rounded,
                              color: Colors.white,
                            ),
                            const Gap(12),
                            Text(
                              isArabic ? "شراء العملات" : "BUY COINS",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Gap(30),

                    // --- HISTORY SECTION ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isArabic ? "حالة السحب" : "WITHDRAWAL STATUS",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.blueGrey.shade300,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),

                    Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('userProfile')
                            .doc(uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || !snapshot.data!.exists)
                            return const SizedBox();

                          var userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          String status = userData['withdrawlstatus'] ?? "";

                          if (status.isEmpty || status == "No Request") {
                            return _buildEmptyState(isArabic);
                          }

                          return ListView(
                            children: [_buildStatusCard(status, isArabic)],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // --- REUSABLE MINI BALANCE CARD ---
  Widget _buildMiniCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String btnText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Gap(12),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
          FittedBox(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Gap(12),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                btnText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- STATUS CARD ---
  Widget _buildStatusCard(String status, bool isArabic) {
    Color sColor = getStatusColor(status);
    bool isPending = status.toLowerCase().contains("pending");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: sColor.withOpacity(0.1),
              child: Icon(Icons.receipt_long_rounded, color: sColor, size: 20),
            ),
            title: Text(
              isArabic ? "طلب سحب" : "Withdrawal Request",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              status,
              style: TextStyle(
                color: sColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            trailing: isPending
                ? IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                      size: 22,
                    ),
                    onPressed: () => _cancelRequestLogic(status, isArabic),
                  )
                : Icon(
                    status.toLowerCase().contains("complete")
                        ? Icons.check_circle_rounded
                        : Icons.error_rounded,
                    color: sColor,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, color: Colors.grey[200], size: 50),
          const Gap(8),
          Text(
            isArabic ? "لا توجد معاملات حالية" : "No active requests",
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
        ],
      ),
    );
  }

  // --- LOGIC: CANCEL & REFUND ---
  Future<void> _cancelRequestLogic(String currentStatus, bool isArabic) async {
    RegExp regExp = RegExp(r'\d+');
    var match = regExp.firstMatch(currentStatus);

    if (match != null) {
      int refundAmount = int.parse(match.group(0)!);
      Get.defaultDialog(
        title: isArabic ? "تأكيد الإلغاء" : "Confirm Cancel",
        middleText: isArabic
            ? "هل تريد استرداد \$$refundAmount؟"
            : "Refund \$$refundAmount back to wallet?",
        textConfirm: isArabic ? "نعم" : "Confirm",
        buttonColor: Colors.red,
        confirmTextColor: Colors.white,
        onConfirm: () async {
          await FirebaseFirestore.instance
              .collection('userProfile')
              .doc(uid)
              .update({
                'withdrawlstatus': "No Request",
                'dollars': FieldValue.increment(refundAmount),
              });
          Get.back();
          fetchWalletData();
          Get.snackbar(
            "Refunded",
            "Amount added back to balance",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      );
    }
  }

  // --- LOGIC: REDEEM COINS ---
  void _showRedeemDialog(bool isArabic) {
    Get.defaultDialog(
      title: isArabic ? "تبديل العملات" : "Redeem Coins",
      middleText: isArabic
          ? "تحويل 45,000 عملة إلى \$45"
          : "Convert 45,000 Coins to \$45.00",
      onConfirm: () async {
        if (awardCoins.value >= 45000) {
          await FirebaseFirestore.instance
              .collection("userProfile")
              .doc(uid)
              .update({
                "coins": FieldValue.increment(-45000),
                "dollars": FieldValue.increment(45),
              });
          Get.back();
          fetchWalletData();
        } else {
          Get.back();
          Get.snackbar("Error", "Insufficient coins (Need 45k)");
        }
      },
    );
  }
}
