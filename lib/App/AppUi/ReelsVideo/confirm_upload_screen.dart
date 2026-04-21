import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/video_editor_screen.dart';
import 'package:video_player/video_player.dart';

class ConfirmUploadScreen extends StatefulWidget {
  final File videoFile;
  // Trim points handle karne ke liye
  final Duration? startTime;
  final Duration? endTime;
  final String? overlayText;
  final Offset? textPosition;
  final Color? textColor;
  final double? fontSize;
  final bool isBold;
  final bool isItalic;

  ConfirmUploadScreen({
    required this.videoFile,
    this.startTime,
    this.endTime,
    this.overlayText,
    this.textPosition,
    this.textColor,
    this.fontSize,
    required this.isBold,
    required this.isItalic,
  });

  @override
  State<ConfirmUploadScreen> createState() => _ConfirmUploadScreenState();
}

class _ConfirmUploadScreenState extends State<ConfirmUploadScreen> {
  final TextEditingController _captionController = TextEditingController();
  final controller = Get.find<ReelsController>();

  late VideoPlayerController _previewController;

  @override
  void initState() {
    super.initState();
    _previewController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        // Sirf seek set kiya hai trim ke liye
        if (widget.startTime != null) {
          _previewController.seekTo(widget.startTime!);
        }
        _previewController.addListener(() {
          if (widget.endTime != null &&
              _previewController.value.position >= widget.endTime!) {
            _previewController.seekTo(widget.startTime ?? Duration.zero);
          }
        });
        setState(() {});
      });
  }

  @override
  void dispose() {
    _previewController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  void _showFullScreenPreview() {
    _previewController.play();
    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: AspectRatio(
              aspectRatio: _previewController.value.aspectRatio,
              child: VideoPlayer(_previewController),
            ),
          ),
        ),
      ),
    )?.then((value) => _previewController.pause());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Post", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _captionController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: "Describe your video...",
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton.icon(
                          onPressed: () => Get.to(
                            () => VideoEditingScreen(file: widget.videoFile),
                          ),
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text("Edit Video"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _showFullScreenPreview,
                    child: Container(
                      height: 150,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _previewController.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio:
                                        _previewController.value.aspectRatio,
                                    child: VideoPlayer(_previewController),
                                  )
                                : const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                            const Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 30,
                            ),
                            const Positioned(
                              bottom: 5,
                              child: Text(
                                "Preview",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: controller.isLoading.value
                    ? Column(
                        children: [
                          LinearProgressIndicator(
                            value: controller.uploadProgress.value,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${(controller.uploadProgress.value * 100).toStringAsFixed(0)}% Uploading...",
                          ),
                        ],
                      )
                    :
                      // 1. Post Button ka logic
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94359),
                          ),
                          onPressed: () {
                            if (_captionController.text.isNotEmpty) {
                              // Screen piche le jao
                              Get.back();

                              // Background mein upload start karo with TRIM points
                              controller.uploadVideo(
                                _captionController.text,
                                widget.videoFile.path,
                                // YE DO LINES LAAZMI HAIN
                                start: widget.startTime,
                                end: widget.endTime,
                              );

                              Get.snackbar(
                                "Success",
                                "Uploading trimmed video...",
                              );
                            }
                          },
                          // onPressed: () {
                          //   if (_captionController.text.isNotEmpty) {
                          //     // --- FIX START ---
                          //     // Pehle navigation handle karein taaki screen foran band ho jaye
                          //     Get.back();

                          //     // Phir upload start karein background mein
                          //     controller.uploadVideo(
                          //       _captionController.text,
                          //       widget.videoFile.path,
                          //     );

                          //     Get.snackbar(
                          //       "Success",
                          //       "Uploading in background...",
                          //       snackPosition: SnackPosition.BOTTOM,
                          //       backgroundColor: Colors.black54,
                          //       colorText: Colors.white,
                          //     );
                          //     // --- FIX END ---
                          //   } else {
                          //     Get.snackbar("Error", "Please add a description");
                          //   }
                          // },
                          child: const Text(
                            "Post",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                // 2. Niche wala Obx block bilkul hta dein (Iska kaam Reels page pe hoga)
                // Jo aapka 0% Uploading wala Column hai, usay yahan se remove kar dein.
                // SizedBox(
                //     width: double.infinity,
                //     height: 50,
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color(0xFFE94359),
                //       ),
                //       onPressed: () {
                //         if (_captionController.text.isNotEmpty) {
                //           // SIRF UPLOAD HOGA, SCREEN CHANGE NAHI HOGI
                //           controller.uploadVideo(
                //             _captionController.text,
                //             widget.videoFile.path,
                //           );
                //         } else {
                //           Get.snackbar("Error", "Please add a description");
                //         }
                //       },

                //       child: const Text(
                //         "Post",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
