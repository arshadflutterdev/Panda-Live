// import 'dart:io';
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
//     // App chaltay hi videos fetch karna shuru kar dega
//     getAllVideos();
//   }

//   // --- GET ALL VIDEOS FROM FIREBASE ---
//   getAllVideos() async {
//     // bindStream se data khud-ba-khud update hota rahega jab bhi koi nayi video aayegi
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
//       // Jab video select ho jaye toh Confirm Screen par bhejein
//       Get.to(() => ConfirmUploadScreen(videoFile: File(video.path)));
//     }
//   }

//   // --- FIREBASE UPLOAD LOGIC ---
//   Future<void> uploadVideo(String caption, String videoPath) async {
//     try {
//       isLoading.value = true;

//       // Sahi waqt nikalne ke liye brackets () lagaye hain
//       String videoId = DateTime.now().millisecondsSinceEpoch.toString();

//       // 1. Storage mein video bhejhein
//       Reference ref = FirebaseStorage.instance
//           .ref()
//           .child('videos')
//           .child(videoId);

//       await ref.putFile(File(videoPath));
//       String downloadUrl = await ref.getDownloadURL();

//       // 2. Firestore mein entry karein
//       await FirebaseFirestore.instance.collection('videos').doc(videoId).set({
//         'username': 'Arshad Developer',
//         'uid': 'user_123',
//         'id': videoId,
//         'videoUrl': downloadUrl,
//         'caption': caption,
//         'songName': 'Original Audio',
//       });

//       Get.back(); // Confirm screen se wapis Reels par
//       Get.snackbar("Success", "Video Post Ho Gayi!");
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
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
import 'package:pandlive/App/AppUi/ReelsVideo/confirm_upload_screen.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/reels_model.dart';

class ReelsController extends GetxController {
  var videoList = <VideoModel>[].obs;
  var isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    getAllVideos();
  }

  getAllVideos() async {
    videoList.bindStream(
      _firestore.collection('videos').snapshots().map((query) {
        List<VideoModel> retVal = [];
        for (var element in query.docs) {
          retVal.add(VideoModel.fromSnap(element));
        }
        return retVal;
      }),
    );
  }

  Future<void> likeVideo(String id) async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot doc = await _firestore.collection('videos').doc(id).get();

    if ((doc.data() as dynamic)['likes'].contains(uid)) {
      await _firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await _firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Future<void> uploadVideo(String caption, String videoPath) async {
    try {
      isLoading.value = true;
      String uid = _auth.currentUser!.uid;

      // User profile se data lena
      DocumentSnapshot userDoc = await _firestore
          .collection('userProfile')
          .doc(uid)
          .get();
      String videoId = DateTime.now().millisecondsSinceEpoch.toString();

      Reference ref = FirebaseStorage.instance
          .ref()
          .child('videos')
          .child(videoId);
      await ref.putFile(File(videoPath));
      String downloadUrl = await ref.getDownloadURL();

      await _firestore.collection('videos').doc(videoId).set({
        'username': (userDoc.data() as dynamic)['name'] ?? 'Panda User',
        'uid': uid,
        'id': videoId,
        'videoUrl': downloadUrl,
        'caption': caption,
        'profilePic': (userDoc.data() as dynamic)['userimage'] ?? '',
        'songName': 'Original Audio',
        'likes': [],
      });

      Get.back();
      Get.snackbar("Success", "Video Post Ho Gayi!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      Get.to(() => ConfirmUploadScreen(videoFile: File(video.path)));
    }
  }
}
