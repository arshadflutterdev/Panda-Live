import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pandlive/App/AppUi/Profile/nextScreens/CreateProfileScreen/helpscreen_controller.dart';
import 'package:pandlive/App/Widgets/Buttons/elevatedbutton0.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  // 1. Controllers
  final HelpController _helpController = Get.put(HelpController());
  final TextEditingController topicCtrl = TextEditingController();
  final TextEditingController detailCtrl = TextEditingController();

  // 2. Image Picking Variables
  final ImagePicker picker = ImagePicker();
  List<File> images = [];
  bool isPicking = false;

  // 3. The pickImages Function (This was missing or misplaced)
  Future<void> pickImages() async {
    if (isPicking) return;
    isPicking = true;

    try {
      final pickedFiles = await picker.pickMultiImage(imageQuality: 70);

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          images.addAll(pickedFiles.map((e) => File(e.path)));
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Cannot open gallery: $e");
    } finally {
      isPicking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    final localization = AppLocalizations.of(context)!;
    double width = AppHeightwidth.screenWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          localization.helpsupport,
          style: isArabic
              ? AppStyle.arabictext.copyWith(fontSize: 24)
              : const TextStyle(),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Topic Input
            Text(
              localization.topic,
              style: isArabic ? AppStyle.arabictext : const TextStyle(),
            ),
            const SizedBox(height: 6),
            TextField(
              cursorColor: Colors.black,
              controller: topicCtrl,
              decoration: InputDecoration(
                hintText: localization.topic,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Details Input
            Text(
              localization.issuedetail,
              style: isArabic ? AppStyle.arabictext : const TextStyle(),
            ),
            const SizedBox(height: 6),
            TextField(
              cursorColor: Colors.black,
              controller: detailCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: localization.decribissue,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Image Upload Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localization.uploadimage,
                  style: isArabic ? AppStyle.arabictext : const TextStyle(),
                ),
                IconButton(
                  onPressed: pickImages, // This will now work!
                  icon: const Icon(Icons.add_a_photo),
                ),
              ],
            ),

            /// Image Preview List
            if (images.isNotEmpty)
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => setState(() => images.removeAt(index)),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            const SizedBox(height: 24),

            /// Submit Button with Loading State
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: _helpController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : MyElevatedButton(
                        width: width,
                        btext: Text(
                          localization.submitissued,
                          style: isArabic
                              ? AppStyle.arabictext.copyWith(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                )
                              : AppStyle.btext.copyWith(color: Colors.white),
                        ),
                        onPressed: () {
                          _helpController.submitIssue(
                            topic: topicCtrl.text.trim(),
                            detail: detailCtrl.text.trim(),
                            images: images,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
