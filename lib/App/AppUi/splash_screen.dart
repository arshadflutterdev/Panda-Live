import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final flocalization = FlutterLocalization.instance;
  final currentuser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      if (currentuser != null) {
        try {
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection("userProfile")
              .doc(currentuser!.uid)
              .get();
          if (userData.exists) {
            var data = userData.data() as Map<String, dynamic>;
            if (data["blockStatus"] == "blocked") {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(AppRoutes.authoptions);
              Get.snackbar(
                "Account Blocked",
                "Aapka account block kar diya gaya hai.",
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            } else {
              Get.offAllNamed(AppRoutes.bottomnav);
            }
          } else {
            Get.offAllNamed(AppRoutes.authoptions);
          }
        } catch (e) {
          debugPrint("Error: $e");
          Get.offAllNamed(AppRoutes.authoptions);
        }
      } else {
        Get.toNamed(AppRoutes.authoptions);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      body: Center(child: Text("PandaLive", style: AppStyle.logo)),
    );
  }
}
