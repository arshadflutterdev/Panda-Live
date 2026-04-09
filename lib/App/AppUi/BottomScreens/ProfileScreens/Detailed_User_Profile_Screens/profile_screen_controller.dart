import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_model.dart';

class ProfileController extends GetxController {
  final String targetUid;
  ProfileController(this.targetUid);

  final _db = FirebaseFirestore.instance;
  var user = Rxn<UserProfileModel>();
  var followerCount = 0.obs;
  var followingCount = 0.obs;
  var friendsCount = 0.obs;
  var isLoading = true.obs;
  // ProfileController ke andar ye function add karein
  Future<void> updateBio(String newBio) async {
    try {
      // 1. Firebase update
      await _db.collection('userProfile').doc(targetUid).update({
        'bio': newBio,
      });

      // 2. Local State Update
      if (user.value != null) {
        // Model ko naye data ke sath re-initialize karein
        user.value = UserProfileModel(
          uid: user.value!.uid,
          name: user.value!.name,
          image: user.value!.image,
          shortId: user.value!.shortId,
          isVerified: user.value!.isVerified,
          bio: newBio,
          youtubeLink: user.value!.youtubeLink,
        );

        // 3. Force Refresh (Ye UI ko foran signal bhejta hai)
        user.refresh();
      }

      Get.snackbar("Success", "Bio updated!");
    } catch (e) {
      Get.snackbar("Error", "Update failed: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading(true);
      // Fetch Basic User Info
      var userDoc = await _db.collection('userProfile').doc(targetUid).get();
      if (userDoc.exists) {
        user.value = UserProfileModel.fromFirestore(
          userDoc.data()!,
          userDoc.id,
        );
      }

      // Fetch Followers/Following Counts
      var followers = await _db
          .collection('userProfile')
          .doc(targetUid)
          .collection('Followers')
          .get();
      var following = await _db
          .collection('userProfile')
          .doc(targetUid)
          .collection('Following')
          .get();

      followerCount.value = followers.docs.length;
      followingCount.value = following.docs.length;

      // Friends logic (common IDs)
      var followerIds = followers.docs.map((e) => e.id).toSet();
      var followingIds = following.docs.map((e) => e.id).toSet();
      friendsCount.value = followerIds.intersection(followingIds).length;
    } finally {
      isLoading(false);
    }
  }
}
