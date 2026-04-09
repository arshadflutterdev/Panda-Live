import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String videoId; // <--- Ye line add karein
  const VideoPlayerItem({
    super.key,
    required this.videoUrl,
    required this.videoId,
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
  }

  // --- CACHE & INITIALIZE LOGIC ---
  // --- CACHE & INITIALIZE LOGIC (CLEAN VERSION) ---
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

    // 1. Controller create karein
    videoPlayerController = VideoPlayerController.file(videoFile);

    try {
      // 2. Initialization ka wait karein
      await videoPlayerController!.initialize();

      if (mounted) {
        setState(() {
          isInitialized = true;
          videoPlayerController!.setLooping(true);
          videoPlayerController!.play();

          // 3. Views update logic (ReelsController use karein)
          Get.find<ReelsController>().updateVideoViews(widget.videoId);
        });
      }
    } catch (e) {
      print("Video initialization error: $e");
    }
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
          // 1. Video Player Layer (Original Ratio Fix)
          Container(
            width: size.width,
            height: size.height,
            color: Colors.black, // Background black rahega agar ratio chota ho
            child: (isInitialized && videoPlayerController != null)
                ? Center(
                    child: AspectRatio(
                      aspectRatio: videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(videoPlayerController!),
                    ),
                  )
                : const SizedBox.shrink(), // No Loading Circle
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
