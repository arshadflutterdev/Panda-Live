import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pandlive/google_ads.dart';

// --- NEW CLASS: PaymentFormScreen ---
class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  // Arguments se current data lein
  late final Map<String, dynamic> planArguments;
  late final String planId;
  late final String planCoins;
  late final String planAmount;
  late final String productKey;

  // Form Controllers
  final _trxIdController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _screenshot;
  RxBool _isSubmitting = false.obs;

  @override
  void initState() {
    super.initState();
    planArguments = Get.arguments;
    planId = planArguments['planId'];
    planCoins = planArguments['coins'];
    planAmount = planArguments['amount'];
    productKey = planArguments['productKey'];
  }

  @override
  void dispose() {
    _trxIdController.dispose();
    super.dispose();
  }

  Future<void> _pickScreenshot() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _screenshot = File(image.path);
      });
    }
  }

  Future<void> _submitRequest(bool isArabic) async {
    if (_trxIdController.text.isEmpty || _screenshot == null) {
      Get.snackbar(
        isArabic ? "خطأ في التحقق" : "Validation Error",
        isArabic
            ? "يرجى إضافة معرّف المعاملة ولقطة الشاشة."
            : "Please add TrxID and screenshot.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _isSubmitting.value = true;
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      // 1. Upload Screenshot to Storage
      String filePath =
          'coin_purchases/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(filePath)
          .putFile(_screenshot!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // 2. Add document to 'coin_purchase_requests'
      await FirebaseFirestore.instance.collection('coin_purchase_requests').add(
        {
          'userId': uid,
          'coinsPlanId': planId,
          'coins': int.parse(planCoins),
          'amountDollars': int.parse(planAmount),
          'productKey': productKey,
          'trxId': _trxIdController.text,
          'screenshotUrl': downloadUrl,
          'status': 'pending', // admin will approve
          'submittedAt': FieldValue.serverTimestamp(),
        },
      );

      _trxIdController.clear();
      setState(() {
        _screenshot = null;
      });

      // Show professional success dialog
      Get.defaultDialog(
        title: isArabic ? "نجاح" : "Success",
        middleText: isArabic
            ? "تم تقديم طلبك بنجاح. سيتم التحقق منه قريباً."
            : "Request submitted successfully. Admin will verify soon.",
        onConfirm: () => Get.back(),
        buttonColor: Colors.amber,
      );

      Get.back(); // Back to Plans Screen
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isSubmitting.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    // Previous diagrams: Admin=Arshad, ID=537985
    String adminShortId = "537985"; // Admin detailed diagram ID

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Premium Dark
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
          isArabic ? "طلب الشحن" : "Submit Refill",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Binance Instruction Card
            _buildInstructionCard(isArabic, adminShortId),

            const Gap(25),

            // Form Fields Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Transaction ID
                  _buildSectionTitle(
                    isArabic ? "رقم العملية (TrxID)" : "Transaction ID (TrxID)",
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _trxIdController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      hintText: "Enter Binance TrxID",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.numbers_rounded,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ),

                  const Gap(25),

                  // 2. Screenshot Upload
                  _buildSectionTitle(
                    isArabic ? "لقطة شاشة للدفع" : "Payment Screenshot",
                  ),
                  const Gap(10),
                  GestureDetector(
                    onTap: _pickScreenshot,
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: _screenshot != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _screenshot!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Colors.amber.shade700,
                                  size: 40,
                                ),
                                const Gap(10),
                                Text(
                                  isArabic
                                      ? "أضف لقطة شاشة"
                                      : "Click to upload image",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const Gap(35),

                  // 3. Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: _isSubmitting.value
                            ? null
                            : () {
                                _submitRequest(isArabic);
                                AdController().tryShowAd();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isSubmitting.value
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Text(
                                isArabic ? "تأكيد الطلب" : "Confirm Request",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard(bool isArabic, String adminShortId) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E3D52), // Blue Grey
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                color: Colors.blueAccent.shade100,
                size: 28,
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  isArabic ? "تعليمات الدفع" : "Payment Instructions",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Gap(15),
          const Divider(color: Colors.white24),
          const Gap(15),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 13,
                height: 1.6,
              ),
              children: [
                TextSpan(
                  text: isArabic
                      ? "طريقة الدفع: Binance Pay. يرجى إرسال المبلغ ($planAmount \$) إلى معرف Binance Pay للمشرف: "
                      : "Payment Method: Binance Pay. Please send exactly ($planAmount \$) to Admin Binance Pay ID: ",
                ),
                TextSpan(
                  text: adminShortId,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: isArabic
                      ? ". ثم، أكمل النموذج أدناه برقم TrxID ولقطة شاشة للتأكيد."
                      : ". Then, complete the form below with TrxID and confirmation screenshot.",
                ),
              ],
            ),
          ),
          const Gap(10),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: adminShortId));
                Get.snackbar(
                  "Copied",
                  "Admin Binance ID Copied",
                  backgroundColor: Colors.amber,
                  colorText: Colors.black,
                );
              },
              icon: const Icon(Icons.copy_rounded, color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
