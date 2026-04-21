import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editor/video_editor.dart';
import 'confirm_upload_screen.dart';

class VideoEditingScreen extends StatefulWidget {
  final File file;
  const VideoEditingScreen({super.key, required this.file});

  @override
  State<VideoEditingScreen> createState() => _VideoEditingScreenState();
}

class _VideoEditingScreenState extends State<VideoEditingScreen> {
  late VideoEditorController _controller;
  final RxBool isInitialized = false.obs;
  final RxBool isPlaying = false.obs;

  // --- TEXT EDITING STATE ---
  final RxString overlayText = "".obs;
  final Rx<Offset> textPosition = const Offset(120, 250).obs;
  final RxBool isBold = false.obs;
  final RxBool isItalic = false.obs;
  final RxDouble fontSize = 25.0.obs;
  final RxBool isEditingMode = false.obs;
  double _baseFontSize = 25.0;

  // --- NEW COLOR CYCLE LOGIC ---
  final List<Color> textColors = [
    Colors.white,
    Colors.yellowAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.cyanAccent,
    Colors.limeAccent,
  ];
  final RxInt currentColorIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoEditorController.file(
            widget.file,
            minDuration: const Duration(seconds: 1),
            maxDuration: const Duration(seconds: 60),
          )
          ..initialize().then((_) {
            isInitialized.value = true;
            _controller.video.addListener(() {
              isPlaying.value = _controller.video.value.isPlaying;
            });
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openTextEditor() {
    isEditingMode.value = true;
    TextEditingController tEdit = TextEditingController(
      text: overlayText.value,
    );
    Get.defaultDialog(
      title: "Edit Text",
      backgroundColor: Colors.grey[900],
      titleStyle: const TextStyle(color: Colors.white),
      content: TextField(
        controller: tEdit,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Write here...",
          hintStyle: TextStyle(color: Colors.white24),
        ),
      ),
      confirm: TextButton(
        onPressed: () {
          overlayText.value = tEdit.text;
          Get.back();
        },
        child: const Text(
          "OK",
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => isInitialized.value
            ? SafeArea(
                child: Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              isEditingMode.value = false;
                              isPlaying.value
                                  ? _controller.video.pause()
                                  : _controller.video.play();
                            },
                            child: CropGridViewer.preview(
                              controller: _controller,
                            ),
                          ),
                          _buildTextLayer(),
                          if (!isPlaying.value && !isEditingMode.value)
                            const IgnorePointer(
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                        ],
                      ),
                    ),
                    _buildBottomControls(),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              ),
      ),
    );
  }

  Widget _buildTextLayer() {
    return Obx(() {
      if (overlayText.value.isEmpty && !isEditingMode.value)
        return const SizedBox.shrink();

      return Stack(
        children: [
          Positioned(
            left: textPosition.value.dx,
            top: textPosition.value.dy,
            child: GestureDetector(
              onScaleStart: (_) => _baseFontSize = fontSize.value,
              onScaleUpdate: (details) {
                textPosition.value += details.focalPointDelta;
                if (details.scale != 1.0) {
                  fontSize.value = (_baseFontSize * details.scale).clamp(
                    10.0,
                    150.0,
                  );
                }
              },
              onTap: _openTextEditor,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isEditingMode.value
                      ? Colors.black54
                      : Colors.transparent,
                  border: isEditingMode.value
                      ? Border.all(color: Colors.blueAccent, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  overlayText.value.isEmpty
                      ? "Tap to Enter Text"
                      : overlayText.value,
                  style: TextStyle(
                    color: textColors[currentColorIndex.value], // Dynamic Color
                    fontSize: fontSize.value,
                    fontWeight: isBold.value
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontStyle: isItalic.value
                        ? FontStyle.italic
                        : FontStyle.normal,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isEditingMode.value)
            Positioned(right: 20, top: 100, child: _buildSideEditorTools()),
        ],
      );
    });
  }

  Widget _buildSideEditorTools() {
    return Column(
      children: [
        _toolIcon(
          Icons.format_bold,
          () => isBold.value = !isBold.value,
          isBold.value,
        ),
        const SizedBox(height: 15),
        _toolIcon(
          Icons.format_italic,
          () => isItalic.value = !isItalic.value,
          isItalic.value,
        ),
        const SizedBox(height: 15),

        // --- UPDATED COLOR CYCLE BUTTON ---
        _toolIcon(
          Icons.palette,
          () {
            if (currentColorIndex.value < textColors.length - 1) {
              currentColorIndex.value++;
            } else {
              currentColorIndex.value = 0; // Reset to first color
            }
          },
          false,
          color: textColors[currentColorIndex.value],
        ),

        const SizedBox(height: 30),
        _toolIcon(
          Icons.delete_outline,
          () {
            overlayText.value = "";
            isEditingMode.value = false;
          },
          false,
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _toolIcon(
    IconData icon,
    VoidCallback onTap,
    bool active, {
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: active ? Colors.blueAccent : Colors.black87,
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const Text(
            "Video Editor",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: _finishEditing,
            child: const Text(
              "Next",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      child: Column(
        children: [
          TrimSlider(controller: _controller, height: 50, horizontalMargin: 0),
          const SizedBox(height: 20),
          IconButton(
            icon: const Icon(Icons.text_fields, color: Colors.white, size: 35),
            onPressed: () {
              isEditingMode.value = true;
              if (overlayText.value.isEmpty) _openTextEditor();
            },
          ),
          const Text(
            "Add Text",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _finishEditing() {
    if (_controller.video.value.isPlaying) {
      _controller.video.pause();
    }

    // --- FIX: Calculation logic update ---
    // Duration ko pehle milliseconds mein convert karein phir multiply karein
    final int totalMs = _controller.video.value.duration.inMilliseconds;

    final Duration start = Duration(
      milliseconds: (totalMs * _controller.minTrim).toInt(),
    );
    final Duration end = Duration(
      milliseconds: (totalMs * _controller.maxTrim).toInt(),
    );

    Get.off(
      () => ConfirmUploadScreen(
        videoFile: widget.file,
        startTime: start,
        endTime: end,
        overlayText: overlayText.value,
        textPosition: textPosition.value,
        textColor: textColors[currentColorIndex.value],
        fontSize: fontSize.value,
        isBold: isBold.value,
        isItalic: isItalic.value,
      ),
    );
  }

  // void _finishEditing() {
  //   final Duration start =
  //       _controller.video.value.duration * _controller.minTrim;
  //   final Duration end = _controller.video.value.duration * _controller.maxTrim;
  //   Get.off(
  //     () => ConfirmUploadScreen(
  //       videoFile: widget.file,
  //       startTime: start,
  //       endTime: end,
  //       isBold: false,
  //       isItalic: false,
  //     ),
  //   );
  // }
}
