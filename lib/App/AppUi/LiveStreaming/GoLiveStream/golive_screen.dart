import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

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

    // final AgoraClient client = AgoraClient(
    //       agoraConnectionData: AgoraConnectionData(
    //         appId: "<--App Id-->",
    //         channelName: "test",
    //       ),
    //       enabledPermission: [Permission.camera, Permission.microphone],
    //     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
