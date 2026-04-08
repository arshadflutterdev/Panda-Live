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
  String username;
  String uid;
  String id;
  String videoUrl;
  String caption;
  String songName;
  String profilePic; // Image link ke liye ye zaroori hai
  List likes;
  int commentCount; // <--- Ye field lazmi add karein

  VideoModel({
    required this.username,
    required this.uid,
    required this.id,
    required this.videoUrl,
    required this.caption,
    required this.songName,
    required this.profilePic,
    required this.likes, // <--- Constructor mein add karein
    required this.commentCount, // <--- Constructor mein shamil karein
  });

  // Firebase se data map karne ke liye
  static VideoModel fromSnap(var snap) {
    var data = snap.data();
    return VideoModel(
      username: data['username'] ?? '',
      uid: data['uid'] ?? '',
      id: data['id'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      caption: data['caption'] ?? '',
      songName: data['songName'] ?? 'Original Audio',
      profilePic:
          data['profilePic'] ?? '', // Upload logic ke mutabiq profilePic field
      likes: data['likes'] ?? [], // <--- Database se array uthane ke liye
      commentCount:
          data['commentCount'] ?? 0, // <--- Firebase se count uthane ke liye
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "id": id,
    "videoUrl": videoUrl,
    "caption": caption,
    "songName": songName,
    "profilePic": profilePic,
    "likes": likes,
    "commentCount": commentCount, // <--- Upload ke waqt 0 jayega starting mein
  };
}
