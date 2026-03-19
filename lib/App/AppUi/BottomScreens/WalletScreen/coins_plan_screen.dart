// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/WalletScreen/payment_buycoins.dart';
// import 'package:pandlive/App/Routes/app_routes.dart';

// class CoinPlansScreen extends StatelessWidget {
//   const CoinPlansScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     bool isArabic = Get.locale?.languageCode == "ar";

//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.white,
//             size: 20,
//           ),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           isArabic ? "متجر العملات" : "Coin Store",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           children: [
//             const Gap(100), // Space for AppBar
//             _buildPremiumHeader(isArabic),

//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('coin_plans')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(color: Colors.amber),
//                     );
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return _buildEmptyState(isArabic);
//                   }

//                   return ListView.builder(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 10,
//                     ),
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       var planData =
//                           snapshot.data!.docs[index].data()
//                               as Map<String, dynamic>;
//                       if (planData['isActive'] == false ||
//                           planData['isActive'] == "false")
//                         return const SizedBox();
//                       return _buildPremiumPlanCard(planData, isArabic, context);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPremiumHeader(bool isArabic) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         gradient: const LinearGradient(
//           colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.orange.withOpacity(0.4),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.stars_rounded, size: 50, color: Colors.black),
//           const Gap(15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isArabic ? "اشحن العملات" : "Refill Coins",
//                   style: GoogleFonts.poppins(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w900,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Text(
//                   isArabic
//                       ? "كن مميزاً في البث المباشر"
//                       : "Be a star in live streams",
//                   style: GoogleFonts.poppins(
//                     fontSize: 13,
//                     color: Colors.black54,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPremiumPlanCard(
//     Map<String, dynamic> plan,
//     bool isArabic,
//     BuildContext context,
//   ) {
//     final String coins = plan['coins']?.toString() ?? "0";
//     final String price = plan['amount']?.toString() ?? "0";

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.06),
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(25),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.monetization_on_rounded,
//                   color: Colors.amber,
//                   size: 35,
//                 ),
//                 const Gap(15),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "$coins ${isArabic ? "عملة" : "Coins"}",
//                         style: GoogleFonts.poppins(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         isArabic ? "شحن فوري" : "Instant Delivery",
//                         style: TextStyle(
//                           color: Colors.grey.shade500,
//                           fontSize: 11,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () =>
//                       _showProfessionalDialog(context, coins, price, isArabic),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 22,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.amber,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.amber.withOpacity(0.3),
//                           blurRadius: 8,
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       "\$$price",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w900,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // --- THE PROFESSIONAL DIALOG ---
//   void _showProfessionalDialog(
//     BuildContext context,
//     String coins,
//     String price,
//     bool isArabic,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: const EdgeInsets.all(20),
//           child: Container(
//             padding: const EdgeInsets.all(25),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1E293B).withOpacity(0.9),
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: Colors.white.withOpacity(0.1)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: Colors.amber.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.shopping_cart_checkout_rounded,
//                     color: Colors.amber,
//                     size: 40,
//                   ),
//                 ),
//                 const Gap(20),
//                 Text(
//                   isArabic ? "تأكيد العملية" : "Confirm Purchase",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Gap(10),
//                 Text(
//                   "You are about to buy $coins coins for a total of \$$price.",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const Gap(30),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextButton(
//                         onPressed: () => Get.back(),
//                         child: Text(
//                           isArabic ? "إلغاء" : "Cancel",
//                           style: const TextStyle(color: Colors.white60),
//                         ),
//                       ),
//                     ),
//                     const Gap(10),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Get.toNamed(AppRoutes.paymentscreen);

//                           Get.snackbar(
//                             "Success",
//                             "Redirecting to Payment Gate",
//                             backgroundColor: Colors.amber,
//                             colorText: Colors.black,
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.amber,
//                           foregroundColor: Colors.black,
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         child: Text(
//                           isArabic ? "تأكيد" : "Confirm",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState(bool isArabic) {
//     return Center(
//       child: Text(
//         isArabic ? "لا توجد خطط" : "No plans available",
//         style: const TextStyle(color: Colors.white24),
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pandlive/App/AppUi/BottomScreens/WalletScreen/payment_buycoins.dart'; // Apna sahi path check karlein

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
            _buildPremiumHeader(isArabic),

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
                      // FIX: Safely get the document and data
                      var doc = snapshot.data!.docs[index];
                      var planData = doc.data() as Map<String, dynamic>?;

                      if (planData == null) return const SizedBox();

                      // Check active status safely
                      if (planData['isActive'] == false ||
                          planData['isActive'] == "false") {
                        return const SizedBox();
                      }

                      return _buildPremiumPlanCard(
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

  Widget _buildPremiumHeader(bool isArabic) {
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
                      ? "كن مميزاً في البث المباشr"
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

  Widget _buildPremiumPlanCard(
    Map<String, dynamic> plan,
    String docId,
    bool isArabic,
    BuildContext context,
  ) {
    // FIX: Null-aware string conversion
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
                  onTap: () => _showProfessionalDialog(
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

  void _showProfessionalDialog(
    BuildContext context,
    Map<String, dynamic> plan,
    String docId,
    String coins,
    String price,
    bool isArabic,
  ) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_cart_checkout_rounded,
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
                const Gap(20),
                Text(
                  isArabic ? "تأكيد العملية" : "Confirm Purchase",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(10),
                Text(
                  "You are about to buy $coins coins for a total of \$$price.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const Gap(30),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          isArabic ? "إلغاء" : "Cancel",
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // FIX: Proper Redirection with Data
                          Get.back(); // Dialog band karein
                          Get.to(
                            () => const PaymentFormScreen(),
                            arguments: {
                              'planId': docId,
                              'coins': coins,
                              'amount': price,
                              'productKey': plan['productKey'] ?? "12344",
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          isArabic ? "تأكيد" : "Confirm",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
