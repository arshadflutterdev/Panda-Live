import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/comments_model.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/confirm_upload_screen.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:video_compress_plus/video_compress_plus.dart';

class ReelsController extends GetxController {
  var videoList = <VideoModel>[].obs;
  var isForYou = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllVideos();
  }

  getAllVideos() async {
    videoList.bindStream(
      FirebaseFirestore.instance
          .collection('videos')
          .where('isPrivate', isEqualTo: false) // Sirf public videos
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((query) {
            List<VideoModel> retVal = [];
            for (var element in query.docs) {
              try {
                retVal.add(VideoModel.fromSnap(element));
              } catch (e) {
                print(
                  "Video mapping error: $e",
                ); // Kisi video mein data missing ho toh crash na ho
              }
            }
            return retVal;
          }),
    );
  }

  getFollowingVideos() async {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;

    // Pehle check karein ke hum kin logo ko follow kar rahe hain
    var followingSnapshot = await FirebaseFirestore.instance
        .collection('userProfile')
        .doc(currentUid)
        .collection('following')
        .get();

    List<String> followingUids = followingSnapshot.docs
        .map((doc) => doc.id)
        .toList();

    if (followingUids.isEmpty) {
      videoList.value = []; // Agar kisi ko follow nahi kiya toh list empty
      return;
    }
    videoList.bindStream(
      FirebaseFirestore.instance
          .collection('videos')
          .where('uid', whereIn: followingUids) // <--- Main Logic
          .snapshots()
          .map((query) {
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

  // video_controllers.dart mein ye variables add karein
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;
  CancelToken? downloadCancelToken;

  Future<void> downloadVideo(String videoUrl, String videoId) async {
    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;
      downloadCancelToken = CancelToken();

      final tempDir = await getTemporaryDirectory();
      final path = "${tempDir.path}/$videoId.mp4";

      await Dio().download(
        videoUrl,
        path,
        cancelToken: downloadCancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
          }
        },
      );

      final result = await SaverGallery.saveFile(
        filePath: path,
        fileName: videoId,
        skipIfExists: false,
      );

      isDownloading.value = false;
      if (result.isSuccess) {
        Get.snackbar(
          "Success",
          "Saved to Gallery",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isDownloading.value = false;
      if (!CancelToken.isCancel(e as DioException)) {
        Get.snackbar("Error", "Download failed");
      }
    }
  }

  void cancelDownload() {
    downloadCancelToken?.cancel("Cancelled by user");
    isDownloading.value = false;
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
      DocumentReference videoRef = FirebaseFirestore.instance
          .collection('videos')
          .doc(id);
      DocumentSnapshot doc = await videoRef.get();
      var likesList = (doc.data() as dynamic)['likes'] as List;

      if (likesList.contains(uid)) {
        // Unlike logic
        await videoRef.update({
          'likes': FieldValue.arrayRemove([uid]),
        });

        // --- YEHA ADD KAREIN ---
        // Agar hum 'Liked Videos' wali screen par hain aur ye aakhri video thi jo unlike hui
        // To 500ms baad check karein aur screen close kar den
        Future.delayed(const Duration(milliseconds: 500), () {
          if (Get.currentRoute.contains('VideoDetailScreen') &&
              !videoList.any((v) => v.id == id)) {
            // Agar video ab list mein nahi rahi (unlike hone ki wajah se refresh hui)
            // Aur list bilkul khali ho gayi hai, to wapas bhej dein
            if (videoList.isEmpty) {
              Get.back();
            }
          }
        });
      } else {
        // Like logic
        await videoRef.update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }

      videoList.refresh();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // --- FAVORITE / SAVE VIDEO LOGIC ---
  // 1. Toggle Favorite: Data save karne aur delete karne ke liye
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
        await favRef.delete();
        Get.snackbar("Removed", "Saved list se hata di gayi.");
      } else {
        // IMPORTANT: 'id' field add karna lazmi hai count ke liye
        Map<String, dynamic> dataToSave = Map.from(videoData);
        dataToSave['id'] = videoId;

        await favRef.set(dataToSave);
        Get.snackbar("Saved", "Profile mein save ho gayi!");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // 2. Icon Color Check: Kya current user ne save kiya hai?
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

  // 3. Total Count: Poore app mein kitne saves hain?
  Stream<int> getTotalSaveCount(String videoId) {
    return FirebaseFirestore.instance
        .collectionGroup('favorites')
        .where('id', isEqualTo: videoId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
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
  // Controller ke top par ye variable lazmi add karein

  // --- Video Compression Logic ---
  Future<File?> _compressVideo(String videoPath) async {
    try {
      final info = await VideoCompress.compressVideo(
        videoPath,
        quality: VideoQuality.MediumQuality, // TikTok style medium quality
        deleteOrigin: false,
      );
      return info?.file;
    } catch (e) {
      print("Compression Error: $e");
      return null;
    }
  }

  // --- Thumbnail Generation Logic ---
  Future<File> _getThumbnail(String videoPath) async {
    final thumbnailFile = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnailFile;
  }

  var uploadProgress = 0.0.obs;
  Future<void> uploadVideo(String caption, String videoPath) async {
    // 1. Foran Confirm Screen band kar do taaki banda pichli screen (Home/TikTok) par chala jaye
    Get.back();

    // 2. Aik Snackbar ya chota sa notification dikha do ke "Uploading started..."
    Get.snackbar(
      "Uploading...",
      "Aapki video background mein post ho rahi hai",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black.withOpacity(0.7),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    try {
      isLoading.value = true;
      uploadProgress.value = 0.0;

      // --- Compression & Thumbnail (Background mein chalta rahega) ---
      File? compressedVideo = await _compressVideo(videoPath);
      if (compressedVideo == null) return;

      File thumbnailFile = await _getThumbnail(videoPath);

      // --- Storage Upload ---
      String videoId = DateTime.now().millisecondsSinceEpoch.toString();

      // Thumbnail upload
      Reference thumbRef = FirebaseStorage.instance
          .ref()
          .child('thumbnails')
          .child(videoId);
      await thumbRef.putFile(thumbnailFile);
      String thumbUrl = await thumbRef.getDownloadURL();

      // Video upload with progress
      Reference videoRef = FirebaseStorage.instance
          .ref()
          .child('videos')
          .child(videoId);
      UploadTask uploadTask = videoRef.putFile(compressedVideo);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        uploadProgress.value =
            (snapshot.bytesTransferred / snapshot.totalBytes);
        // Yahan aap chaho to notification bar mein progress dikha sakte ho
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // --- Firestore Save ---
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var userDoc = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(uid)
          .get();

      await FirebaseFirestore.instance.collection('videos').doc(videoId).set({
        'uid': uid,
        'id': videoId,
        'videoUrl': downloadUrl,
        'thumbnail': thumbUrl,
        'caption': caption,
        'username': userDoc.data()?['name'] ?? "User",
        'profilePic': userDoc.data()?['userimage'] ?? "",
        'createdAt': FieldValue.serverTimestamp(),
        'isPrivate': false,
      });

      // Cleanup
      await VideoCompress.deleteAllCache();

      // Final Success Message
      Get.snackbar(
        "Success",
        "Video Post Ho Gayi!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Upload fail ho gaya");
    } finally {
      isLoading.value = false;
    }
  }
  // Future<void> uploadVideo(String caption, String videoPath) async {
  //   try {
  //     isLoading.value = true;
  //     uploadProgress.value = 0.0;

  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //     String videoId = DateTime.now().millisecondsSinceEpoch.toString();

  //     // --- STEP A: COMPRESS VIDEO FIRST ---
  //     File? compressedVideo = await _compressVideo(videoPath);
  //     if (compressedVideo == null) return;

  //     // --- STEP B: GENERATE THUMBNAIL ---
  //     File thumbnailFile = await _getThumbnail(videoPath);

  //     // --- STEP C: UPLOAD THUMBNAIL TO STORAGE ---
  //     Reference thumbRef = FirebaseStorage.instance
  //         .ref()
  //         .child('thumbnails')
  //         .child(videoId);
  //     await thumbRef.putFile(thumbnailFile);
  //     String thumbUrl = await thumbRef.getDownloadURL();

  //     // --- STEP D: UPLOAD COMPRESSED VIDEO WITH PROGRESS ---
  //     Reference videoRef = FirebaseStorage.instance
  //         .ref()
  //         .child('videos')
  //         .child(videoId);
  //     UploadTask uploadTask = videoRef.putFile(compressedVideo);

  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
  //       uploadProgress.value = progress;
  //     });

  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     String downloadUrl = await taskSnapshot.ref.getDownloadURL();

  //     // 2. User Profile Fetch
  //     var userDoc = await FirebaseFirestore.instance
  //         .collection('userProfile')
  //         .doc(uid)
  //         .get();
  //     String realName = userDoc.data()?.containsKey('name') == true
  //         ? userDoc['name']
  //         : "User";
  //     String realImage = userDoc.data()?.containsKey('userimage') == true
  //         ? userDoc['userimage']
  //         : "";

  //     // 3. Save to Firestore (Including Thumbnail URL)
  //     await FirebaseFirestore.instance.collection('videos').doc(videoId).set({
  //       'uid': uid,
  //       'id': videoId,
  //       'username': realName,
  //       'profilePic': realImage,
  //       'videoUrl': downloadUrl,
  //       'thumbnail': thumbUrl, // <--- Naya field for grid view
  //       'caption': caption,
  //       'songName': 'Original Audio',
  //       'createdAt': FieldValue.serverTimestamp(),
  //       'likes': [],
  //       'views': [],
  //       'isPrivate': false,
  //     });

  //     // Cleanup Compression Cache (Memory bachane ke liye)
  //     await VideoCompress.deleteAllCache();

  //     Get.back();
  //     Get.snackbar("Mubarak!", "Reel successfully post ho gayi!");
  //   } catch (e) {
  //     Get.snackbar("Error", "Upload fail: $e");
  //   } finally {
  //     isLoading.value = false;
  //     uploadProgress.value = 0.0;
  //   }
  // }

  // Future<void> uploadVideo(String caption, String videoPath) async {
  //   try {
  //     isLoading.value = true;
  //     uploadProgress.value = 0.0; // Reset progress

  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //     String videoId = DateTime.now().millisecondsSinceEpoch.toString();

  //     // 1. Storage mein upload
  //     Reference ref = FirebaseStorage.instance
  //         .ref()
  //         .child('videos')
  //         .child(videoId);

  //     // --- Upload with Progress ---
  //     UploadTask uploadTask = ref.putFile(File(videoPath));

  //     // Progress stream listen karein
  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
  //       uploadProgress.value = progress;
  //     });

  //     // Upload complete hone ka wait karein
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     String downloadUrl = await taskSnapshot.ref.getDownloadURL();

  //     // 2. User Profile Fetch
  //     var userDoc = await FirebaseFirestore.instance
  //         .collection('userProfile')
  //         .doc(uid)
  //         .get();

  //     String realName = userDoc.data()?.containsKey('name') == true
  //         ? userDoc['name']
  //         : "User";
  //     String realImage = userDoc.data()?.containsKey('userimage') == true
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
  //       'likes': [],
  //       'views': [],
  //       'isPrivate': false, // <--- YE LINE ADD KARNA LAAZMI HAI
  //     });

  //     Get.back();
  //     Get.snackbar("Mubarak!", "Video kamyabi se post ho gayi.");
  //   } catch (e) {
  //     Get.snackbar("Error", "Upload fail: $e");
  //   } finally {
  //     isLoading.value = false;
  //     uploadProgress.value = 0.0;
  //   }
  // }

  // Future<void> uploadVideo(String caption, String videoPath) async {
  //   try {
  //     isLoading.value = true;
  //     uploadProgress.value = 0.0; // Reset progress

  //     String uid = FirebaseAuth.instance.currentUser!.uid;
  //     String videoId = DateTime.now().millisecondsSinceEpoch.toString();

  //     // 1. Storage mein upload
  //     Reference ref = FirebaseStorage.instance
  //         .ref()
  //         .child('videos')
  //         .child(videoId);

  //     // --- Upload with Progress ---
  //     UploadTask uploadTask = ref.putFile(File(videoPath));

  //     // Progress stream listen karein
  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
  //       uploadProgress.value = progress;
  //     });

  //     // Upload complete hone ka wait karein
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     String downloadUrl = await taskSnapshot.ref.getDownloadURL();

  //     // 2. User Profile Fetch
  //     var userDoc = await FirebaseFirestore.instance
  //         .collection('userProfile')
  //         .doc(uid)
  //         .get();

  //     String realName = userDoc.data()?.containsKey('name') == true
  //         ? userDoc['name']
  //         : "User";
  //     String realImage = userDoc.data()?.containsKey('userimage') == true
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
  //       'likes': [],
  //       'views': [],
  //       'isPrivate': false, // <--- YE LINE ADD KARNA LAAZMI HAI
  //     });

  //     Get.back();
  //     Get.snackbar("Mubarak!", "Video kamyabi se post ho gayi.");
  //   } catch (e) {
  //     Get.snackbar("Error", "Upload fail: $e");
  //   } finally {
  //     isLoading.value = false;
  //     uploadProgress.value = 0.0;
  //   }
  // }
}
