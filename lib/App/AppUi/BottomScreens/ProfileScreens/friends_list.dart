import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  final dynamic arg = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final friends = arg["friendCount"];
    final List friendList = arg?["friendList"] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends $friends"),
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
      body: ListView.builder(
        itemCount: friendList.length,

        itemBuilder: (context, index) {
          final data = friendList[index];
          return ListTile(
            title: Text("${data["name"]}"),
            subtitle: Text(
              "Your friend",
              style: TextStyle(color: Colors.black54),
            ),
            leading: CircleAvatar(radius: 25, backgroundColor: Colors.red),
          );
        },
      ),
    );
  }
}
