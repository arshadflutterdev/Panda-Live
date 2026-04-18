// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_model.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';

// class ProfileController extends GetxController {
//   final String targetUid;
//   ProfileController(this.targetUid);

//   final _db = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;

//   var user = Rxn<UserProfileModel>();
//   var followerCount = 0.obs;
//   var followingCount = 0.obs;
//   var friendsCount = 0.obs;
//   var isLoading = true.obs;

//   // --- Nayi Lists jo UI mein use hongi ---
//   RxList<VideoModel> userVideos = <VideoModel>[].obs;
//   RxList<VideoModel> likedVideos = <VideoModel>[].obs;
//   RxList<VideoModel> favoriteVideos = <VideoModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfileData();
//     bindAllVideoStreams(); // Real-time streams bind karne ke liye
//     bindAllVideoStreams(); // Videos ke liye (jo pehle se hai)
//     bindStatsStreams();
//   }

//   // --- FIX: Real-time Streams Bind Function ---
//   void bindAllVideoStreams() {
//     // 1. User ki apni uploaded videos (Real-time)
//     userVideos.bindStream(
//       _db
//           .collection('videos')
//           .where('uid', isEqualTo: targetUid)
//           .snapshots()
//           .map(
//             (query) =>
//                 query.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
//           ),
//     );

//     // 2. Wo videos jo user ne LIKE ki hain (Real-time)
//     likedVideos.bindStream(
//       _db
//           .collection('videos')
//           .where('likes', arrayContains: targetUid)
//           .snapshots()
//           .map(
//             (query) =>
//                 query.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
//           ),
//     );

//     // 3. Wo videos jo user ne FAVORITE ki hain (Real-time)
//     favoriteVideos.bindStream(
//       _db
//           .collection('userProfile')
//           .doc(targetUid)
//           .collection('favorites')
//           .snapshots()
//           .map(
//             (query) =>
//                 query.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
//           ),
//     );
//   }

//   // Ab fetchAllVideoTabs ki zaroorat nahi kyunki bindStream khud handle karta hai
//   Future<void> fetchAllVideoTabs() async {
//     // Ye function empty chora hai takay agar puray code mein kahin call ho raha ho to error na aaye
//   }
//   Future<void> fetchProfileData({bool forceRefresh = false}) async {
//     try {
//       if (user.value != null && !forceRefresh) return;
//       isLoading(true);

//       // Real-time listener for user profile
//       _db.collection('userProfile').doc(targetUid).snapshots().listen((
//         userDoc,
//       ) {
//         if (userDoc.exists) {
//           user.value = UserProfileModel.fromFirestore(
//             userDoc.data()!,
//             userDoc.id,
//           );
//         }
//       });

//       // Real-time listener for followers and friends count
//       _db
//           .collection('userProfile')
//           .doc(targetUid)
//           .collection('followers')
//           .snapshots()
//           .listen((followers) async {
//             followerCount.value = followers.docs.length;

//             // Refresh following and friends logic
//             var following = await _db
//                 .collection('userProfile')
//                 .doc(targetUid)
//                 .collection('following')
//                 .get();
//             followingCount.value = following.docs.length;

//             var followerIds = followers.docs.map((e) => e.id).toSet();
//             var followingIds = following.docs.map((e) => e.id).toSet();
//             friendsCount.value = followerIds.intersection(followingIds).length;
//           });

//       // Real-time listener for following changes
//       _db
//           .collection('userProfile')
//           .doc(targetUid)
//           .collection('following')
//           .snapshots()
//           .listen((following) async {
//             followingCount.value = following.docs.length;

//             // Refresh followers and friends logic
//             var followers = await _db
//                 .collection('userProfile')
//                 .doc(targetUid)
//                 .collection('followers')
//                 .get();
//             followerCount.value = followers.docs.length;

//             var followerIds = followers.docs.map((e) => e.id).toSet();
//             var followingIds = following.docs.map((e) => e.id).toSet();
//             friendsCount.value = followerIds.intersection(followingIds).length;
//           });
//     } catch (e) {
//       print("Error: ${e.toString()}");
//     } finally {
//       isLoading(false);
//     }
//   }

//   void bindStatsStreams() {
//     // Real-time Followers Listener
//     _db
//         .collection('userProfile')
//         .doc(targetUid)
//         .collection('followers') // small 'f'
//         .snapshots()
//         .listen((snap) {
//           followerCount.value = snap.docs.length;
//           _updateFriendsCount(); // Friends count ko update karne ke liye
//         });

//     // Real-time Following Listener
//     _db
//         .collection('userProfile')
//         .doc(targetUid)
//         .collection('following') // small 'f'
//         .snapshots()
//         .listen((snap) {
//           followingCount.value = snap.docs.length;
//           _updateFriendsCount();
//         });
//   }

//   // Friends count calculate karne ka logic (Common IDs)
//   void _updateFriendsCount() async {
//     var followers = await _db
//         .collection('userProfile')
//         .doc(targetUid)
//         .collection('followers')
//         .get();
//     var following = await _db
//         .collection('userProfile')
//         .doc(targetUid)
//         .collection('following')
//         .get();

//     var followerIds = followers.docs.map((e) => e.id).toSet();
//     var followingIds = following.docs.map((e) => e.id).toSet();

//     friendsCount.value = followerIds.intersection(followingIds).length;
//   }

//   Future<void> updateBio(String newBio) async {
//     try {
//       await _db.collection('userProfile').doc(targetUid).update({
//         'bio': newBio,
//       });
//       if (user.value != null) {
//         user.value = UserProfileModel(
//           uid: user.value!.uid,
//           name: user.value!.name,
//           image: user.value!.image,
//           shortId: user.value!.shortId,
//           isVerified: user.value!.isVerified,
//           bio: newBio,
//           youtubeLink: user.value!.youtubeLink,
//         );
//         user.refresh();
//       }
//       Get.snackbar("Success", "Bio updated successfully!");
//     } catch (e) {
//       Get.snackbar("Error", "Could not update bio");
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_model.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';

class ProfileController extends GetxController {
  final String targetUid;
  ProfileController(this.targetUid);

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  var user = Rxn<UserProfileModel>();
  var followerCount = 0.obs;
  var followingCount = 0.obs;
  var friendsCount = 0.obs;
  var isLoading = true.obs;

  // --- Follow/Unfollow State ---
  RxBool isFollowing = false.obs;

  // --- Lists jo UI mein use hongi ---
  RxList<VideoModel> userVideos = <VideoModel>[].obs;
  RxList<VideoModel> likedVideos = <VideoModel>[].obs;
  RxList<VideoModel> favoriteVideos = <VideoModel>[].obs;

  //video private

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
    bindAllVideoStreams();
    bindStatsStreams();
    checkIfFollowing(); // Initialize following state
  }

  // --- Real-time Follow/Unfollow Logic ---
  void checkIfFollowing() {
    final myUid = _auth.currentUser!.uid;
    _db
        .collection('userProfile')
        .doc(myUid)
        .collection('following')
        .doc(targetUid)
        .snapshots()
        .listen((doc) {
          isFollowing.value = doc.exists;
        });
  }

  Future<void> toggleVideoPrivacy(String videoId, bool currentStatus) async {
    try {
      await _db.collection('videos').doc(videoId).update({
        'isPrivate': !currentStatus,
      });

      Get.back(); // Bottom sheet close karein
      Get.snackbar(
        "Success",
        !currentStatus ? "Video moved to Private" : "Video is now Public",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Action failed: $e");
    }
  }

  //video delete controller
  Future<void> deleteVideo(String videoId) async {
    try {
      // 1. Firestore se video document delete karein
      await _db.collection('videos').doc(videoId).delete();

      // 2. Agar aapne favorites mein bhi store ki hai to wahan se bhi remove karein (Optional)
      // await _db.collection('userProfile').doc(targetUid).collection('favorites').doc(videoId).delete();

      Get.back(); // Bottom sheet close karne ke liye
      Get.snackbar(
        "Success",
        "Video deleted successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar("Error", "Could not delete video: $e");
    }
  }

  Future<void> toggleFollow() async {
    try {
      final myUid = _auth.currentUser!.uid;
      final followingRef = _db
          .collection('userProfile')
          .doc(myUid)
          .collection('following')
          .doc(targetUid);
      final followersRef = _db
          .collection('userProfile')
          .doc(targetUid)
          .collection('followers')
          .doc(myUid);

      if (isFollowing.value) {
        // Unfollow
        await followingRef.delete();
        await followersRef.delete();
      } else {
        // Follow
        await followingRef.set({
          'uid': targetUid,
          'timestamp': FieldValue.serverTimestamp(),
        });
        await followersRef.set({
          'uid': myUid,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Action failed: $e");
    }
  }

  // --- Real-time Streams Bind Function ---
  // void bindAllVideoStreams() {
  //   final myUid = _auth.currentUser!.uid;

  //   // 1. User Videos Stream (Privacy Filter ke sath)
  //   userVideos.bindStream(
  //     _db.collection('videos').where('uid', isEqualTo: targetUid).snapshots().map((
  //       query,
  //     ) {
  //       List<VideoModel> retVal = [];
  //       for (var element in query.docs) {
  //         VideoModel video = VideoModel.fromSnap(element);

  //         // LOGIC: Agar video private hai AUR dekhne wala video ka owner nahi hai, toh add mat karo
  //         if (video.isPrivate && targetUid != myUid) {
  //           continue;
  //         }
  //         retVal.add(video);
  //       }
  //       return retVal;
  //     }),
  //   );

  //   // 2. Liked Videos Stream
  //   likedVideos.bindStream(
  //     _db
  //         .collection('videos')
  //         .where('likes', arrayContains: targetUid)
  //         .snapshots()
  //         .map((query) {
  //           List<VideoModel> retVal = [];
  //           for (var element in query.docs) {
  //             VideoModel video = VideoModel.fromSnap(element);
  //             // Liked videos mein bhi privacy check (Optional: TikTok par liked hidden hoti hain aksar)
  //             if (video.isPrivate && video.uid != myUid) {
  //               continue;
  //             }
  //             retVal.add(video);
  //           }
  //           return retVal;
  //         }),
  //   );

  //   // 3. Favorite Videos Stream (Agar sub-collection use kar rahe hain)
  //   favoriteVideos.bindStream(
  //     _db
  //         .collection('userProfile')
  //         .doc(targetUid)
  //         .collection('favorites')
  //         .snapshots()
  //         .map(
  //           (query) =>
  //               query.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
  //         ),
  //   );
  // }

  void bindAllVideoStreams() {
    userVideos.bindStream(
      _db
          .collection('videos')
          .where('uid', isEqualTo: targetUid)
          .snapshots()
          .map(
            (query) =>
                query.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
          ),
    );

    likedVideos.bindStream(
      _db
          .collection('videos')
          .where('likes', arrayContains: targetUid)
          .snapshots()
          .map(
            (query) =>
                query.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
          ),
    );

    favoriteVideos.bindStream(
      _db
          .collection('userProfile')
          .doc(targetUid)
          .collection('favorites')
          .snapshots()
          .map(
            (query) =>
                query.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
          ),
    );
  }

  Future<void> fetchAllVideoTabs() async {}

  Future<void> fetchProfileData({bool forceRefresh = false}) async {
    try {
      if (user.value != null && !forceRefresh) return;
      isLoading(true);

      _db.collection('userProfile').doc(targetUid).snapshots().listen((
        userDoc,
      ) {
        if (userDoc.exists) {
          user.value = UserProfileModel.fromFirestore(
            userDoc.data()!,
            userDoc.id,
          );
        }
      });

      _db
          .collection('userProfile')
          .doc(targetUid)
          .collection('followers')
          .snapshots()
          .listen((followers) async {
            followerCount.value = followers.docs.length;
            var following = await _db
                .collection('userProfile')
                .doc(targetUid)
                .collection('following')
                .get();
            followingCount.value = following.docs.length;

            var followerIds = followers.docs.map((e) => e.id).toSet();
            var followingIds = following.docs.map((e) => e.id).toSet();
            friendsCount.value = followerIds.intersection(followingIds).length;
          });

      _db
          .collection('userProfile')
          .doc(targetUid)
          .collection('following')
          .snapshots()
          .listen((following) async {
            followingCount.value = following.docs.length;
            var followers = await _db
                .collection('userProfile')
                .doc(targetUid)
                .collection('followers')
                .get();
            followerCount.value = followers.docs.length;

            var followerIds = followers.docs.map((e) => e.id).toSet();
            var followingIds = following.docs.map((e) => e.id).toSet();
            friendsCount.value = followerIds.intersection(followingIds).length;
          });
    } catch (e) {
      print("Error: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  void bindStatsStreams() {
    _db
        .collection('userProfile')
        .doc(targetUid)
        .collection('followers')
        .snapshots()
        .listen((snap) {
          followerCount.value = snap.docs.length;
          _updateFriendsCount();
        });

    _db
        .collection('userProfile')
        .doc(targetUid)
        .collection('following')
        .snapshots()
        .listen((snap) {
          followingCount.value = snap.docs.length;
          _updateFriendsCount();
        });
  }

  void _updateFriendsCount() async {
    var followers = await _db
        .collection('userProfile')
        .doc(targetUid)
        .collection('followers')
        .get();
    var following = await _db
        .collection('userProfile')
        .doc(targetUid)
        .collection('following')
        .get();

    var followerIds = followers.docs.map((e) => e.id).toSet();
    var followingIds = following.docs.map((e) => e.id).toSet();
    friendsCount.value = followerIds.intersection(followingIds).length;
  }

  Future<void> updateBio(String newBio) async {
    try {
      await _db.collection('userProfile').doc(targetUid).update({
        'bio': newBio,
      });
      if (user.value != null) {
        user.value = UserProfileModel(
          uid: user.value!.uid,
          name: user.value!.name,
          image: user.value!.image,
          shortId: user.value!.shortId,
          isVerified: user.value!.isVerified,
          bio: newBio,
          youtubeLink: user.value!.youtubeLink,
        );
        user.refresh();
      }
      Get.snackbar("Success", "Bio updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Could not update bio");
    }
  }
}
