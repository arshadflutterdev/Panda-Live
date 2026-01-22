import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

class WatchstreamingClass extends StatefulWidget {
  const WatchstreamingClass({super.key});

  @override
  State<WatchstreamingClass> createState() => _WatchstreamingClassState();
}

class _WatchstreamingClassState extends State<WatchstreamingClass> {
  final arg = Get.arguments;

  late RtcEngine _engine;
  final String appId = "5eda14d417924d9baf39e83613e8f8f5";
  final String channelName = "testingChannel";
  final String appToken =
      "007eJxTYLBTUEjz6NANly05L5OmbHQz74ZwMdsiJpML7PzuPoWn1iowWKYYJ5mbm6YZG1ummKQkplkkGZqmGSabpxgkJ5unGafxLi3IbAhkZPhYHM/MyACBID4fQ0lqcUlmXrpzRmJeXmoOAwMAIqYfsA==";

  var remoteviewController = Rxn<VideoViewController>();
  Future<void> joinasaudi() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId));
    await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    await _engine.enableVideo();
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          if (remoteUid == arg["agoraUid"]) {
            remoteviewController.value = VideoViewController.remote(
              rtcEngine: _engine,
              canvas: VideoCanvas(uid: remoteUid),
              connection: connection,
            );
          }
        },

        onRemoteVideoStateChanged:
            (connection, remoteUid, state, reason, elapsed) {
              if (remoteUid == arg["agoraUid"] &&
                  state == RemoteVideoState.remoteVideoStateDecoding) {
                if (remoteviewController.value == null) {
                  remoteviewController.value = VideoViewController.remote(
                    rtcEngine: _engine,
                    canvas: VideoCanvas(uid: remoteUid),
                    connection: connection,
                  );
                }
              }
            },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              if (remoteUid == arg["agoraUid"]) {
                remoteviewController.value = null;

                Get.back();
              }
            },
      ),
    );
    await _engine.joinChannel(
      token: appToken,
      channelId: channelName,
      uid: 0,
      options: ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        publishCameraTrack: false,
        publishMicrophoneTrack: false,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  Future<void> updateviews(int amount) async {
    try {
      FirebaseFirestore.instance
          .collection("LiveStream")
          .doc(arg["agoraUid"])
          .update({"views": FieldValue.increment(amount)});
    } catch (e) {
      debugPrint("views related issue $e");
    }
  }

  @override
  void initState() {
    super.initState();

    joinasaudi();
    updateviews(1);
  }

  @override
  void dispose() {
    updateviews(-1);
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => remoteviewController.value != null
              ? AgoraVideoView(controller: remoteviewController.value!)
              : Text("No one live now"),
        ),
      ),
    );
  }
}
