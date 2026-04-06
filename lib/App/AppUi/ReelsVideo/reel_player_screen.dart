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

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((value) {
            videoPlayerController.play();
            videoPlayerController.setVolume(1);
            videoPlayerController.setLooping(true);
            setState(() {}); // Video ready hote hi screen update
          });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose(); // Memory bachane ke liye zaroori hai
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(color: Colors.black),
      child: videoPlayerController.value.isInitialized
          ? VideoPlayer(videoPlayerController)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
