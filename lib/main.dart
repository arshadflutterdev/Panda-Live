import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/firebase_options.dart';
import 'package:pandlive/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 1. Load the saved language from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  String? savedLang = prefs.getString("language_code");

  // 2. Determine initial locale (Defaults to English if null)
  Locale initialLocale = Locale(savedLang ?? "en");

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Use the locale we loaded from SharedPreferences
      locale: initialLocale,

      // Fallback should usually be English in case a translation is missing
      fallbackLocale: const Locale("en"),

      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      title: 'PandLive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: JoinadnWatch(),
    );
  }
}

//join live and watch stream
class JoinadnWatch extends StatefulWidget {
  const JoinadnWatch({super.key});

  @override
  State<JoinadnWatch> createState() => _JoinadnWatchState();
}

class _JoinadnWatchState extends State<JoinadnWatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.golive);
              },
              child: Text("Start Live"),
            ),
            Gap(20),
            ElevatedButton(onPressed: () {}, child: Text("Watch Live")),
          ],
        ),
      ),
    );
  }
}

// Replace with your Agora App ID
const String appId = "9d3b775f339d4daf8b15f1c7d0cc7f3f";
const String channelName = "live123";
const String token = ""; // Empty for dev

class HostLiveScreen extends StatefulWidget {
  const HostLiveScreen({Key? key}) : super(key: key);

  @override
  State<HostLiveScreen> createState() => _HostLiveScreenState();
}

class _HostLiveScreenState extends State<HostLiveScreen> {
  late RtcEngine _engine;
  bool _micOn = true;
  bool _permissionsGranted = false;
  bool _isEngineInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    var statuses = await [Permission.camera, Permission.microphone].request();

    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.microphone] == PermissionStatus.granted) {
      setState(() => _permissionsGranted = true);
      _initAgora();
    } else {
      // Show alert if permissions denied
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Permissions Required"),
          content: const Text(
            "Camera and microphone permissions are required for live streaming. Please enable them in app settings.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("Joined channel: ${connection.channelId}");
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print("Remote user joined: $remoteUid");
        },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              print("Remote user left: $remoteUid");
            },
      ),
    );

    await _engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.enableLocalAudio(true);

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
      ),
    );

    setState(() => _isEngineInitialized = true);
  }

  @override
  void dispose() {
    if (_isEngineInitialized) {
      _engine.leaveChannel();
      _engine.release();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionsGranted) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Waiting for permissions...",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Host camera fullscreen
          if (_isEngineInitialized)
            AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // Overlay buttons (mic toggle + end live)
          Positioned(
            right: 20,
            bottom: 50,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "mic",
                  backgroundColor: _micOn ? Colors.green : Colors.grey,
                  onPressed: () {
                    setState(() {
                      _micOn = !_micOn;
                      _engine.enableLocalAudio(_micOn);
                    });
                  },
                  child: Icon(_micOn ? Icons.mic : Icons.mic_off),
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  heroTag: "end",
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Comments placeholder
          Positioned(
            left: 20,
            bottom: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "User1: Nice live!",
                  style: TextStyle(color: Colors.white),
                ),
                Text("User2: 👏👏", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
