import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/comments_model.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/confirm_upload_screen.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';

class ReelsController extends GetxController {
  var videoList = <VideoModel>[].obs;
  var isForYou = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllVideos();
  }

  // --- GET ALL VIDEOS FROM FIREBASE ---
  getAllVideos() async {
    videoList.bindStream(
      FirebaseFirestore.instance.collection('videos').snapshots().map((query) {
        List<VideoModel> retVal = [];
        for (var element in query.docs) {
          retVal.add(VideoModel.fromSnap(element));
        }
        return retVal;
      }),
    );
  }

  // Comments ki list store karne ke liye
  RxList<CommentModel> comments = <CommentModel>[].obs;
  getComments(String videoId) {
    // Nayi stream start karne se pehle purani list saaf karein
    comments.clear();

    comments.bindStream(
      FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((QuerySnapshot query) {
            List<CommentModel> retVal = [];
            for (var element in query.docs) {
              retVal.add(CommentModel.fromSnap(element));
            }
            return retVal;
          }),
    );
  }

  // --- VIDEO PICKING LOGIC ---
  Future<void> pickVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      Get.to(() => ConfirmUploadScreen(videoFile: File(video.path)));
    }
  }

  // --- FOLLOW CHECKER (STREAM) ---
  // Ye function alag hona chahiye taake UI isay use kar sakay
  Stream<bool> isFollowing(String targetUid) {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('userProfile')
        .doc(currentUid)
        .collection('following')
        .doc(targetUid)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  // --- FOLLOW USER LOGIC ---
  // --- FOLLOW USER LOGIC ---
  Future<void> followUser(String targetUid) async {
    try {
      String currentUid = FirebaseAuth.instance.currentUser!.uid;

      // SAFETY CHECK: Khud ko follow nahi kar sakte
      if (currentUid == targetUid) {
        Get.snackbar("Opps", "Aap khud ko follow nahi kar sakte!");
        return;
      }

      // 1. Apni Profile se apna data uthaein
      var myProfile = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(currentUid)
          .get();

      // 2. Target user ka data uthaein
      var targetProfile = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(targetUid)
          .get();

      // 3. Apne 'following' mein target ka data save karein
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(currentUid)
          .collection('following')
          .doc(targetUid)
          .set({
            'name': targetProfile.data()?.containsKey('name') == true
                ? targetProfile['name']
                : "User",
            'profilePic': targetProfile.data()?.containsKey('userimage') == true
                ? targetProfile['userimage']
                : "",
            'uid': targetUid,
          });

      // 4. Target user ke 'followers' mein apna data save karein
      await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(targetUid)
          .collection('followers')
          .doc(currentUid)
          .set({
            'name': myProfile.data()?.containsKey('name') == true
                ? myProfile['name']
                : "User",
            'profilePic': myProfile.data()?.containsKey('userimage') == true
                ? myProfile['userimage']
                : "",
            'uid': currentUid,
          });

      Get.snackbar(
        "Success",
        "Ab aap ${targetProfile['name']} ko follow kar rahe hain!",
      );
    } catch (e) {
      Get.snackbar("Error", "Follow process fail: $e");
    }
  }

  // 2. Replies Fetch karne ke liye (Stream)
  Stream<QuerySnapshot> getReplies(String videoId, String commentId) {
    return FirebaseFirestore.instance
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  // Comment ko like/unlike karne ke liye
  Future<void> likeComment(String videoId, String commentId) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Comment ka document uthao
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId)
          .get();

      if (doc.exists) {
        List likes = (doc.data() as dynamic)['likes'] ?? [];

        if (likes.contains(uid)) {
          // Unlike logic
          await FirebaseFirestore.instance
              .collection('videos')
              .doc(videoId)
              .collection('comments')
              .doc(commentId)
              .update({
                'likes': FieldValue.arrayRemove([uid]),
              });
        } else {
          // Like logic
          await FirebaseFirestore.instance
              .collection('videos')
              .doc(videoId)
              .collection('comments')
              .doc(commentId)
              .update({
                'likes': FieldValue.arrayUnion([uid]),
              });
        }
      }
    } catch (e) {
      print("Error liking comment: $e");
    }
  }

  // Reply post karne ke liye
  Future<void> postReply(
    String videoId,
    String commentId,
    String replyText,
  ) async {
    try {
      if (replyText.isNotEmpty) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('userProfile')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        var userData = userDoc.data() as Map<String, dynamic>;

        await FirebaseFirestore.instance
            .collection('videos')
            .doc(videoId)
            .collection('comments')
            .doc(commentId)
            .collection('replies')
            .add({
              'username': userData['name'] ?? 'User',
              'profilePic': userData['userimage'] ?? '',
              'reply': replyText.trim(),
              'createdAt': FieldValue.serverTimestamp(),
              'uid': FirebaseAuth.instance.currentUser!.uid,
              'likes': [], // Ye add karna zaroori hai!
            });
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Video ke total comments count karne ke liye logic
  int getTotalComments(
    AsyncSnapshot<QuerySnapshot> commentSnap,
    List<int> allRepliesCounts,
  ) {
    int mainComments = commentSnap.data?.docs.length ?? 0;
    int totalReplies = allRepliesCounts.fold(0, (sum, next) => sum + next);
    return mainComments + totalReplies;
  }

  //comment reply like
  Future<void> likeReply(
    String videoId,
    String commentId,
    String replyId,
  ) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference replyRef = FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .doc(replyId);

      DocumentSnapshot doc = await replyRef.get();
      if (doc.exists) {
        List likes = (doc.data() as dynamic)['likes'] ?? [];
        if (likes.contains(uid)) {
          await replyRef.update({
            'likes': FieldValue.arrayRemove([uid]),
          });
        } else {
          await replyRef.update({
            'likes': FieldValue.arrayUnion([uid]),
          });
        }
      }
    } catch (e) {
      print("Error liking reply: $e");
    }
  }

  //comment like upper
  Future<void> likeVideo(String id) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('videos')
          .doc(id)
          .get();

      var likesList = (doc.data() as dynamic)['likes'] as List;

      if (likesList.contains(uid)) {
        // 1. Database Update (Unlike)
        await FirebaseFirestore.instance.collection('videos').doc(id).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        // 2. Database Update (Like)
        await FirebaseFirestore.instance.collection('videos').doc(id).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }

      // --- GETX REFRESH LOGIC ---
      // Ye line GetX ko batati hai ke list change hui hai,
      // taake UI mein Obx wala error khatam ho jaye aur heart color change ho.
      videoList.refresh();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  //vidoe ko favourite kreyn
  // --- FAVORITE / SAVE VIDEO LOGIC ---
  Future<void> toggleFavorite(
    String videoId,
    Map<String, dynamic> videoData,
  ) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference favRef = FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .collection('favorites')
          .doc(videoId);

      DocumentSnapshot favDoc = await favRef.get();

      if (favDoc.exists) {
        // Agar pehle se save hai toh remove kar do
        await favRef.delete();
        Get.snackbar("Removed", "Video favorites se hata di gayi");
      } else {
        // Agar save nahi hai toh poora video data save kar lo (taake baad mein dikhane mein asani ho)
        await favRef.set({
          'id': videoId,
          'videoUrl': videoData['videoUrl'],
          'thumbnail':
              videoData['profilePic'], // Ya agar aapne thumbnail banaya hai
          'username': videoData['username'],
          'caption': videoData['caption'],
          'createdAt': FieldValue.serverTimestamp(),
        });
        Get.snackbar("Saved", "Video favorites mein add ho gayi!");
      }
    } catch (e) {
      Get.snackbar("Error", "Favorite process fail: $e");
    }
  }

  // Favourite check karne ke liye Stream (taake icon ka color change ho sakay)
  Stream<bool> isFavorite(String videoId) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('userProfile')
        .doc(uid)
        .collection('favorites')
        .doc(videoId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  updateVideoViews(String videoId) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference videoRef = FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId);

      DocumentSnapshot doc = await videoRef.get();

      if (doc.exists) {
        // Safe way to get views list
        var data = doc.data() as Map<String, dynamic>;
        List views = data.containsKey('views') ? data['views'] : [];

        if (!views.contains(uid)) {
          // Agar user ID nahi hai, toh add karein
          await videoRef.update({
            'views': FieldValue.arrayUnion([uid]),
          });
          print("View added for video: $videoId");
        }
      }
    } catch (e) {
      // Agar koi error aaye toh yahan print hoga crash nahi hoga
      print("Views error: $e");
    }
  }

  // Comment post karne ka function
  // Controller ke top par ye variables add karein
  var selectedCommentId = "".obs;
  var replyingToUser = "".obs;
  Future<void> postComment(String videoId, String commentText) async {
    try {
      if (commentText.trim().isNotEmpty) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('userProfile')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        var userData = userDoc.data() as Map<String, dynamic>;
        DocumentReference videoRef = FirebaseFirestore.instance
            .collection('videos')
            .doc(videoId);

        // --- CASE 1: AGAR AAP REPLY KAR RAHE HAIN ---
        if (selectedCommentId.value.isNotEmpty) {
          await videoRef
              .collection('comments')
              .doc(selectedCommentId.value)
              .collection('replies')
              .add({
                'username': userData['name'] ?? 'User',
                'profilePic': userData['userimage'] ?? '',
                'reply': commentText.trim(),
                'createdAt': FieldValue.serverTimestamp(),
                'uid': FirebaseAuth.instance.currentUser!.uid,
                'likes': [],
              });

          // Reply ke baad bhi total count barhayein
          await videoRef.update({'commentCount': FieldValue.increment(1)});

          // State reset karein
          selectedCommentId.value = "";
          replyingToUser.value = "";
        }
        // --- CASE 2: AGAR AAP NORMAL COMMENT KAR RAHE HAIN ---
        else {
          String commentId = "Comment_${DateTime.now().millisecondsSinceEpoch}";
          await videoRef.collection('comments').doc(commentId).set({
            'username': userData['name'] ?? 'User',
            'comment': commentText.trim(),
            'createdAt': FieldValue.serverTimestamp(),
            'profilePic': userData['userimage'] ?? '',
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'id': commentId,
            'likes': [],
          });

          // Main comment ke baad count barhayein
          await videoRef.update({'commentCount': FieldValue.increment(1)});
        }

        // GetX ko force refresh karein taake UI update ho jaye
        videoList.refresh();
      }
    } catch (e) {
      print("Comment Error: $e");
      Get.snackbar("Error", "Count update nahi ho saka");
    }
  }

  // --- FIREBASE UPLOAD LOGIC ---
  // --- FIREBASE UPLOAD LOGIC ---
  Future<void> uploadVideo(String caption, String videoPath) async {
    try {
      isLoading.value = true;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String videoId = DateTime.now().millisecondsSinceEpoch.toString();

      // 1. Storage mein upload
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('videos')
          .child(videoId);

      await ref.putFile(File(videoPath));
      String downloadUrl = await ref.getDownloadURL();

      // 2. User Profile Fetch
      var userDoc = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .get();

      String realName = userDoc.data()?.containsKey('name') == true
          ? userDoc['name']
          : "User";
      String realImage = userDoc.data()?.containsKey('userimage') == true
          ? userDoc['userimage']
          : "";

      // 3. Save to Firestore (IMPORTANT: Added 'likes' field)
      await FirebaseFirestore.instance.collection('videos').doc(videoId).set({
        'uid': uid,
        'id': videoId,
        'username': realName,
        'profilePic': realImage,
        'videoUrl': downloadUrl,
        'caption': caption,
        'songName': 'Original Audio',
        'createdAt': FieldValue.serverTimestamp(),
        'likes': [], // <--- YE LINE ADD KARNA ZAROORI HAI
        'views': [], // <--- YE LINE ADD KAREIN
      });

      Get.back();
      Get.snackbar("Mubarak!", "Video kamyabi se post ho gayi.");
    } catch (e) {
      Get.snackbar("Error", "Upload fail: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
