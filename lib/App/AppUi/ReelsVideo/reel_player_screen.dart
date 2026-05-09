// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // GetX ke imports ko consolidate kiya gaya hai
// import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// class VideoPlayerItem extends StatefulWidget {
//   final String videoUrl;
//   final String videoId;
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

//     // fetchVideos ko safe tareeqay se call karwaya gaya hai
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Is baat ko yakeeni banaya gaya hai ke controller pehle se registered ho
//       if (Get.isRegistered<ReelsController>()) {
//         Get.find<ReelsController>().fetchVideos();
//       }
//     });
//   }

//   // --- CACHE & INITIALIZE LOGIC ---
//   Future<void> _initializeVideo() async {
//     try {
//       // Direct network URL se controller initialize karein bina download complete hone ka wait kiye
//       videoPlayerController = VideoPlayerController.networkUrl(
//         Uri.parse(widget.videoUrl),
//       );

//       // 2. Initialization ka wait karein
//       await videoPlayerController!.initialize();

//       if (mounted) {
//         setState(() {
//           isInitialized = true;
//           videoPlayerController!.setLooping(true);
//           videoPlayerController!.play();

//           // 3. Views update logic (ReelsController use karein)
//           Get.find<ReelsController>().updateVideoViews(widget.videoId);

//           // --- YAHAN HUM LISTENER ADD KAR RAHE HAIN ---
//           videoPlayerController!.addListener(() {
//             if (videoPlayerController!.value.isInitialized) {
//               final duration = videoPlayerController!.value.duration.inSeconds
//                   .toDouble();
//               final position = videoPlayerController!.value.position.inSeconds
//                   .toDouble();

//               // Retention aur Limit check ka function call karein
//               if (position > 0 && duration > 0) {
//                 Get.find<ReelsController>().handleVideoViewCompletion(
//                   widget.videoId,
//                   duration,
//                   position,
//                 );
//               }
//             }
//           });
//           // ------------------------------------------
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
import 'dart:io'; // CHANGE HERE: Local file handle karne ke liye ye zaruri hai
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart'; // Standard import
import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';
import 'package:video_player/video_player.dart'; // Standard import
import 'package:get/get.dart'; // GetX ke liye

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
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<ReelsController>()) {
        Get.find<ReelsController>().fetchVideos();
      }
    });
  }

  // --- CACHE & INITIALIZE LOGIC (Updated) ---
  Future<void> _initializeVideo() async {
    try {
      // CHANGE HERE: Shared Pref ki bajaye Cache Manager use kar rahe hain data bachane ke liye
      var fileInfo = await DefaultCacheManager().getFileFromCache(
        widget.videoUrl,
      );
      File? videoFile;

      if (fileInfo == null) {
        // Pehli baar download karega
        videoFile = await DefaultCacheManager().getSingleFile(widget.videoUrl);
      } else {
        // Dobara play hone par local storage se uthayega
        videoFile = fileInfo.file;
      }

      // CHANGE HERE: .networkUrl ki bajaye .file use hoga kyunki video local save ho chuki hai
      videoPlayerController = VideoPlayerController.file(videoFile);

      await videoPlayerController!.initialize();

      if (mounted) {
        setState(() {
          isInitialized = true;
          videoPlayerController!.setLooping(true);
          videoPlayerController!.play();

          Get.find<ReelsController>().updateVideoViews(widget.videoId);

          // CHANGE HERE: Listener ko clean rakha hai sirf completion tracking ke liye
          videoPlayerController!.addListener(() {
            if (videoPlayerController!.value.isInitialized) {
              final duration = videoPlayerController!.value.duration.inSeconds
                  .toDouble();
              final position = videoPlayerController!.value.position.inSeconds
                  .toDouble();

              if (position > 0 && duration > 0) {
                Get.find<ReelsController>().handleVideoViewCompletion(
                  widget.videoId,
                  duration,
                  position,
                );
              }
            }
          });
        });
      }
    } catch (e) {
      print("Video initialization error: $e");
    }
  }

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
      onTap: togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Video Player Layer
          Container(
            width: size.width,
            height: size.height,
            color: Colors.black,
            child: (isInitialized && videoPlayerController != null)
                ? Center(
                    child: AspectRatio(
                      aspectRatio: videoPlayerController!.value.aspectRatio,
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

          // CHANGE HERE: Naya Progress Bar jo left side par mslsl (continuously) show hota rahega
          if (isInitialized && videoPlayerController != null)
            Positioned(
              left: 0,
              bottom: 0,
              top: 0,
              width: 3, // Line ki thickness
              child: Container(
                color: Colors.white.withOpacity(0.1), // Background track
                alignment: Alignment.bottomCenter,
                child: ValueListenableBuilder(
                  valueListenable: videoPlayerController!,
                  builder: (context, VideoPlayerValue value, child) {
                    double progress = 0;
                    if (value.duration.inMilliseconds > 0) {
                      progress =
                          value.position.inMilliseconds /
                          value.duration.inMilliseconds;
                    }
                    return Container(
                      height:
                          size.height *
                          progress, // Niche se upar progress barhegi
                      width: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // 2. Play Icon Overlay
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
