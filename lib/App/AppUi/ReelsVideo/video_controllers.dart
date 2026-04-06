import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String videoUrl;
  String username;
  String id;
  // Baaki fields: likes, comments etc.

  VideoModel({
    required this.videoUrl,
    required this.username,
    required this.id,
  });

  static VideoModel fromSnap(var snap) {
    var data = snap.data();
    return VideoModel(
      videoUrl: data['videoUrl'],
      username: data['username'],
      id: data['id'],
    );
  }
}

class ReelsController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var videoList = <VideoModel>[].obs; // Apni Video Model class banani hogi

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  // Firebase se videos lane ka function
  void fetchVideos() async {
    var snapshot = await _db.collection('reels').get();
    videoList.value = snapshot.docs
        .map((doc) => VideoModel.fromSnap(doc))
        .toList();
  }
}
