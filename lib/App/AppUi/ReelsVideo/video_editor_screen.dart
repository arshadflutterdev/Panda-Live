// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// // --- YE IMPORT LAAZMI HAI ---
// import 'package:video_editor/video_editor.dart';
// import 'confirm_upload_screen.dart';

// class VideoEditingScreen extends StatefulWidget {
//   final File file;
//   const VideoEditingScreen({super.key, required this.file});

//   @override
//   State<VideoEditingScreen> createState() => _VideoEditingScreenState();
// }

// class _VideoEditingScreenState extends State<VideoEditingScreen> {
//   // Late initialization controller ke liye
//   late VideoEditorController _controller;

//   @override
//   void initState() {
//     super.initState();
//     // Controller initialize ho raha hai
//     _controller = VideoEditorController.file(
//       File(widget.file.path), // <--- Ye tabdeeli karni hai
//       minDuration: const Duration(seconds: 1),
//       maxDuration: const Duration(seconds: 60), // TikTok style 1 min limit
//     )..initialize().then((_) => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   // Next screen par janay ka logic
//   void _finishEditing() {
//     // Note: Agar aap physically video cut karna chahte hain toh
//     // export ka logic yahan aayega. Filhal simple flow hai.
//     Get.to(() => ConfirmUploadScreen(videoFile: widget.file));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: _controller.initialized
//           ? SafeArea(
//               child: Column(
//                 children: [
//                   // --- Custom AppBar ---
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.close, color: Colors.white),
//                           onPressed: () => Get.back(),
//                         ),
//                         const Text(
//                           "Trim Video",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: _finishEditing,
//                           child: const Text(
//                             "Next",
//                             style: TextStyle(
//                               color: Colors.blueAccent,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // --- Video Preview ---
//                   Expanded(
//                     child: Center(
//                       child: AspectRatio(
//                         aspectRatio: _controller.video.value.aspectRatio,
//                         child: VideoPlayer(_controller.video),
//                       ),
//                     ),
//                   ),

//                   // --- Trimming Timeline ---
//                   Container(
//                     height:
// ,
//                     padding: const EdgeInsets.symmetric(vertical: 20),
//                     child: Column(
//                       children: [
//                         // Slider widget
//                         TrimSlider(
//                           controller: _controller,
//                           height: 60,
//                           horizontalMargin: 20,
//                           child: TrimTimeline(
//                             controller: _controller,
//                             padding: const EdgeInsets.only(top: 10),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         const Text(
//                           "Drag corner handles to trim",
//                           style: TextStyle(color: Colors.white54),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : const Center(
//               child: CircularProgressIndicator(color: Colors.blueAccent),
//             ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editor/video_editor.dart';
import 'confirm_upload_screen.dart';

class VideoEditingScreen extends StatefulWidget {
  final File file;
  const VideoEditingScreen({super.key, required this.file});

  @override
  State<VideoEditingScreen> createState() => _VideoEditingScreenState();
}

class _VideoEditingScreenState extends State<VideoEditingScreen> {
  late VideoEditorController _controller;

  // GetX for minimal UI updates only
  final RxBool isInitialized = false.obs;
  final RxBool isPlaying = false.obs;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoEditorController.file(
            widget.file,
            minDuration: const Duration(seconds: 1),
            maxDuration: const Duration(seconds: 60),
          )
          ..initialize().then((_) {
            isInitialized.value = true;
            _controller.video.addListener(() {
              isPlaying.value = _controller.video.value.isPlaying;
            });
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finishEditing() {
    if (_controller.video.value.isPlaying) {
      _controller.video.pause();
    }

    // 1. Pehle ye do variables define karein (Ye error fix kar dega)
    final Duration start =
        _controller.video.value.duration * _controller.minTrim;
    final Duration end = _controller.video.value.duration * _controller.maxTrim;

    // 2. Ab inhein pass karein
    Get.off(
      () => ConfirmUploadScreen(
        videoFile: widget.file,
        startTime: start, // Ab 'start' defined hai
        endTime: end, // Ab 'end' defined hai
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => isInitialized.value
            ? SafeArea(
                child: Column(
                  children: [
                    // --- Transparent AppBar ---
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
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: _finishEditing,
                            child: const Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- Full Video Preview ---
                    Expanded(
                      child: GestureDetector(
                        onTap: () => isPlaying.value
                            ? _controller.video.pause()
                            : _controller.video.play(),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CropGridViewer.preview(controller: _controller),

                            // Play Icon Overlay
                            Obx(
                              () => !isPlaying.value
                                  ? Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: const BoxDecoration(
                                        color: Colors.black26,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- Raw Trimmer (No Background Boxes) ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Direct Trim Slider for maximum response
                          TrimSlider(
                            controller: _controller,
                            height: 60,
                            horizontalMargin:
                                0, // Handles ab poori width use karein ge
                            child: TrimTimeline(
                              controller: _controller,
                              padding: const EdgeInsets.only(top: 10),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Trim from both ends",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
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
      ),
    );
  }
}
