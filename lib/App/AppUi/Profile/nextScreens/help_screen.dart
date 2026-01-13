import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pandlive/App/Widgets/Buttons/elevatedbutton0.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController topicCtrl = TextEditingController();
  final TextEditingController detailCtrl = TextEditingController();

  final ImagePicker picker = ImagePicker();
  List<File> images = [];
  bool isPicking = false;

  Future<void> pickImages() async {
    if (isPicking) return; // agar already open hai, do nothing
    isPicking = true; // flag ON

    try {
      final pickedFiles = await picker.pickMultiImage(imageQuality: 70);

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          images.addAll(pickedFiles.map((e) => File(e.path)));
        });
      }
    } catch (e) {
      print("Image picker error: $e");
      Get.snackbar("Error", "Cannot open camera/gallery");
    } finally {
      isPicking = false; // flag OFF
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: const Text("Help & Support"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Topic
            const Text("Topic"),
            const SizedBox(height: 6),
            TextField(
              controller: topicCtrl,
              decoration: InputDecoration(
                hintText: "first Tell us topic",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Details
            const Text("Issue Details"),
            const SizedBox(height: 6),
            TextField(
              controller: detailCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Describe your issue in detail...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Upload Images
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Upload Images"),
                IconButton(
                  onPressed: pickImages,
                  icon: const Icon(Icons.add_a_photo),
                ),
              ],
            ),

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
                            onTap: () {
                              setState(() => images.removeAt(index));
                            },
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

            /// Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: MyElevatedButton(
                width: width,
                btext: Text(
                  "Submit Issue",
                  style: AppStyle.btext.copyWith(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
