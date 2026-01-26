import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';

class FollowingListScreen extends StatefulWidget {
  const FollowingListScreen({super.key});

  @override
  State<FollowingListScreen> createState() => _FollowingListScreenState();
}

class _FollowingListScreenState extends State<FollowingListScreen> {
  final dynamic arg = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final List followingList = arg?["followingList"] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text("Following ${arg["followingss"]}"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: followingList.length,
        itemBuilder: (context, index) {
          final following = followingList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 25,
              backgroundImage:
                  following["hostimage"].toString().startsWith("http")
                  ? NetworkImage(following["hostimage"])
                  : AssetImage(AppImages.profile),
            ),
            title: Text("${following["hostname"]}"),
            subtitle: Text("You’re following"),
          );
        },
      ),
    );
  }
}
