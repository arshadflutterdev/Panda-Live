import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(backgroundColor: Colors.red, radius: 25),
            title: Text("FollowingNmae"),
            subtitle: Text("You’re following"),
          );
        },
      ),
    );
  }
}
