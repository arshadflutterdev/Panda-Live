import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class FollowerListScreen extends StatefulWidget {
  const FollowerListScreen({super.key});

  @override
  State<FollowerListScreen> createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
  final dynamic arg = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final List followingList = arg["followersList"] ?? [];
    print("data in following List$followingList");

    return Scaffold(
      appBar: AppBar(
        title: Text("${arg["followerss"]}"),
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
    );
  }
}
