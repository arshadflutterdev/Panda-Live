// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_model.dart';

// class ProfileController extends GetxController {
//   final String targetUid;
//   ProfileController(this.targetUid);

//   final _db = FirebaseFirestore.instance;
//   var user = Rxn<UserProfileModel>();
//   var followerCount = 0.obs;
//   var followingCount = 0.obs;
//   var friendsCount = 0.obs;
//   var isLoading = true.obs;

//   // ProfileController ke andar ye function add karein
//   Future<void> updateBio(String newBio) async {
//     try {
//       // 1. Firebase mein update karein
//       await _db.collection('userProfile').doc(targetUid).update({
//         'bio': newBio,
//       });

//       // 2. Local state update (Naya model object bana kar)
//       if (user.value != null) {
//         // Hum purane data ko copy kar rahe hain aur sirf bio change kar rahe hain
//         user.value = UserProfileModel(
//           uid: user.value!.uid,
//           name: user.value!.name,
//           image: user.value!.image,
//           shortId: user.value!.shortId,
//           isVerified: user.value!.isVerified,
//           bio: newBio, // Nayi bio yahan assign hogi
//           youtubeLink: user.value!.youtubeLink,
//         );

//         // 3. UI refresh karein
//         user.refresh();
//       }

//       Get.snackbar("Success", "Bio updated successfully!");
//     } catch (e) {
//       Get.snackbar("Error", "Could not update bio");
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfileData();
//   }

//   Future<void> fetchProfileData({bool forceRefresh = false}) async {
//     try {
//       // Agar data pehle se hai aur force refresh nahi maanga gaya, toh wahi dikhao
//       if (user.value != null && !forceRefresh) {
//         return;
//       }

//       isLoading(true);

//       var userDoc = await _db.collection('userProfile').doc(targetUid).get();
//       if (userDoc.exists) {
//         user.value = UserProfileModel.fromFirestore(
//           userDoc.data()!,
//           userDoc.id,
//         );
//       }

//       // Followers/Following logic yahan rahegi...
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Future<void> fetchProfileData() async {
//   //   try {
//   //     isLoading(true);
//   //     // Fetch Basic User Info
//   //     var userDoc = await _db.collection('userProfile').doc(targetUid).get();
//   //     if (userDoc.exists) {
//   //       user.value = UserProfileModel.fromFirestore(
//   //         userDoc.data()!,
//   //         userDoc.id,
//   //       );
//   //     }

//   //     // Fetch Followers/Following Counts
//   //     var followers = await _db
//   //         .collection('userProfile')
//   //         .doc(targetUid)
//   //         .collection('Followers')
//   //         .get();
//   //     var following = await _db
//   //         .collection('userProfile')
//   //         .doc(targetUid)
//   //         .collection('Following')
//   //         .get();

//   //     followerCount.value = followers.docs.length;
//   //     followingCount.value = following.docs.length;

//   //     // Friends logic (common IDs)
//   //     var followerIds = followers.docs.map((e) => e.id).toSet();
//   //     var followingIds = following.docs.map((e) => e.id).toSet();
//   //     friendsCount.value = followerIds.intersection(followingIds).length;
//   //   } finally {
//   //     isLoading(false);
//   //   }
//   // }
// }

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
//     fetchAllVideoTabs(); // Teeno tabs ka data load karne ke liye
//   }

//   // Teeno tabs ka data fetch karne ka main function
//   Future<void> fetchAllVideoTabs() async {
//     await Future.wait([
//       fetchUserVideos(),
//       fetchLikedVideos(),
//       fetchFavoriteVideos(),
//     ]);
//   }

//   // 1. User ki apni uploaded videos
//   Future<void> fetchUserVideos() async {
//     try {
//       var videosSnapshot = await _db
//           .collection('videos')
//           .where('uid', isEqualTo: targetUid)
//           .get();

//       userVideos.assignAll(
//         videosSnapshot.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
//       );
//     } catch (e) {
//       print("Error fetching user videos: $e");
//     }
//   }

//   // 2. Wo videos jo user ne LIKE ki hain
//   Future<void> fetchLikedVideos() async {
//     try {
//       var likedSnapshot = await _db
//           .collection('videos')
//           .where('likes', arrayContains: targetUid)
//           .get();

//       likedVideos.assignAll(
//         likedSnapshot.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
//       );
//     } catch (e) {
//       print("Error fetching liked videos: $e");
//     }
//   }

//   // 3. Wo videos jo user ne FAVORITE/SAVE ki hain
//   Future<void> fetchFavoriteVideos() async {
//     try {
//       // Note: Agar aap favorites alag collection mein rakhte hain to wahan se fetch karein
//       // Filhal ye "favorites" collection se data utha raha hai jo targetUid ke under hai
//       var favSnapshot = await _db
//           .collection('userProfile')
//           .doc(targetUid)
//           .collection('favorites')
//           .get();

//       favoriteVideos.assignAll(
//         favSnapshot.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
//       );
//     } catch (e) {
//       print("Error fetching favorites: $e");
//     }
//   }

//   Future<void> fetchProfileData({bool forceRefresh = false}) async {
//     try {
//       if (user.value != null && !forceRefresh) return;
//       isLoading(true);

//       var userDoc = await _db.collection('userProfile').doc(targetUid).get();
//       if (userDoc.exists) {
//         user.value = UserProfileModel.fromFirestore(
//           userDoc.data()!,
//           userDoc.id,
//         );
//       }

//       // Followers/Following logic (Jo aapne pehle comment ki thi, maine uncomment kar di hai)
//       var followers = await _db
//           .collection('userProfile')
//           .doc(targetUid)
//           .collection('Followers')
//           .get();
//       var following = await _db
//           .collection('userProfile')
//           .doc(targetUid)
//           .collection('Following')
//           .get();

//       followerCount.value = followers.docs.length;
//       followingCount.value = following.docs.length;

//       var followerIds = followers.docs.map((e) => e.id).toSet();
//       var followingIds = following.docs.map((e) => e.id).toSet();
//       friendsCount.value = followerIds.intersection(followingIds).length;
//     } finally {
//       isLoading(false);
//     }
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

  // --- Nayi Lists jo UI mein use hongi ---
  RxList<VideoModel> userVideos = <VideoModel>[].obs;
  RxList<VideoModel> likedVideos = <VideoModel>[].obs;
  RxList<VideoModel> favoriteVideos = <VideoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
    bindAllVideoStreams(); // Real-time streams bind karne ke liye
    bindAllVideoStreams(); // Videos ke liye (jo pehle se hai)
    bindStatsStreams();
  }

  // --- FIX: Real-time Streams Bind Function ---
  void bindAllVideoStreams() {
    // 1. User ki apni uploaded videos (Real-time)
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

    // 2. Wo videos jo user ne LIKE ki hain (Real-time)
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

    // 3. Wo videos jo user ne FAVORITE ki hain (Real-time)
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

  // Ab fetchAllVideoTabs ki zaroorat nahi kyunki bindStream khud handle karta hai
  Future<void> fetchAllVideoTabs() async {
    // Ye function empty chora hai takay agar puray code mein kahin call ho raha ho to error na aaye
  }

  Future<void> fetchProfileData({bool forceRefresh = false}) async {
    try {
      if (user.value != null && !forceRefresh) return;
      isLoading(true);

      var userDoc = await _db.collection('userProfile').doc(targetUid).get();
      if (userDoc.exists) {
        user.value = UserProfileModel.fromFirestore(
          userDoc.data()!,
          userDoc.id,
        );
      }

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

      followerCount.value = followers.docs.length;
      followingCount.value = following.docs.length;

      var followerIds = followers.docs.map((e) => e.id).toSet();
      var followingIds = following.docs.map((e) => e.id).toSet();
      friendsCount.value = followerIds.intersection(followingIds).length;
    } finally {
      isLoading(false);
    }
  }

  void bindStatsStreams() {
    // Real-time Followers Listener
    _db
        .collection('userProfile')
        .doc(targetUid)
        .collection('followers') // small 'f'
        .snapshots()
        .listen((snap) {
          followerCount.value = snap.docs.length;
          _updateFriendsCount(); // Friends count ko update karne ke liye
        });

    // Real-time Following Listener
    _db
        .collection('userProfile')
        .doc(targetUid)
        .collection('following') // small 'f'
        .snapshots()
        .listen((snap) {
          followingCount.value = snap.docs.length;
          _updateFriendsCount();
        });
  }

  // Friends count calculate karne ka logic (Common IDs)
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
