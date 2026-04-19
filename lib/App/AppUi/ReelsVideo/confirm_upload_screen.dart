// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:video_player/video_player.dart'; // Naya import
// // import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';

// // class ConfirmUploadScreen extends StatefulWidget {
// //   // StatelessWidget ko StatefulWidget kiya preview ke liye
// //   final File videoFile;
// //   ConfirmUploadScreen({required this.videoFile});

// //   @override
// //   State<ConfirmUploadScreen> createState() => _ConfirmUploadScreenState();
// // }

// // class _ConfirmUploadScreenState extends State<ConfirmUploadScreen> {
// //   final TextEditingController _captionController = TextEditingController();
// //   final controller = Get.find<ReelsController>();
// //   late VideoPlayerController _videoController; // Preview controller

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Video preview initialize ho rahi hai
// //     _videoController = VideoPlayerController.file(widget.videoFile)
// //       ..initialize().then((_) {
// //         setState(() {});
// //         _videoController.play();
// //         _videoController.setLooping(true);
// //         _videoController.setVolume(0); // Sound off for preview
// //       });
// //   }

// //   @override
// //   void dispose() {
// //     _videoController.dispose(); // Memory cleanup
// //     _captionController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Post Reel"), backgroundColor: Colors.black),
// //       body: SingleChildScrollView(
// //         // Screen scrollable taaki keyboard masla na kare
// //         child: Column(
// //           children: [
// //             const SizedBox(height: 20),

// //             // --- VIDEO PREVIEW SECTION (Updated from Grey Box) ---
// //             Container(
// //               height: 300,
// //               width: 200,
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[900],
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: _videoController.value.isInitialized
// //                   ? ClipRRect(
// //                       borderRadius: BorderRadius.circular(10),
// //                       child: AspectRatio(
// //                         aspectRatio: _videoController.value.aspectRatio,
// //                         child: VideoPlayer(_videoController),
// //                       ),
// //                     )
// //                   : const Center(
// //                       child: CircularProgressIndicator(color: Colors.white),
// //                     ),
// //             ),

// //             Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: TextField(
// //                 controller: _captionController,
// //                 style: const TextStyle(color: Colors.black),
// //                 decoration: const InputDecoration(
// //                   hintText: "Caption likhein...",
// //                   border: UnderlineInputBorder(),
// //                 ),
// //               ),
// //             ),

// //             Obx(() {
// //               return controller.isLoading.value
// //                   ? Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 30),
// //                       child: Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           ClipRRect(
// //                             borderRadius: BorderRadius.circular(10),
// //                             child: LinearProgressIndicator(
// //                               value: controller.uploadProgress.value,
// //                               backgroundColor: Colors.grey[200],
// //                               color: Colors.blueAccent,
// //                               minHeight: 10,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 10),
// //                           Text(
// //                             "Uploading: ${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.grey[800],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     )
// //                   : Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 30),
// //                       child: SizedBox(
// //                         width: double.infinity,
// //                         height: 50,
// //                         child: ElevatedButton(
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.black,
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                             elevation: 5,
// //                           ),
// //                           onPressed: () {
// //                             if (_captionController.text.isNotEmpty) {
// //                               controller.uploadVideo(
// //                                 _captionController.text,
// //                                 widget.videoFile.path,
// //                               );
// //                             } else {
// //                               Get.snackbar(
// //                                 "Caption Missing",
// //                                 "Please write something about your reel",
// //                                 snackPosition: SnackPosition.BOTTOM,
// //                               );
// //                             }
// //                           },
// //                           child: const Text(
// //                             "Share Reel",
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //             }),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';
// import 'video_editor_screen.dart'; // Editing screen ka link

// // class ConfirmUploadScreen extends StatefulWidget {
// //   final File videoFile;
// //   ConfirmUploadScreen({required this.videoFile});

// //   @override
// //   State<ConfirmUploadScreen> createState() => _ConfirmUploadScreenState();
// // }

// // class _ConfirmUploadScreenState extends State<ConfirmUploadScreen> {
// //   final TextEditingController _captionController = TextEditingController();
// //   final controller = Get.find<ReelsController>();

// //   // STEP 2: Preview logic ke liye controller
// //   late VideoPlayerController _previewController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     // Video player initialize kar rahe hain thumbnail dikhane ke liye
// //     _previewController = VideoPlayerController.file(widget.videoFile)
// //       ..initialize().then((_) {
// //         setState(() {}); // Thumbnail load hote hi UI update ho jaye
// //       });
// //   }

// //   @override
// //   void dispose() {
// //     _previewController.dispose(); // Memory leak se bachne ke liye
// //     _captionController.dispose();
// //     super.dispose();
// //   }

// //   // Full Screen Preview function
// //   void _showFullScreenPreview() {
// //     _previewController.play();
// //     Get.to(
// //       () => Scaffold(
// //         backgroundColor: Colors.black,
// //         appBar: AppBar(
// //           backgroundColor: Colors.transparent,
// //           elevation: 0,
// //           leading: IconButton(
// //             icon: const Icon(Icons.close, color: Colors.white),
// //             onPressed: () => Get.back(),
// //           ),
// //         ),
// //         body: Center(
// //           child: GestureDetector(
// //             onTap: () => Get.back(),
// //             child: AspectRatio(
// //               aspectRatio: _previewController.value.aspectRatio,
// //               child: VideoPlayer(_previewController),
// //             ),
// //           ),
// //         ),
// //       ),
// //     )?.then((value) => _previewController.pause());
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         title: const Text("Post", style: TextStyle(color: Colors.black)),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back, color: Colors.black),
// //           onPressed: () => Get.back(),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             const Divider(thickness: 1),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
// //               child: Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // --- LEFT SIDE: DESCRIPTION & BUTTONS ---
// //                   Expanded(
// //                     flex: 3,
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         TextField(
// //                           controller: _captionController,
// //                           maxLines: 5,
// //                           decoration: const InputDecoration(
// //                             hintText: "Describe your video...",
// //                             border: InputBorder.none,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 20),

// //                         // EDIT BUTTON (Optional)
// //                         OutlinedButton.icon(
// //                           onPressed: () => Get.to(
// //                             () => VideoEditingScreen(file: widget.videoFile),
// //                           ),
// //                           icon: const Icon(Icons.edit, size: 18),
// //                           label: const Text("Edit Video"),
// //                           style: OutlinedButton.styleFrom(
// //                             foregroundColor: Colors.black,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),

// //                   const SizedBox(width: 10),

// //                   // --- RIGHT SIDE: VIDEO PREVIEW ---
// //                   GestureDetector(
// //                     onTap: _showFullScreenPreview, // Full Screen Preview Logic
// //                     child: Container(
// //                       height: 150,
// //                       width: 100,
// //                       decoration: BoxDecoration(
// //                         color: Colors.black,
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: ClipRRect(
// //                         borderRadius: BorderRadius.circular(8),
// //                         child: Stack(
// //                           alignment: Alignment.center,
// //                           children: [
// //                             // Thumbnail Display
// //                             _previewController.value.isInitialized
// //                                 ? AspectRatio(
// //                                     aspectRatio:
// //                                         _previewController.value.aspectRatio,
// //                                     child: VideoPlayer(_previewController),
// //                                   )
// //                                 : const CircularProgressIndicator(
// //                                     color: Colors.white,
// //                                     strokeWidth: 2,
// //                                   ),

// //                             const Icon(
// //                               Icons.play_circle_outline,
// //                               color: Colors.white,
// //                               size: 30,
// //                             ),
// //                             const Positioned(
// //                               bottom: 5,
// //                               child: Text(
// //                                 "Preview",
// //                                 style: TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 10,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             const Divider(thickness: 1),

// //             // --- BOTTOM BUTTON: CONFIRM / POST ---
// //             Obx(() {
// //               return Padding(
// //                 padding: const EdgeInsets.all(20),
// //                 child: controller.isLoading.value
// //                     ? Column(
// //                         children: [
// //                           LinearProgressIndicator(
// //                             value: controller.uploadProgress.value,
// //                           ),
// //                           const SizedBox(height: 10),
// //                           Text(
// //                             "${(controller.uploadProgress.value * 100).toStringAsFixed(0)}% Uploading...",
// //                           ),
// //                         ],
// //                       )
// //                     : SizedBox(
// //                         width: double.infinity,
// //                         height: 50,
// //                         child: ElevatedButton(
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: const Color(0xFFE94359),
// //                           ), // TikTok Red
// //                           onPressed: () {
// //                             if (_captionController.text.isNotEmpty) {
// //                               controller.uploadVideo(
// //                                 _captionController.text,
// //                                 widget.videoFile.path,
// //                               );
// //                             } else {
// //                               Get.snackbar("Error", "Please add a description");
// //                             }
// //                           },
// //                           child: const Text(
// //                             "Post",
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //               );
// //             }),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';

// class ConfirmUploadScreen extends StatefulWidget {
//   final File videoFile;
//   // --- NAYE PARAMETERS ---
//   final Duration? startTime;
//   final Duration? endTime;

//   ConfirmUploadScreen({required this.videoFile, this.startTime, this.endTime});

//   @override
//   State<ConfirmUploadScreen> createState() => _ConfirmUploadScreenState();
// }

// class _ConfirmUploadScreenState extends State<ConfirmUploadScreen> {
//   final TextEditingController _captionController = TextEditingController();
//   final controller = Get.find<ReelsController>();

//   // STEP 2: Preview logic ke liye controller
//   late VideoPlayerController _previewController;

//   @override
//   void initState() {
//     super.initState();
//     // Video player initialize kar rahe hain thumbnail dikhane ke liye
//     _previewController = VideoPlayerController.file(widget.videoFile)
//       ..initialize().then((_) {
//         // --- FIX: Agar trim points hain to wahan se start kare ---
//         if (widget.startTime != null) {
//           _previewController.seekTo(widget.startTime!);
//         }

//         // Listener taaki video trim points ke darmiyan hi rahay
//         _previewController.addListener(() {
//           if (widget.endTime != null &&
//               _previewController.value.position >= widget.endTime!) {
//             _previewController.seekTo(widget.startTime ?? Duration.zero);
//           }
//         });

//         setState(() {}); // Thumbnail load hote hi UI update ho jaye
//       });
//   }

//   @override
//   void dispose() {
//     _previewController.dispose(); // Memory leak se bachne ke liye
//     _captionController.dispose();
//     super.dispose();
//   }

//   // Full Screen Preview function
//   void _showFullScreenPreview() {
//     _previewController.play();
//     Get.to(
//       () => Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.close, color: Colors.white),
//             onPressed: () => Get.back(),
//           ),
//         ),
//         body: Center(
//           child: GestureDetector(
//             onTap: () => Get.back(),
//             child: AspectRatio(
//               aspectRatio: _previewController.value.aspectRatio,
//               child: VideoPlayer(_previewController),
//             ),
//           ),
//         ),
//       ),
//     )?.then((value) => _previewController.pause());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Post", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const Divider(thickness: 1),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // --- LEFT SIDE: DESCRIPTION & BUTTONS ---
//                   Expanded(
//                     flex: 3,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextField(
//                           controller: _captionController,
//                           maxLines: 5,
//                           decoration: const InputDecoration(
//                             hintText: "Describe your video...",
//                             border: InputBorder.none,
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         // EDIT BUTTON (Optional)
//                         OutlinedButton.icon(
//                           onPressed: () => Get.to(
//                             () => VideoEditingScreen(file: widget.videoFile),
//                           ),
//                           icon: const Icon(Icons.edit, size: 18),
//                           label: const Text("Edit Video"),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(width: 10),

//                   // --- RIGHT SIDE: VIDEO PREVIEW ---
//                   GestureDetector(
//                     onTap: _showFullScreenPreview, // Full Screen Preview Logic
//                     child: Container(
//                       height: 150,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             // Thumbnail Display
//                             _previewController.value.isInitialized
//                                 ? AspectRatio(
//                                     aspectRatio:
//                                         _previewController.value.aspectRatio,
//                                     child: VideoPlayer(_previewController),
//                                   )
//                                 : const CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2,
//                                   ),

//                             const Icon(
//                               Icons.play_circle_outline,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                             const Positioned(
//                               bottom: 5,
//                               child: Text(
//                                 "Preview",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const Divider(thickness: 1),

//             // --- BOTTOM BUTTON: CONFIRM / POST ---
//             Obx(() {
//               return Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: controller.isLoading.value
//                     ? Column(
//                         children: [
//                           LinearProgressIndicator(
//                             value: controller.uploadProgress.value,
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             "${(controller.uploadProgress.value * 100).toStringAsFixed(0)}% Uploading...",
//                           ),
//                         ],
//                       )
//                     : SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFE94359),
//                           ), // TikTok Red
//                           onPressed: () {
//                             if (_captionController.text.isNotEmpty) {
//                               // 1. Upload start karein
//                               controller.uploadVideo(
//                                 _captionController.text,
//                                 widget.videoFile.path,
//                               );

//                               // 2. Do martaba back jana (Confirm Screen aur Editing Screen dono khatam)
//                               // Is se user wahan pahuche ga jahan se video pick ki thi
//                               Get.back(); // Pehla back: Confirm screen close
//                               Get.back(); // Dusra back: Editing screen close

//                               Get.snackbar(
//                                 "Uploading",
//                                 "Your video is being uploaded in the background",
//                                 snackPosition: SnackPosition.BOTTOM,
//                                 backgroundColor: Colors.black87,
//                                 colorText: Colors.white,
//                               );
//                             } else {
//                               Get.snackbar("Error", "Please add a description");
//                             }
//                           },

//                           // onPressed: () {
//                           //   if (_captionController.text.isNotEmpty) {
//                           //     controller.uploadVideo(
//                           //       _captionController.text,
//                           //       widget.videoFile.path,
//                           //     );
//                           //     Get.offAllNamed('/home');
//                           //   } else {
//                           //     Get.snackbar("Error", "Please add a description");
//                           //   }
//                           // },
//                           child: const Text(
//                             "Post",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
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

  ConfirmUploadScreen({required this.videoFile, this.startTime, this.endTime});

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
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94359),
                          ),
                          onPressed: () {
                            if (_captionController.text.isNotEmpty) {
                              // SIRF UPLOAD HOGA, SCREEN CHANGE NAHI HOGI
                              controller.uploadVideo(
                                _captionController.text,
                                widget.videoFile.path,
                              );
                            } else {
                              Get.snackbar("Error", "Please add a description");
                            }
                          },
                          child: const Text(
                            "Post",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
