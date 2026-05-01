// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// class VideoPlayerItem extends StatefulWidget {
//   final String videoUrl;

//   final String videoId; // <--- Ye line add karein
//   final List<dynamic>? filterMatrix;
//   const VideoPlayerItem({
//     super.key,
//     required this.videoUrl,
//     required this.videoId,
//     this.filterMatrix,
//   });

//   @override
//   State<VideoPlayerItem> createState() => _VideoPlayerItemState();
// }

// class _VideoPlayerItemState extends State<VideoPlayerItem> {
//   VideoPlayerController? videoPlayerController;
//   bool isInitialized = false;
//   bool isPaused = false; // Play/Pause track karne ke liye

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }

//   // --- CACHE & INITIALIZE LOGIC ---
//   // --- CACHE & INITIALIZE LOGIC (CLEAN VERSION) ---
//   Future<void> _initializeVideo() async {
//     final fileInfo = await DefaultCacheManager().getFileFromCache(
//       widget.videoUrl,
//     );
//     File? videoFile;

//     if (fileInfo == null) {
//       videoFile = await DefaultCacheManager().getSingleFile(widget.videoUrl);
//     } else {
//       videoFile = fileInfo.file;
//     }

//     // 1. Controller create karein
//     videoPlayerController = VideoPlayerController.file(videoFile);

//     try {
//       // 2. Initialization ka wait karein
//       await videoPlayerController!.initialize();

//       if (mounted) {
//         setState(() {
//           isInitialized = true;
//           videoPlayerController!.setLooping(true);
//           videoPlayerController!.play();

//           // 3. Views update logic (ReelsController use karein)
//           Get.find<ReelsController>().updateVideoViews(widget.videoId);
//         });
//       }
//     } catch (e) {
//       print("Video initialization error: $e");
//     }
//   }

//   // --- PLAY/PAUSE TOGGLE FUNCTION ---
//   void togglePlayPause() {
//     if (videoPlayerController != null &&
//         videoPlayerController!.value.isInitialized) {
//       setState(() {
//         if (videoPlayerController!.value.isPlaying) {
//           videoPlayerController!.pause();
//           isPaused = true;
//         } else {
//           videoPlayerController!.play();
//           isPaused = false;
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     videoPlayerController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return GestureDetector(
//       onTap: togglePlayPause, // Tap to Play/Pause
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // 1. Video Player Layer (Original Ratio Fix)
//           Container(
//             width: size.width,
//             height: size.height,
//             color: Colors.black,
//             child: (isInitialized && videoPlayerController != null)
//                 ? Center(
//                     child: AspectRatio(
//                       aspectRatio: videoPlayerController!.value.aspectRatio,
//                       // --- FILTER YAHAN APPLY HOGA ---
//                       child: ColorFiltered(
//                         colorFilter:
//                             (widget.filterMatrix != null &&
//                                 widget.filterMatrix!.length == 20)
//                             ? ColorFilter.matrix(
//                                 List<double>.from(
//                                   widget.filterMatrix!.map(
//                                     (e) => (e as num).toDouble(),
//                                   ),
//                                 ),
//                               )
//                             : const ColorFilter.mode(
//                                 Colors.transparent,
//                                 BlendMode.multiply,
//                               ),
//                         child: VideoPlayer(videoPlayerController!),
//                       ),
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//           ),

//           // 2. Play Icon Overlay (Sirf Pause hone par dikhega)
//           if (isPaused)
//             Icon(
//               Icons.play_arrow,
//               size: 80,
//               color: Colors.white.withOpacity(0.5),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX ke imports ko consolidate kiya gaya hai
import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  final List<dynamic>? filterMatrix;

  const VideoPlayerItem({
    super.key,
    required this.videoUrl,
    required this.videoId,
    this.filterMatrix,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController? videoPlayerController;
  bool isInitialized = false;
  bool isPaused = false; // Play/Pause track karne ke liye

  @override
  void initState() {
    super.initState();
    _initializeVideo();

    // fetchVideos ko safe tareeqay se call karwaya gaya hai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Is baat ko yakeeni banaya gaya hai ke controller pehle se registered ho
      if (Get.isRegistered<ReelsController>()) {
        Get.find<ReelsController>().fetchVideos();
      }
    });
  }

  // --- CACHE & INITIALIZE LOGIC ---
  Future<void> _initializeVideo() async {
    try {
      // Direct network URL se controller initialize karein bina download complete hone ka wait kiye
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      // 2. Initialization ka wait karein
      await videoPlayerController!.initialize();

      if (mounted) {
        setState(() {
          isInitialized = true;
          videoPlayerController!.setLooping(true);
          videoPlayerController!.play();

          // 3. Views update logic (ReelsController use karein)
          Get.find<ReelsController>().updateVideoViews(widget.videoId);

          // --- YAHAN HUM LISTENER ADD KAR RAHE HAIN ---
          videoPlayerController!.addListener(() {
            if (videoPlayerController!.value.isInitialized) {
              final duration = videoPlayerController!.value.duration.inSeconds
                  .toDouble();
              final position = videoPlayerController!.value.position.inSeconds
                  .toDouble();

              // Retention aur Limit check ka function call karein
              if (position > 0 && duration > 0) {
                Get.find<ReelsController>().handleVideoViewCompletion(
                  widget.videoId,
                  duration,
                  position,
                );
              }
            }
          });
          // ------------------------------------------
        });
      }
    } catch (e) {
      print("Video initialization error: $e");
    }
  }

  // Future<void> _initializeVideo() async {
  //   final fileInfo = await DefaultCacheManager().getFileFromCache(
  //     widget.videoUrl,
  //   );
  //   File? videoFile;

  //   if (fileInfo == null) {
  //     videoFile = await DefaultCacheManager().getSingleFile(widget.videoUrl);
  //   } else {
  //     videoFile = fileInfo.file;
  //   }

  //   // 1. Controller create karein
  //   videoPlayerController = VideoPlayerController.file(videoFile);

  //   try {
  //     // 2. Initialization ka wait karein
  //     await videoPlayerController!.initialize();

  //     if (mounted) {
  //       setState(() {
  //         isInitialized = true;
  //         videoPlayerController!.setLooping(true);
  //         videoPlayerController!.play();

  //         // 3. Views update logic (ReelsController use karein)
  //         Get.find<ReelsController>().updateVideoViews(widget.videoId);

  //         // --- YAHAN HUM LISTENER ADD KAR RAHE HAIN ---
  //         videoPlayerController!.addListener(() {
  //           if (videoPlayerController!.value.isInitialized) {
  //             final duration = videoPlayerController!.value.duration.inSeconds
  //                 .toDouble();
  //             final position = videoPlayerController!.value.position.inSeconds
  //                 .toDouble();

  //             // Retention aur Limit check ka function call karein
  //             if (position > 0 && duration > 0) {
  //               Get.find<ReelsController>().handleVideoViewCompletion(
  //                 widget.videoId,
  //                 duration,
  //                 position,
  //               );
  //             }
  //           }
  //         });
  //         // ------------------------------------------
  //       });
  //     }
  //   } catch (e) {
  //     print("Video initialization error: $e");
  //   }
  // }

  // --- PLAY/PAUSE TOGGLE FUNCTION ---
  void togglePlayPause() {
    if (videoPlayerController != null &&
        videoPlayerController!.value.isInitialized) {
      setState(() {
        if (videoPlayerController!.value.isPlaying) {
          videoPlayerController!.pause();
          isPaused = true;
        } else {
          videoPlayerController!.play();
          isPaused = false;
        }
      });
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: togglePlayPause, // Tap to Play/Pause
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Video Player Layer (Original Ratio Fix)
          Container(
            width: size.width,
            height: size.height,
            color: Colors.black,
            child: (isInitialized && videoPlayerController != null)
                ? Center(
                    child: AspectRatio(
                      aspectRatio: videoPlayerController!.value.aspectRatio,
                      // --- FILTER YAHAN APPLY HOGA ---
                      child: ColorFiltered(
                        colorFilter:
                            (widget.filterMatrix != null &&
                                widget.filterMatrix!.length == 20)
                            ? ColorFilter.matrix(
                                List<double>.from(
                                  widget.filterMatrix!.map(
                                    (e) => (e as num).toDouble(),
                                  ),
                                ),
                              )
                            : const ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.multiply,
                              ),
                        child: VideoPlayer(videoPlayerController!),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Container(
          //   width: size.width,
          //   height: size.height,
          //   color: Colors.black,
          //   child: (isInitialized && videoPlayerController != null)
          //       ? Center(
          //           child: AspectRatio(
          //             aspectRatio: videoPlayerController!.value.aspectRatio,
          //             // --- FILTER YAHAN APPLY HOGA ---
          //             child: ColorFiltered(
          //               colorFilter:
          //                   (widget.filterMatrix != null &&
          //                       widget.filterMatrix!.length == 20)
          //                   ? ColorFilter.matrix(
          //                       List<double>.from(
          //                         widget.filterMatrix!.map(
          //                           (e) => (e as num).toDouble(),
          //                         ),
          //                       ),
          //                     )
          //                   : const ColorFilter.mode(
          //                       Colors.transparent,
          //                       BlendMode.multiply,
          //                     ),
          //               child: VideoPlayer(videoPlayerController!),
          //             ),
          //           ),
          //         )
          //       : const SizedBox.shrink(),
          // ),

          // 2. Play Icon Overlay (Sirf Pause hone par dikhega)
          if (isPaused)
            Icon(
              Icons.play_arrow,
              size: 80,
              color: Colors.white.withOpacity(0.5),
            ),
        ],
      ),
    );
  }
}
