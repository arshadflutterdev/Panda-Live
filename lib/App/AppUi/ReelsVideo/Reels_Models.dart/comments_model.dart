import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String username;
  String comment;
  final createdAt;
  String profilePic;
  String uid;
  String id;

  CommentModel({
    required this.username,
    required this.comment,
    required this.createdAt,
    required this.profilePic,
    required this.uid,
    required this.id,
  });

  static CommentModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
      username: snapshot['username'],
      comment: snapshot['comment'],
      createdAt: snapshot['createdAt'],
      profilePic: snapshot['profilePic'],
      uid: snapshot['uid'],
      id: snapshot['id'],
    );
  }
}
