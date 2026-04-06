// class VideoModel {
//   String username;
//   String uid;
//   String id;
//   String videoUrl;
//   String caption;
//   String songName;

//   VideoModel({
//     required this.username,
//     required this.uid,
//     required this.id,
//     required this.videoUrl,
//     required this.caption,
//     required this.songName,
//   });

//   // Firebase se data map karne ke liye
//   static VideoModel fromSnap(var snap) {
//     var data = snap.data();
//     return VideoModel(
//       username: data['username'],
//       uid: data['uid'],
//       id: data['id'],
//       videoUrl: data['videoUrl'],
//       caption: data['caption'],
//       songName: data['songName'],
//     );
//   }
// }
class VideoModel {
  final String username;
  final String uid;
  final String id;
  final String videoUrl;
  final String caption;
  final String profilePic; // Image link ke liye

  VideoModel({
    required this.username,
    required this.uid,
    required this.id,
    required this.videoUrl,
    required this.caption,
    required this.profilePic,
  });

  static VideoModel fromSnap(var snap) {
    var data = snap.data();
    return VideoModel(
      username: data['username'] ?? '',
      uid: data['uid'] ?? '',
      id: data['id'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      caption: data['caption'] ?? '',
      // FIX: Firebase field 'userimage' se link connect karein
      profilePic: data['userimage'] ?? '',
    );
  }
}
