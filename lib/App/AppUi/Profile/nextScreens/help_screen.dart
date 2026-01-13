import 'dart:io';
import 'package:flutter/material.dart';
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

  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage(imageQuality: 70);
    if (pickedFiles.isNotEmpty) {
      setState(() {
        images.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  void submitHelp() {
    if (topicCtrl.text.isEmpty || detailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    // 🔥 Future: Firebase / API call
    print("Topic: ${topicCtrl.text}");
    print("Details: ${detailCtrl.text}");
    print("Images: ${images.length}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Issue submitted successfully")),
    );

    topicCtrl.clear();
    detailCtrl.clear();
    setState(() => images.clear());
  }

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Help & Support")),
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
                hintText: "e.g. Login issue, Payment problem",
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
