// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';

// // class VideoPlayerItem extends StatefulWidget {
// //   final String videoUrl;
// //   const VideoPlayerItem({super.key, required this.videoUrl});

// //   @override
// //   State<VideoPlayerItem> createState() => _VideoPlayerItemState();
// // }

// // class _VideoPlayerItemState extends State<VideoPlayerItem> {
// //   late VideoPlayerController videoPlayerController;
// //   bool isPaused = false; // Pause state track karne ke liye

// //   @override
// //   void initState() {
// //     super.initState();
// //     videoPlayerController =
// //         VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
// //           ..initialize().then((value) {
// //             videoPlayerController.play();
// //             videoPlayerController.setVolume(1);
// //             videoPlayerController.setLooping(true);
// //             setState(() {});
// //           });
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     videoPlayerController.dispose();
// //   }

// //   // Play/Pause toggle karne ka function
// //   void toggleVideoPlay() {
// //     setState(() {
// //       if (videoPlayerController.value.isPlaying) {
// //         videoPlayerController.pause();
// //         isPaused = true;
// //       } else {
// //         videoPlayerController.play();
// //         isPaused = false;
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;

// //     return GestureDetector(
// //       onTap: toggleVideoPlay, // Screen tap karne par call hoga
// //       child: Stack(
// //         alignment: Alignment.center,
// //         children: [
// //           // 1. Video Player
// //           Container(
// //             width: size.width,
// //             height: size.height,
// //             decoration: const BoxDecoration(color: Colors.black),
// //             child: videoPlayerController.value.isInitialized
// //                 ? VideoPlayer(videoPlayerController)
// //                 : const Center(
// //                     child: CircularProgressIndicator(color: Colors.white),
// //                   ),
// //           ),

// //           // 2. Pause Icon Overlay (TikTok Style)
// //           if (isPaused)
// //             Icon(
// //               Icons.play_arrow,
// //               size: 100,
// //               color: Colors.white.withOpacity(0.5),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// class VideoPlayerItem extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerItem({super.key, required this.videoUrl});

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
//   Future<void> _initializeVideo() async {
//     // Cache se file check karna
//     final fileInfo = await DefaultCacheManager().getFileFromCache(
//       widget.videoUrl,
//     );
//     File? videoFile;

//     if (fileInfo == null) {
//       // Agar cache mein nahi hai toh download karein
//       videoFile = await DefaultCacheManager().getSingleFile(widget.videoUrl);
//     } else {
//       // Agar hai toh wahi file uthayein
//       videoFile = fileInfo.file;
//     }

//     // Controller ko file provide karna
//     videoPlayerController = VideoPlayerController.file(videoFile)
//       ..initialize().then((_) {
//         if (mounted) {
//           setState(() {
//             isInitialized = true;
//             videoPlayerController!.play();
//             videoPlayerController!.setLooping(true);
//           });
//         }
//       });
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
//             color: Colors.black, // Background black rahega agar ratio chota ho
//             child: (isInitialized && videoPlayerController != null)
//                 ? Center(
//                     child: AspectRatio(
//                       aspectRatio: videoPlayerController!.value.aspectRatio,
//                       child: VideoPlayer(videoPlayerController!),
//                     ),
//                   )
//                 : const SizedBox.shrink(), // No Loading Circle
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
import 'package:pandlive/App/AppUi/ReelsVideo/reels_left_details.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/reels_sidebar_buttons.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String username;
  final String caption;
  final String profilePic;

  const VideoPlayerItem({
    super.key,
    required this.videoUrl,
    required this.username,
    required this.caption,
    required this.profilePic,
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
  }

  Future<void> _initializeVideo() async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(
      widget.videoUrl,
    );
    File? videoFile =
        fileInfo?.file ??
        await DefaultCacheManager().getSingleFile(widget.videoUrl);

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

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          videoPlayerController!.value.isPlaying
              ? videoPlayerController!.pause()
              : videoPlayerController!.play();
          isPaused = !videoPlayerController!.value.isPlaying;
        });
      },
      child: Stack(
        children: [
          // 1. Original Ratio Video
          Container(
            color: Colors.black,
            child: isInitialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController!),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // 2. Play Icon Overlay
          if (isPaused)
            const Center(
              child: Icon(Icons.play_arrow, size: 80, color: Colors.white54),
            ),

          // 3. Right Side Buttons (Profile, Like, Comment, Share)
          Positioned(
            right: 15,
            bottom: 60,
            child: Column(
              children: [
                _profileImage(),
                const SizedBox(height: 20),
                const ReelsSideButtons(
                  videoId: "123",
                  likes: "10k",
                  comments: "500",
                ),
              ],
            ),
          ),

          // 4. Left Side Bottom Details
          Positioned(
            left: 15,
            bottom: 30,
            child: ReelsLeftDetail(
              username: widget.username,
              caption: widget.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(widget.profilePic),
        ),
        Positioned(
          bottom: -8,
          left: 15,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}
