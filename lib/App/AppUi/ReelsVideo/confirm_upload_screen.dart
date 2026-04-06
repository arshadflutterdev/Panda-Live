import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';

class ConfirmUploadScreen extends StatelessWidget {
  final File videoFile;
  ConfirmUploadScreen({required this.videoFile});

  final TextEditingController _captionController = TextEditingController();
  final controller = Get.find<ReelsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post Reel"), backgroundColor: Colors.black),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 300,
            width: 200,
            color: Colors.grey[900],
            child: Icon(Icons.videocam, size: 50, color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _captionController,
              decoration: InputDecoration(hintText: "Caption likhein..."),
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => controller.uploadVideo(
                      _captionController.text,
                      videoFile.path,
                    ),
                    child: Text("Upload Karein"),
                  ),
          ),
        ],
      ),
    );
  }
}
