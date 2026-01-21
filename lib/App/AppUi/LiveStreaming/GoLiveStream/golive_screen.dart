import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class GoliveScreen extends StatefulWidget {
  const GoliveScreen({super.key});

  @override
  State<GoliveScreen> createState() => _GoliveScreenState();
}

class _GoliveScreenState extends State<GoliveScreen> {
  late RtcEngine _engine;
  Future<void> initAgoraEngine() async {
    _engine = createAgoraRtcEngine();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
