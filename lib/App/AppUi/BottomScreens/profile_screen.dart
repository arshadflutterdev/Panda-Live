import 'package:flutter/material.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile", style: AppStyle.btext),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(AppImages.settings, height: 25, width: 25),
          ),
        ],
      ),
      body: Column(children: [
          
        ],
      ),
    );
  }
}
