// import 'package:cloud_firestore/cloud_firestore.dart';

// class CommentModel {
//   String username;
//   String comment;
//   final createdAt;
//   String profilePic;
//   String uid;
//   String id;

//   CommentModel({
//     required this.username,
//     required this.comment,
//     required this.createdAt,
//     required this.profilePic,
//     required this.uid,
//     required this.id,
//   });

//   static CommentModel fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;
//     return CommentModel(
//       username: snapshot['username'],
//       comment: snapshot['comment'],
//       createdAt: snapshot['createdAt'],
//       profilePic: snapshot['profilePic'],
//       uid: snapshot['uid'],
//       id: snapshot['id'],
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String username;
  String comment;
  final createdAt;
  String profilePic;
  String uid;
  String id;
  List likes; // <--- Ye line add karni hai

  CommentModel({
    required this.username,
    required this.comment,
    required this.createdAt,
    required this.profilePic,
    required this.uid,
    required this.id,
    required this.likes, // <--- Constructor mein bhi add karein
  });

  static CommentModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
      username: snapshot['username'] ?? 'User',
      comment: snapshot['comment'] ?? '',
      createdAt: snapshot['createdAt'],
      profilePic: snapshot['profilePic'] ?? '',
      uid: snapshot['uid'] ?? '',
      id: snapshot['id'] ?? '',
      likes: snapshot['likes'] ?? [], // <--- Default khali list [] de dein
    );
  }
}
