import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
// --- YE IMPORT LAAZMI HAI ---
import 'package:video_editor/video_editor.dart';
import 'confirm_upload_screen.dart';

class VideoEditingScreen extends StatefulWidget {
  final File file;
  const VideoEditingScreen({super.key, required this.file});

  @override
  State<VideoEditingScreen> createState() => _VideoEditingScreenState();
}

class _VideoEditingScreenState extends State<VideoEditingScreen> {
  // Late initialization controller ke liye
  late VideoEditorController _controller;

  @override
  void initState() {
    super.initState();
    // Controller initialize ho raha hai
    _controller = VideoEditorController.file(
      File(widget.file.path), // <--- Ye tabdeeli karni hai
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: 60), // TikTok style 1 min limit
    )..initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Next screen par janay ka logic
  void _finishEditing() {
    // Note: Agar aap physically video cut karna chahte hain toh
    // export ka logic yahan aayega. Filhal simple flow hai.
    Get.to(() => ConfirmUploadScreen(videoFile: widget.file));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? SafeArea(
              child: Column(
                children: [
                  // --- Custom AppBar ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                        const Text(
                          "Trim Video",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: _finishEditing,
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Video Preview ---
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.video.value.aspectRatio,
                        child: VideoPlayer(_controller.video),
                      ),
                    ),
                  ),

                  // --- Trimming Timeline ---
                  Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        // Slider widget
                        TrimSlider(
                          controller: _controller,
                          height: 60,
                          horizontalMargin: 20,
                          child: TrimTimeline(
                            controller: _controller,
                            padding: const EdgeInsets.only(top: 10),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Drag corner handles to trim",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            ),
    );
  }
}
