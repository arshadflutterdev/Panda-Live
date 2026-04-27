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
  final String filter;
  final List<double>? filterMatrix;

  const ConfirmUploadScreen({
    super.key,
    required this.videoFile,
    this.startTime,
    this.endTime,
    this.overlayText,
    this.textPosition,
    this.textColor,
    this.fontSize,
    required this.isBold,
    required this.isItalic,
    required this.filter,
    this.filterMatrix,
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
            child: Stack(
              // Yahan Full Screen mein bhi Text Preview add kiya hai
              alignment: Alignment.center,
              children: [
                ColorFiltered(
                  colorFilter: widget.filterMatrix != null
                      ? ColorFilter.matrix(widget.filterMatrix!)
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        ),
                  child: AspectRatio(
                    aspectRatio: _previewController.value.aspectRatio,
                    child: VideoPlayer(_previewController),
                  ),
                ),

                // AspectRatio(
                //   aspectRatio: _previewController.value.aspectRatio,
                //   child: VideoPlayer(_previewController),
                // ),
                if (widget.overlayText != null &&
                    widget.overlayText!.isNotEmpty)
                  Positioned(
                    left: widget.textPosition?.dx,
                    top: widget.textPosition?.dy,
                    child: Text(
                      widget.overlayText!,
                      style: TextStyle(
                        color: widget.textColor ?? Colors.white,
                        fontSize: widget.fontSize ?? 25,
                        fontWeight: widget.isBold
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontStyle: widget.isItalic
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    )?.then((value) => _previewController.pause());
  }

  @override
  Widget build(BuildContext context) {
    print("Check Matrix: ${widget.filterMatrix}");
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
                            // --- TEXT PREVIEW ON THUMBNAIL ---
                            if (widget.overlayText != null &&
                                widget.overlayText!.isNotEmpty)
                              Positioned(
                                // Scaled down positioning for thumbnail
                                left: (widget.textPosition?.dx ?? 0) / 4,
                                top: (widget.textPosition?.dy ?? 0) / 4,
                                child: Text(
                                  widget.overlayText!,
                                  style: TextStyle(
                                    color: widget.textColor ?? Colors.white,
                                    fontSize:
                                        (widget.fontSize ?? 25) /
                                        4, // Smaller text for thumbnail
                                    fontWeight: widget.isBold
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
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
                              Get.back();
                              controller.uploadVideo(
                                _captionController.text,
                                widget.videoFile.path,
                                start: widget.startTime,
                                end: widget.endTime,
                                filterMatrix: widget
                                    .filterMatrix, // Preview ke liye matrix
                                filterString: widget
                                    .filter, // FFmpeg command ke liye string
                                overlayText: widget.overlayText,
                              );
                              Get.snackbar(
                                "Success",
                                "Uploading trimmed video...",
                              );
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
// class ConfirmUploadScreen extends StatefulWidget {
//   final File videoFile;
//   // Trim points handle karne ke liye
//   final Duration? startTime;
//   final Duration? endTime;
//   final String? overlayText;
//   final Offset? textPosition;
//   final Color? textColor;
//   final double? fontSize;
//   final bool isBold;
//   final bool isItalic;

//   ConfirmUploadScreen({
//     required this.videoFile,
//     this.startTime,
//     this.endTime,
//     this.overlayText,
//     this.textPosition,
//     this.textColor,
//     this.fontSize,
//     required this.isBold,
//     required this.isItalic,
//   });

//   @override
//   State<ConfirmUploadScreen> createState() => _ConfirmUploadScreenState();
// }

// class _ConfirmUploadScreenState extends State<ConfirmUploadScreen> {
//   final TextEditingController _captionController = TextEditingController();
//   final controller = Get.find<ReelsController>();

//   late VideoPlayerController _previewController;

//   @override
//   void initState() {
//     super.initState();
//     _previewController = VideoPlayerController.file(widget.videoFile)
//       ..initialize().then((_) {
//         // Sirf seek set kiya hai trim ke liye
//         if (widget.startTime != null) {
//           _previewController.seekTo(widget.startTime!);
//         }
//         _previewController.addListener(() {
//           if (widget.endTime != null &&
//               _previewController.value.position >= widget.endTime!) {
//             _previewController.seekTo(widget.startTime ?? Duration.zero);
//           }
//         });
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _previewController.dispose();
//     _captionController.dispose();
//     super.dispose();
//   }

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
//                   GestureDetector(
//                     onTap: _showFullScreenPreview,
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
//                     :
//                       // 1. Post Button ka logic
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFE94359),
//                           ),
//                           onPressed: () {
//                             if (_captionController.text.isNotEmpty) {
//                               // Screen piche le jao
//                               Get.back();

//                               // Background mein upload start karo with TRIM points
//                               controller.uploadVideo(
//                                 _captionController.text,
//                                 widget.videoFile.path,
//                                 // YE DO LINES LAAZMI HAIN
//                                 start: widget.startTime,
//                                 end: widget.endTime,
//                               );

//                               Get.snackbar(
//                                 "Success",
//                                 "Uploading trimmed video...",
//                               );
//                             }
//                           },
                        
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
