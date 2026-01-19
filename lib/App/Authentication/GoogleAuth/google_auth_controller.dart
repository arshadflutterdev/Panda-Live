import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pandlive/App/Routes/app_routes.dart';

class GoogleAuthController extends GetxController {
  Future<UserCredential?> signingwithgoogle() async {
    GoogleSignIn gsignin = GoogleSignIn.instance;
    try {
      gsignin.initialize(
        serverClientId:
            "263336994953-7g76hb49aimv34b81cmmes3btt461f68.apps.googleusercontent.com",
      );
      final GoogleSignInAccount? googleauth = await gsignin.authenticate();
      if (googleauth == null) {
        return null;
      }

      final GoogleSignInAuthentication? gsignauth =
          await googleauth.authentication;
      final credentials = GoogleAuthProvider.credential(
        idToken: gsignauth?.idToken,
      );
      UserCredential? usercredential = await FirebaseAuth.instance
          .signInWithCredential(credentials);
      User? user = usercredential.user;
      final doc = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        Get.offAllNamed(AppRoutes.bottomnav);
      } else {
        Get.toNamed(
          AppRoutes.createprofile,
          arguments: {
            "userId": user.uid,
            "username": user.displayName,
            "userphoto": user.photoURL,
          },
        );
        print("user id ${user.uid}");
        print("username ${user.displayName}");
        print("user phote ${user.photoURL}");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
