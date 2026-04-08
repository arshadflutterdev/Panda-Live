// // import 'dart:io';
// // import 'package:get/get.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:pandlive/App/AppUi/ReelsVideo/confirm_upload_screen.dart';
// // import 'package:pandlive/App/AppUi/ReelsVideo/reels_model.dart';

// // class ReelsController extends GetxController {
// //   var videoList = <VideoModel>[].obs;
// //   var isForYou = true.obs;
// //   var isLoading = false.obs;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     // App chaltay hi videos fetch karna shuru kar dega
// //     getAllVideos();
// //   }

// //   // --- GET ALL VIDEOS FROM FIREBASE ---
// //   getAllVideos() async {
// //     // bindStream se data khud-ba-khud update hota rahega jab bhi koi nayi video aayegi
// //     videoList.bindStream(
// //       FirebaseFirestore.instance.collection('videos').snapshots().map((query) {
// //         List<VideoModel> retVal = [];
// //         for (var element in query.docs) {
// //           retVal.add(VideoModel.fromSnap(element));
// //         }
// //         return retVal;
// //       }),
// //     );
// //   }

// //   // --- VIDEO PICKING LOGIC ---
// //   Future<void> pickVideo() async {
// //     final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
// //     if (video != null) {
// //       // Jab video select ho jaye toh Confirm Screen par bhejein
// //       Get.to(() => ConfirmUploadScreen(videoFile: File(video.path)));
// //     }
// //   }

// //   // --- FIREBASE UPLOAD LOGIC ---
// //   Future<void> uploadVideo(String caption, String videoPath) async {
// //     try {
// //       isLoading.value = true;

// //       // Sahi waqt nikalne ke liye brackets () lagaye hain
// //       String videoId = DateTime.now().millisecondsSinceEpoch.toString();

// //       // 1. Storage mein video bhejhein
// //       Reference ref = FirebaseStorage.instance
// //           .ref()
// //           .child('videos')
// //           .child(videoId);

// //       await ref.putFile(File(videoPath));
// //       String downloadUrl = await ref.getDownloadURL();

// //       // 2. Firestore mein entry karein
// //       await FirebaseFirestore.instance.collection('videos').doc(videoId).set({
// //         'username': 'Arshad Developer',
// //         'uid': 'user_123',
// //         'id': videoId,
// //         'videoUrl': downloadUrl,
// //         'caption': caption,
// //         'songName': 'Original Audio',
// //       });

// //       Get.back(); // Confirm screen se wapis Reels par
// //       Get.snackbar("Success", "Video Post Ho Gayi!");
// //     } catch (e) {
// //       Get.snackbar("Error", e.toString());
// //       print("Upload Error: $e");
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// // }
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/confirm_upload_screen.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/reels_model.dart';

// class ReelsController extends GetxController {
//   var videoList = <VideoModel>[].obs;
//   var isForYou = true.obs;
//   var isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     getAllVideos();
//   }

//   // --- GET ALL VIDEOS FROM FIREBASE ---
//   getAllVideos() async {
//     videoList.bindStream(
//       FirebaseFirestore.instance.collection('videos').snapshots().map((query) {
//         List<VideoModel> retVal = [];
//         for (var element in query.docs) {
//           retVal.add(VideoModel.fromSnap(element));
//         }
//         return retVal;
//       }),
//     );
//   }

//   // --- VIDEO PICKING LOGIC ---
//   Future<void> pickVideo() async {
//     final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
//     if (video != null) {
//       Get.to(() => ConfirmUploadScreen(videoFile: File(video.path)));
//     }
//   }
// //here is controlelr for following
// // ReelsController.dart mein add karein

//   Future<void> followUser(String targetUid) async {
//     try {

//       String currentUid = FirebaseAuth.instance.currentUser!.uid;

//       // Khud ko follow nahi kar sakte
//       if (currentUid == targetUid) {
//         Get.snackbar("Opps", "Aap khud ko follow nahi kar sakte!");
//         return;
//       }

//       // 1. Apne 'following' collection mein target user ko add karein
//       await FirebaseFirestore.instance
//           .collection('userProfile')
//           .doc(currentUid)
//           .collection('following')
//           .doc(targetUid)
//           .set({});

//       // 2. Target user ke 'followers' collection mein apni entry karein
//       await FirebaseFirestore.instance
//           .collection('userProfile')
//           .doc(targetUid)
//           .collection('followers')
//           .doc(currentUid)
//           .set({});

//       Get.snackbar("Success", "Aapne follow kar liya!");
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
//   // --- FIREBASE UPLOAD LOGIC (DYNAMIC FIX) ---
//   Future<void> uploadVideo(String caption, String videoPath) async {
//     try {
//       isLoading.value = true;
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       String videoId = DateTime.now().millisecondsSinceEpoch.toString();

//       // 1. Pehle Storage mein video upload karein
//       Reference ref = FirebaseStorage.instance
//           .ref()
//           .child('videos')
//           .child(videoId);

//       await ref.putFile(File(videoPath));
//       String downloadUrl = await ref.getDownloadURL();

//       // 2. User ki Profile fetch karein (Real Name aur Image ke liye)
//       var userDoc = await FirebaseFirestore.instance
//           .collection('userProfile')
//           .doc(uid)
//           .get();

//       // Database fields check (Screenshot ke mutabiq)
//       String realName =
//           userDoc.data() != null && userDoc.data()!.containsKey('name')
//           ? userDoc['name']
//           : "User";
//       String realImage =
//           userDoc.data() != null && userDoc.data()!.containsKey('userimage')
//           ? userDoc['userimage']
//           : "";

//       // 3. Videos collection mein dynamic data save karein
//       await FirebaseFirestore.instance.collection('videos').doc(videoId).set({
//         'uid': uid,
//         'id': videoId,
//         'username': realName, // Ab "Arshad" save hoga
//         'profilePic': realImage, // Profile image ka link save hoga
//         'videoUrl': downloadUrl, // Storage wala actual URL
//         'caption': caption,
//         'songName': 'Original Audio',
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       Get.back(); // Confirm screen se wapis
//       Get.snackbar("Mubarak!", "Video kamyabi se post ho gayi.");
//     } catch (e) {
//       Get.snackbar("Error", "Upload nahi ho saki: $e");
//       print("Upload Error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
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
  // Future<void> followUser(String targetUid) async {
  //   try {
  //     String currentUid = FirebaseAuth.instance.currentUser!.uid;

  //     // Khud ko follow nahi kar sakte
  //     if (currentUid == targetUid) {
  //       Get.snackbar("Opps", "Aap khud ko follow nahi kar sakte!");
  //       return;
  //     }

  //     // 1. Apne 'following' collection mein entry
  //     await FirebaseFirestore.instance
  //         .collection('userProfile')
  //         .doc(currentUid)
  //         .collection('following')
  //         .doc(targetUid)
  //         .set({});

  //     // 2. Target user ke 'followers' collection mein entry
  //     await FirebaseFirestore.instance
  //         .collection('userProfile')
  //         .doc(targetUid)
  //         .collection('followers')
  //         .doc(currentUid)
  //         .set({});

  //     Get.snackbar("Success", "Aapne follow kar liya!");
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   }
  // }
  // function related like/unlike video
  // --- LIKE/UNLIKE LOGIC ---
  //replay a comment
  // 1. Reply Save karne ke liye
  // Future<void> postReply(
  //   String videoId,
  //   String commentId,
  //   String replyText,
  // ) async {
  //   try {
  //     if (replyText.trim().isNotEmpty) {
  //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //           .collection('userProfile')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .get();

  //       var userData = userDoc.data() as Map<String, dynamic>;

  //       await FirebaseFirestore.instance
  //           .collection('videos')
  //           .doc(videoId)
  //           .collection('comments')
  //           .doc(commentId)
  //           .collection('replies')
  //           .add({
  //             'username': userData['name'],
  //             'profilePic': userData['userimage'],
  //             'reply': replyText.trim(),
  //             'createdAt': FieldValue.serverTimestamp(),
  //             'uid': FirebaseAuth.instance.currentUser!.uid,
  //           });
  //       print("Reply Posted!");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   }
  // }

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

  //views system
  updateVideoViews(String videoId) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .get();

      if ((doc.data() as dynamic)['views'].contains(uid)) {
        // Agar user ne pehle se dekha hua hai, toh kuch nahi karna
        return;
      } else {
        // Agar naya user hai, toh uski ID add kardo
        await FirebaseFirestore.instance
            .collection('videos')
            .doc(videoId)
            .update({
              'views': FieldValue.arrayUnion([uid]),
            });
      }
    } catch (e) {
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
  // Post Comment aur Reply dono ke liye ek hi logic
  // Future<void> postComment(String videoId, String commentText) async {
  //   try {
  //     if (commentText.trim().isNotEmpty) {
  //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //           .collection('userProfile')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .get();

  //       var userData = userDoc.data() as Map<String, dynamic>;

  //       // AGAR REPLIES HAI (selectedCommentId khali nahi hai)
  //       if (selectedCommentId.value.isNotEmpty) {
  //         await FirebaseFirestore.instance
  //             .collection('videos')
  //             .doc(videoId)
  //             .collection('comments')
  //             .doc(selectedCommentId.value)
  //             .collection('replies')
  //             .add({
  //               'username': userData['name'], //
  //               'profilePic': userData['userimage'], //
  //               'reply': commentText.trim(),
  //               'createdAt': FieldValue.serverTimestamp(),
  //               'uid': FirebaseAuth.instance.currentUser!.uid,
  //             });

  //         // Reset after reply
  //         selectedCommentId.value = "";
  //         replyingToUser.value = "";
  //       }
  //       // AGAR NORMAL COMMENT HAI
  //       else {
  //         String commentId = "Comment_${DateTime.now().millisecondsSinceEpoch}";
  //         await FirebaseFirestore.instance
  //             .collection('videos')
  //             .doc(videoId)
  //             .collection('comments')
  //             .doc(commentId)
  //             .set({
  //               'username': userData['name'],
  //               'comment': commentText.trim(),
  //               'createdAt': FieldValue.serverTimestamp(),
  //               'profilePic': userData['userimage'],
  //               'uid': FirebaseAuth.instance.currentUser!.uid,
  //               'id': commentId,
  //               'likes': [],
  //             });
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   }
  // }

  // Future<void> postComment(String videoId, String commentText) async {
  //   try {
  //     if (commentText.trim().isNotEmpty) {
  //       // 1. Current User ka data 'userProfile' collection se fetch karein
  //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //           .collection('userProfile') // Aapke Firebase ke mutabiq
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .get();

  //       if (!userDoc.exists) {
  //         Get.snackbar(
  //           "Error",
  //           "User profile not found. Please complete your profile setup.",
  //         );
  //         return;
  //       }

  //       // 2. Data extract karein
  //       var userData = userDoc.data() as Map<String, dynamic>;

  //       // Counting comments
  //       var allDocs = await FirebaseFirestore.instance
  //           .collection('videos')
  //           .doc(videoId)
  //           .collection('comments')
  //           .get();

  //       int len = allDocs.docs.length;
  //       String commentId =
  //           "Comment_${DateTime.now().millisecondsSinceEpoch}"; // Unique ID logic

  //       // 3. Comment save karein
  //       // postComment function ke andar 'set' wala hissa:
  //       await FirebaseFirestore.instance
  //           .collection('videos')
  //           .doc(videoId)
  //           .collection('comments')
  //           .doc(commentId)
  //           .set({
  //             'username': userData['name'],
  //             'comment': commentText.trim(),
  //             'createdAt': FieldValue.serverTimestamp(),
  //             'profilePic': userData['userimage'],
  //             'uid': FirebaseAuth.instance.currentUser!.uid,
  //             'id': commentId,
  //             'likes': [], // <--- Naye comment ke liye khali list lazmi hai
  //           });

  //       print("Comment Posted: ${commentText.trim()}");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Post failed: ${e.toString()}");
  //     print("Post Comment Error: $e");
  //   }
  // }

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
      });

      Get.back();
      Get.snackbar("Mubarak!", "Video kamyabi se post ho gayi.");
    } catch (e) {
      Get.snackbar("Error", "Upload fail: $e");
    } finally {
      isLoading.value = false;
    }
  }
  // Future<void> uploadVideo(String caption, String videoPath) async {
  //   try {
  //     isLoading.value = true;
  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //     String videoId = DateTime.now().millisecondsSinceEpoch.toString();

  //     // 1. Storage mein upload
  //     Reference ref = FirebaseStorage.instance
  //         .ref()
  //         .child('videos')
  //         .child(videoId);

  //     await ref.putFile(File(videoPath));
  //     String downloadUrl = await ref.getDownloadURL();

  //     // 2. User Profile Fetch
  //     var userDoc = await FirebaseFirestore.instance
  //         .collection('userProfile')
  //         .doc(uid)
  //         .get();

  //     String realName =
  //         userDoc.data() != null && userDoc.data()!.containsKey('name')
  //         ? userDoc['name']
  //         : "User";
  //     String realImage =
  //         userDoc.data() != null && userDoc.data()!.containsKey('userimage')
  //         ? userDoc['userimage']
  //         : "";

  //     // 3. Save to Firestore
  //     await FirebaseFirestore.instance.collection('videos').doc(videoId).set({
  //       'uid': uid,
  //       'id': videoId,
  //       'username': realName,
  //       'profilePic': realImage,
  //       'videoUrl': downloadUrl,
  //       'caption': caption,
  //       'songName': 'Original Audio',
  //       'createdAt': FieldValue.serverTimestamp(),
  //     });

  //     Get.back();
  //     Get.snackbar("Mubarak!", "Video kamyabi se post ho gayi.");
  //   } catch (e) {
  //     Get.snackbar("Error", "Upload fail: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
