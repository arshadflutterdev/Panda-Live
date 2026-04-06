import 'package:flutter/material.dart';

class ReelsLeftDetail extends StatelessWidget {
  final String username;
  final String caption;

  const ReelsLeftDetail({
    super.key,
    required this.username,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "@$username",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          caption,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.music_note, color: Colors.white, size: 15),
            const SizedBox(width: 5),
            Text(
              "Original Sound - $username",
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
