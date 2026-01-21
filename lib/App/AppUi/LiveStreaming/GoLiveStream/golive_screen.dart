import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GoliveScreen extends StatefulWidget {
  const GoliveScreen({super.key});

  @override
  State<GoliveScreen> createState() => _GoliveScreenState();
}

class _GoliveScreenState extends State<GoliveScreen> {
  late RtcEngine _engine;
  final String appId = "5eda14d417924d9baf39e83613e8f8f5";
  final String channelName = "testingChannel";
  VideoViewController? _localviewController;
  RxBool isJoined = false.obs;
  Future<void> initAgoraEngine() async {
    // 1. Permissions
    await [Permission.camera, Permission.microphone].request();

    // 2. Initialize Engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    // 3. Register Handler (The MOST important part)
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");

          // STEP A: Create the controller ONLY when the connection is active
          _localviewController = VideoViewController(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
          );

          // STEP B: Update GetX to rebuild the UI
          isJoined.value = true;
        },
        onError: (ErrorCodeType err, String msg) {
          debugPrint("Agora Error: $err - $msg");
        },
      ),
    );

    // 4. Config Hardware
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    // 5. Join Channel (Await it!)
    await joinChannel();

    // NOTE: Remove setupVideoView() from the bottom of this function.
  }

  Future<void> joinChannel() async {
    await _engine.joinChannel(
      token:
          "007eJxTYLBTUEjz6NANly05L5OmbHQz74ZwMdsiJpML7PzuPoWn1iowWKYYJ5mbm6YZG1ummKQkplkkGZqmGSabpxgkJ5unGafxLi3IbAhkZPhYHM/MyACBID4fQ0lqcUlmXrpzRmJeXmoOAwMAIqYfsA==",
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initAgoraEngine();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Obx(
          () => isJoined.value && _localviewController != null
              ? AgoraVideoView(controller: _localviewController!)
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
