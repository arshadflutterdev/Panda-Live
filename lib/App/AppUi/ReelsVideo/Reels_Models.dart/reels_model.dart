import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String username;
  String uid;
  String id;
  String videoUrl;
  String caption;
  String songName;
  String profilePic;
  String thumbnail; // Video cover image
  List likes;
  int commentCount;
  List views;
  final bool isPrivate; // 1. Ye line add karein
  List<dynamic>? filterMatrix;
  final String overlayText;

  VideoModel({
    required this.username,
    required this.uid,
    required this.id,
    required this.videoUrl,
    required this.caption,
    required this.songName,
    required this.profilePic,
    required this.thumbnail,
    required this.likes,
    required this.commentCount,
    required this.views,
    required this.isPrivate,
    this.filterMatrix,
    this.overlayText = '',
  });

  // Firebase se data map karne ke liye (DocumentSnapshot use karna behtar hai)
  static VideoModel fromSnap(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>;

    return VideoModel(
      username: data['username'] ?? '',
      uid: data['uid'] ?? '',
      id: data['id'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      caption: data['caption'] ?? '',
      songName: data['songName'] ?? 'Original Audio',
      profilePic: data['profilePic'] ?? '',
      thumbnail: data['thumbnail'] ?? '', // <--- Ab ye fetch karega
      likes: data['likes'] ?? [],
      commentCount: data['commentCount'] ?? 0,
      views: data['views'] ?? [],
      isPrivate: data['isPrivate'] ?? false,
      filterMatrix: data['filterMatrix'],
      overlayText: data['overlayText'] ?? '',
    );
  }

  // Firebase mein data save karne ke liye
  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "id": id,
    "videoUrl": videoUrl,
    "caption": caption,
    "songName": songName,
    "profilePic": profilePic,
    "thumbnail": thumbnail, // Fixed: direct access
    "likes": likes,
    "commentCount": commentCount,
    "views": views,
    "isPrivate": isPrivate, // 3. JSON mein add karein
    "filterMatrix": filterMatrix,
  };
}
