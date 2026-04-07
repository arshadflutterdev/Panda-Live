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
    comments.bindStream(
      FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .collection('comments')
          .orderBy('createdAt', descending: true) // Latest comments top par
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

  // Comment post karne ka function
  postComment(String videoId, String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        var allDocs = await FirebaseFirestore.instance
            .collection('videos')
            .doc(videoId)
            .collection('comments')
            .get();

        int len = allDocs.docs.length;

        CommentModel comment = CommentModel(
          username: (userDoc.data() as dynamic)['name'],
          comment: commentText.trim(),
          createdAt: DateTime.now(),
          profilePic: (userDoc.data() as dynamic)['profilePic'] ?? '',
          uid: FirebaseAuth.instance.currentUser!.uid,
          id: "Comment $len",
        );

        await FirebaseFirestore.instance
            .collection('videos')
            .doc(videoId)
            .collection('comments')
            .doc("Comment $len")
            .set({
              'username': comment.username,
              'comment': comment.comment,
              'createdAt': comment.createdAt,
              'profilePic': comment.profilePic,
              'uid': comment.uid,
              'id': comment.id,
            });
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
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
