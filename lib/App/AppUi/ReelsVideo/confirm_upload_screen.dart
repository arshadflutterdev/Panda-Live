// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';

// class ConfirmUploadScreen extends StatelessWidget {
//   final File videoFile;
//   ConfirmUploadScreen({required this.videoFile});

//   final TextEditingController _captionController = TextEditingController();
//   final controller = Get.find<ReelsController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Post Reel"), backgroundColor: Colors.black),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           Container(
//             height: 300,
//             width: 200,
//             color: Colors.grey[900],
//             child: Icon(Icons.videocam, size: 50, color: Colors.white),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: TextField(
//               controller: _captionController,
//               decoration: InputDecoration(hintText: "Caption likhein..."),
//             ),
//           ),
//           Obx(() {
//             return controller.isLoading.value
//                 ? Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Professional Linear Progress Bar
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: LinearProgressIndicator(
//                             value: controller.uploadProgress.value,
//                             backgroundColor: Colors.grey[200],
//                             color: Colors.blueAccent,
//                             minHeight: 10,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         // Percentage Text
//                         Text(
//                           "Uploading: ${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey[800],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               Colors.black, // Professional Dark Theme
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           elevation: 5,
//                         ),
//                         onPressed: () {
//                           if (_captionController.text.isNotEmpty) {
//                             controller.uploadVideo(
//                               _captionController.text,
//                               videoFile.path,
//                             );
//                           } else {
//                             Get.snackbar(
//                               "Caption Missing",
//                               "Please write something about your reel",
//                               snackPosition: SnackPosition.BOTTOM,
//                             );
//                           }
//                         },
//                         child: const Text(
//                           "Share Reel",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//           }),

//           // Obx(
//           //   () => controller.isLoading.value
//           //       ? CircularProgressIndicator()
//           //       : ElevatedButton(
//           //           onPressed: () => controller.uploadVideo(
//           //             _captionController.text,
//           //             videoFile.path,
//           //           ),
//           //           child: Text("Upload Karein"),
//           //         ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart'; // Naya import
import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';

class ConfirmUploadScreen extends StatefulWidget {
  // StatelessWidget ko StatefulWidget kiya preview ke liye
  final File videoFile;
  ConfirmUploadScreen({required this.videoFile});

  @override
  State<ConfirmUploadScreen> createState() => _ConfirmUploadScreenState();
}

class _ConfirmUploadScreenState extends State<ConfirmUploadScreen> {
  final TextEditingController _captionController = TextEditingController();
  final controller = Get.find<ReelsController>();
  late VideoPlayerController _videoController; // Preview controller

  @override
  void initState() {
    super.initState();
    // Video preview initialize ho rahi hai
    _videoController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
        _videoController.setVolume(0); // Sound off for preview
      });
  }

  @override
  void dispose() {
    _videoController.dispose(); // Memory cleanup
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post Reel"), backgroundColor: Colors.black),
      body: SingleChildScrollView(
        // Screen scrollable taaki keyboard masla na kare
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- VIDEO PREVIEW SECTION (Updated from Grey Box) ---
            Container(
              height: 300,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: _videoController.value.isInitialized
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _captionController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Caption likhein...",
                  border: UnderlineInputBorder(),
                ),
              ),
            ),

            Obx(() {
              return controller.isLoading.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: controller.uploadProgress.value,
                              backgroundColor: Colors.grey[200],
                              color: Colors.blueAccent,
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Uploading: ${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            if (_captionController.text.isNotEmpty) {
                              controller.uploadVideo(
                                _captionController.text,
                                widget.videoFile.path,
                              );
                            } else {
                              Get.snackbar(
                                "Caption Missing",
                                "Please write something about your reel",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          child: const Text(
                            "Share Reel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
