import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({super.key, required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
  bool isPaused = false; // Pause state track karne ke liye

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((value) {
            videoPlayerController.play();
            videoPlayerController.setVolume(1);
            videoPlayerController.setLooping(true);
            setState(() {});
          });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  // Play/Pause toggle karne ka function
  void toggleVideoPlay() {
    setState(() {
      if (videoPlayerController.value.isPlaying) {
        videoPlayerController.pause();
        isPaused = true;
      } else {
        videoPlayerController.play();
        isPaused = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: toggleVideoPlay, // Screen tap karne par call hoga
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Video Player
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(color: Colors.black),
            child: videoPlayerController.value.isInitialized
                ? VideoPlayer(videoPlayerController)
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
          ),

          // 2. Pause Icon Overlay (TikTok Style)
          if (isPaused)
            Icon(
              Icons.play_arrow,
              size: 100,
              color: Colors.white.withOpacity(0.5),
            ),
        ],
      ),
    );
  }
}
