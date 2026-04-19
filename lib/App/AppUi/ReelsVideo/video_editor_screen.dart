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
//   late VideoEditorController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoEditorController.file(
//       File(widget.file.path),
//       minDuration: const Duration(seconds: 1),
//       maxDuration: const Duration(seconds: 60),
//     )..initialize().then((_) {
//         // --- FIX: Listener add kiya taaki play/pause state update ho ---
//         _controller.video.addListener(() {
//           if (mounted) setState(() {});
//         });
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _controller.video.removeListener(() {}); // Listener remove karna zaruri hai
//     _controller.dispose();
//     super.dispose();
//   }

//   void _finishEditing() {
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
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           AspectRatio(
//                             aspectRatio: _controller.video.value.aspectRatio,
//                             child: CropGridViewer.preview(controller: _controller),
//                           ),

//                           // --- PLAY/PAUSE OVERLAY FIX ---
//                           GestureDetector(
//                             onTap: () {
//                               _controller.video.value.isPlaying
//                                   ? _controller.video.pause()
//                                   : _controller.video.play();
//                             },
//                             child: Container(
//                               width: double.infinity,
//                               height: double.infinity,
//                               color: Colors.transparent, // Poori screen par tap detect karne ke liye
//                               child: !_controller.video.value.isPlaying
//                                   ? Center(
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         decoration: const BoxDecoration(
//                                           color: Colors.black45,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: const Icon(
//                                           Icons.play_arrow,
//                                           color: Colors.white,
//                                           size: 70,
//                                         ),
//                                       ),
//                                     )
//                                   : const SizedBox.shrink(),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // --- Trimming Timeline ---
//                   Container(
//                     height: 180,
//                     padding: const EdgeInsets.symmetric(vertical: 20),
//                     child: Column(
//                       children: [
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
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
// --- Video Editor Package ---
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

  @override
  void initState() {
    super.initState();
    _controller =
        VideoEditorController.file(
            File(widget.file.path),
            minDuration: const Duration(seconds: 1),
            maxDuration: const Duration(seconds: 60),
          )
          ..initialize().then((_) {
            // Listener to update UI on play/pause and keep it within trim points
            _controller.video.addListener(() {
              if (mounted) {
                // FIXED: Playback ko trimmed area ke andar rakhne ke liye logic
                final bool isPlaying = _controller.video.value.isPlaying;
                final int currentPos =
                    _controller.video.value.position.inMilliseconds;
                final int startTrim =
                    (_controller.video.value.duration.inMilliseconds *
                            _controller.minTrim)
                        .toInt();
                final int endTrim =
                    (_controller.video.value.duration.inMilliseconds *
                            _controller.maxTrim)
                        .toInt();

                if (isPlaying && currentPos >= endTrim) {
                  _controller.video.seekTo(Duration(milliseconds: startTrim));
                }

                setState(() {});
              }
            });
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- FIXED: Next par click karne se trimmed hissa hi jaye ga ---
  void _finishEditing() {
    if (_controller.video.value.isPlaying) {
      _controller.video.pause();
    }

    // Double ko Duration mein convert kiya
    final Duration start =
        _controller.video.value.duration * _controller.minTrim;
    final Duration end = _controller.video.value.duration * _controller.maxTrim;

    Get.to(
      () => ConfirmUploadScreen(
        videoFile: widget.file,
        startTime: start,
        endTime: end,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? SafeArea(
              child: Column(
                children: [
                  // --- AppBar ---
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _controller.video.value.aspectRatio,
                            child: CropGridViewer.preview(
                              controller: _controller,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // FIXED: Play dabate waqt agar position trim se bahar hai to start par le jaye
                              final int startTrim =
                                  (_controller
                                              .video
                                              .value
                                              .duration
                                              .inMilliseconds *
                                          _controller.minTrim)
                                      .toInt();
                              final int endTrim =
                                  (_controller
                                              .video
                                              .value
                                              .duration
                                              .inMilliseconds *
                                          _controller.maxTrim)
                                      .toInt();
                              final int currentPos = _controller
                                  .video
                                  .value
                                  .position
                                  .inMilliseconds;

                              if (!_controller.video.value.isPlaying) {
                                if (currentPos < startTrim ||
                                    currentPos >= endTrim) {
                                  _controller.video.seekTo(
                                    Duration(milliseconds: startTrim),
                                  );
                                }
                                _controller.video.play();
                              } else {
                                _controller.video.pause();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.transparent,
                              child: !_controller.video.value.isPlaying
                                  ? Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Colors.black45,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 70,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- THE FINAL FIXED TRIMMER ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        // SizedBox ensure karta hai ke trimmer screen ke andar hi rahay
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TrimSlider(
                            controller: _controller,
                            height: 60,
                            // Margin ko 0 rakha hai taaki edges tak access ho
                            horizontalMargin: 0,
                            child: TrimTimeline(
                              controller: _controller,
                              padding: const EdgeInsets.only(top: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "Hold handles firmly to trim from ends",
                          style: TextStyle(color: Colors.white54, fontSize: 13),
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
