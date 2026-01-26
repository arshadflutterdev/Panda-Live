import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:pandlive/App/AppUi/LiveStreaming/WatchStreaming/watch_stream_controllers.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';

class FollowerListScreen extends StatefulWidget {
  const FollowerListScreen({super.key});

  @override
  State<FollowerListScreen> createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
  final streamcontroll = Get.find<WatchStreamControllers>();
  final dynamic arg = Get.arguments;
  RxBool isFriend = false.obs;

  @override
  Widget build(BuildContext context) {
    final List followergList = arg?["followersList"] ?? [];
    print("data in following List$followergList");

    return Scaffold(
      appBar: AppBar(
        title: Text("Followers ${arg["followerss"] ?? 0}"),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      backgroundColor: Colors.white,
      body: followergList.isEmpty
          ? Text("You haven't follow")
          : ListView.builder(
              itemCount: followergList.length,
              itemBuilder: (context, index) {
                final follower = followergList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        follower["followerimage"].toString().startsWith("http")
                        ? NetworkImage(follower["followerimage"])
                        : AssetImage(AppImages.profile),
                    radius: 25,
                  ),
                  title: Text(follower["followername"] ?? "Unknown"),
                  subtitle: Text("Following you"),
                );
              },
            ),
    );
  }
}
