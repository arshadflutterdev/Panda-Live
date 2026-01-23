import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

class WatchStreamControllers extends GetxController {
  //main code to join you as audiance
  late RtcEngine engine;
  final String appId = "5eda14d417924d9baf39e83613e8f8f5";
  final String channelName = "testingChannel";
  final String appToken =
      "007eJxTYGiYa1Zzb+EvSU955zt1DCJf/iY+dlHPmzDDc4au6hT+KY4KDKapKYmGJikmhuaWRiYplkmJacaWqRbGZobGqRZpFmmmx/4VZjYEMjL8qb/BysgAgSA+H0NJanFJZl66c0ZiXl5qDgMDAH4iI9Q=";

  var remoteviewController = Rxn<VideoViewController>();
  var arg = Get.arguments;
  Future<void> joinasaudi() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));
    await engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    await engine.enableVideo();
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          if (remoteUid.toString() == arg["agoraUid"].toString()) {
            remoteviewController.value = VideoViewController.remote(
              rtcEngine: engine,
              canvas: VideoCanvas(uid: remoteUid),
              connection: connection,
            );
          }
        },

        onRemoteVideoStateChanged:
            (connection, remoteUid, state, reason, elapsed) {
              if (remoteUid.toString() == arg["agoraUid"].toString() &&
                  state == RemoteVideoState.remoteVideoStateDecoding) {
                if (remoteviewController.value == null) {
                  remoteviewController.value = VideoViewController.remote(
                    rtcEngine: engine,
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
              if (remoteUid.toString() == arg["agoraUid"].toString()) {
                remoteviewController.value = null;

                Get.back();
              }
            },
      ),
    );
    await engine.joinChannel(
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
}
