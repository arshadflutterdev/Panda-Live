import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class GoliveScreen extends StatefulWidget {
  const GoliveScreen({super.key});

  @override
  State<GoliveScreen> createState() => _GoliveScreenState();
}

class _GoliveScreenState extends State<GoliveScreen> {
  final String appId = "9d3b775f339d4daf8b15f1c7d0cc7f3f";
  final String channelName = "testing_channel";
  @override
  void initState() {
    super.initState();

    final AgoraClient client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "9d3b775f339d4daf8b15f1c7d0cc7f3f",
        channelName: "app_testing",
      ),
      enabledPermission: [Permission.camera, Permission.microphone],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
