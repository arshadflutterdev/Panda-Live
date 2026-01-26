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
        title: Text("Followers ${arg["followerss"]}"),
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
      body: followingList.isEmpty
          ? Text("You haven't follow")
          : ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 25,
                  ),
                  title: Text("FollowerName"),
                  subtitle: Text("Following you"),
                  trailing: SizedBox(
                    height: 30,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {},
                      child: Text(
                        "Follow back",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
