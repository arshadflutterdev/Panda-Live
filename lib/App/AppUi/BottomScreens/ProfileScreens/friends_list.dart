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
        itemCount: 10,

        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Friend name"),
            subtitle: Text("Your friend"),
            leading: CircleAvatar(radius: 25, backgroundColor: Colors.red),
          );
        },
      ),
    );
  }
}
