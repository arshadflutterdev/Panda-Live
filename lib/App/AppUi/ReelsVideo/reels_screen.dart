// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/reel_player_screen.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';

// class ReelsScreen extends StatelessWidget {
//   const ReelsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ReelsController());

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // 1. Main Video PageView
//           Obx(
//             () => PageView.builder(
//               scrollDirection: Axis.vertical,
//               itemCount: controller.videoList.length,
//               // ReelsScreen ke PageView.builder mein ye update karein:
//               itemBuilder: (context, index) {
//                 final data = controller.videoList[index];

//                 return VideoPlayerItem(
//                   videoUrl: data.videoUrl,
//                   username: data.username,
//                   caption: data.caption,
//                   // Agar model mein profile pic ka field hai toh data.userImage
//                   // warna filhal placeholder use karlein
//                   profilePic:
//                       data.profilePic ??
//                       "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png",
//                 );
//               },
//             ),
//           ),

//           // 2. Top Bar (Tabs & Upload)
//           Positioned(
//             top: 50,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // UPLOAD BUTTON
//                 IconButton(
//                   icon: Icon(
//                     Icons.add_box_outlined,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                   onPressed: () => controller.pickVideo(),
//                 ),
//                 const SizedBox(width: 20),
//                 // TABS
//                 Text(
//                   "Following",
//                   style: TextStyle(color: Colors.white60, fontSize: 17),
//                 ),
//                 const SizedBox(width: 15),
//                 Text("|", style: TextStyle(color: Colors.white30)),
//                 const SizedBox(width: 15),
//                 Text(
//                   "For You",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 17,
//                   ),
//                 ),
//                 const SizedBox(width: 50), // Balance ke liye
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  final String username;
  final String caption;
  final String profilePic;

  const VideoPlayerItem({
    super.key,
    required this.videoUrl,
    required this.videoId,
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
  final ReelsController controller = Get.find();

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
    final size = MediaQuery.of(context).size;
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

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
          // 1. Video Player
          Container(
            width: size.width,
            height: size.height,
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

          // 2. Play Icon
          if (isPaused)
            const Center(
              child: Icon(Icons.play_arrow, size: 80, color: Colors.white54),
            ),

          // 3. Side Buttons (Right)
          Positioned(
            right: 15,
            bottom: 60,
            child: Column(
              children: [
                _buildProfile(),
                const SizedBox(height: 20),
                // Dynamic Like Button
                Obx(() {
                  final videoData = controller.videoList.firstWhere(
                    (v) => v.id == widget.videoId,
                  );
                  bool isLiked = videoData.likes.contains(currentUid);
                  return _buildIconButton(
                    Icons.favorite,
                    videoData.likes.length.toString(),
                    isLiked ? Colors.red : Colors.white,
                    () => controller.likeVideo(widget.videoId),
                  );
                }),
                _buildIconButton(Icons.comment, "0", Colors.white, () {}),
                _buildIconButton(Icons.reply, "Share", Colors.white, () {}),
              ],
            ),
          ),

          // 4. Details (Left Bottom)
          Positioned(
            left: 15,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@${widget.username}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.caption,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 35, color: color),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(widget.profilePic),
        ),
        Positioned(
          bottom: -5,
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
