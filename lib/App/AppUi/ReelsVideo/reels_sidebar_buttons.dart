import 'package:flutter/material.dart';

class ReelsSideButtons extends StatelessWidget {
  final String videoId;
  final String likes;
  final String comments;

  const ReelsSideButtons({
    super.key,
    required this.videoId,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildIcon(Icons.favorite, likes, Colors.red),
        const SizedBox(height: 18),
        _buildIcon(Icons.comment, comments, Colors.white),
        const SizedBox(height: 18),
        _buildIcon(Icons.reply, "Share", Colors.white),
        const SizedBox(height: 15),
        _musicAlbumAnimation(),
      ],
    );
  }

  Widget _buildIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 35, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _musicAlbumAnimation() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const SweepGradient(
          colors: [Colors.black, Colors.grey, Colors.black],
        ),
        border: Border.all(color: Colors.white24, width: 8),
      ),
      child: const Icon(Icons.music_note, color: Colors.white, size: 20),
    );
  }
}
