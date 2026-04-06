// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerItem extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerItem({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerItem> createState() => _VideoPlayerItemState();
// }

// class _VideoPlayerItemState extends State<VideoPlayerItem> {
//   late VideoPlayerController videoPlayerController;
//   bool isPaused = false; // Pause state track karne ke liye

//   @override
//   void initState() {
//     super.initState();
//     videoPlayerController =
//         VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//           ..initialize().then((value) {
//             videoPlayerController.play();
//             videoPlayerController.setVolume(1);
//             videoPlayerController.setLooping(true);
//             setState(() {});
//           });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     videoPlayerController.dispose();
//   }

//   // Play/Pause toggle karne ka function
//   void toggleVideoPlay() {
//     setState(() {
//       if (videoPlayerController.value.isPlaying) {
//         videoPlayerController.pause();
//         isPaused = true;
//       } else {
//         videoPlayerController.play();
//         isPaused = false;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return GestureDetector(
//       onTap: toggleVideoPlay, // Screen tap karne par call hoga
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // 1. Video Player
//           Container(
//             width: size.width,
//             height: size.height,
//             decoration: const BoxDecoration(color: Colors.black),
//             child: videoPlayerController.value.isInitialized
//                 ? VideoPlayer(videoPlayerController)
//                 : const Center(
//                     child: CircularProgressIndicator(color: Colors.white),
//                   ),
//           ),

//           // 2. Pause Icon Overlay (TikTok Style)
//           if (isPaused)
//             Icon(
//               Icons.play_arrow,
//               size: 100,
//               color: Colors.white.withOpacity(0.5),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({super.key, required this.videoUrl});

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
  }

  // --- CACHE & INITIALIZE LOGIC ---
  Future<void> _initializeVideo() async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(
      widget.videoUrl,
    );
    File? videoFile;

    if (fileInfo == null) {
      videoFile = await DefaultCacheManager().getSingleFile(widget.videoUrl);
    } else {
      videoFile = fileInfo.file;
    }

    videoPlayerController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            isInitialized = true;
            videoPlayerController!.play();
            videoPlayerController!.setLooping(true);
          });
        }
      });
  }

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
          // 1. Video Player Layer
          Container(
            width: size.width,
            height: size.height,
            color: Colors.black,
            child: (isInitialized && videoPlayerController != null)
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: videoPlayerController!.value.size.width,
                      height: videoPlayerController!.value.size.height,
                      child: VideoPlayer(videoPlayerController!),
                    ),
                  )
                : const SizedBox.shrink(), // No Circle/Avatar
          ),

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
