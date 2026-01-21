import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
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
  bool _isEngineInitialized = false;
  Future<void> initAgoraEngine() async {
    //Requiest for Permission
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    if (status[Permission.camera] != PermissionStatus.granted ||
        status[Permission.microphone] != PermissionStatus.granted) {
      debugPrint("Permission Not Granted . Connot start stream");
      if (await Permission.camera.isDenied) {
        await Permission.camera.request();
      } else if (await Permission.camera.isPermanentlyDenied) {
        openAppSettings();
      }
    }
    // create engine
    _engine = createAgoraRtcEngine();
    //initlize engine with appId
    await _engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.setVideoEncoderConfiguration(
      VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 720, height: 1280),
        frameRate: 30,
        bitrate: 0, // 0 means standard bitrate
        mirrorMode: VideoMirrorModeType.videoMirrorModeEnabled,
      ),
    );
    //Register the event handler to listen for callbacks
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
        },
      ),
    );
    setupVideoView();
    joinChannel();
    setState(() {
      _isEngineInitialized = true;
    });
  }

  Future<void> joinChannel() async {
    _engine.joinChannel(
      token:
          "007eJxTYLBTUEjz6NANly05L5OmbHQz74ZwMdsiJpML7PzuPoWn1iowWKYYJ5mbm6YZG1ummKQkplkkGZqmGSabpxgkJ5unGafxLi3IbAhkZPhYHM/MyACBID4fQ0lqcUlmXrpzRmJeXmoOAwMAIqYfsA==",
      channelId: channelName,
      uid: 0,
      options: ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
  }

  void setupVideoView() {
    _localviewController = VideoViewController(
      rtcEngine: _engine,
      canvas: VideoCanvas(uid: 0),
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
        child: _isEngineInitialized && _localviewController != null
            ? AgoraVideoView(controller: _localviewController!)
            : CircularProgressIndicator(),
      ),
    );
  }
}
