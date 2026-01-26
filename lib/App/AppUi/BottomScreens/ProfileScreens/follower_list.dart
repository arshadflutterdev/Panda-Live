import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class FollowerListScreen extends StatefulWidget {
  const FollowerListScreen({super.key});

  @override
  State<FollowerListScreen> createState() => _FollowerListScreenState();
}

class _FollowerListScreenState extends State<FollowerListScreen> {
  final arg = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("${arg["followerss"]}")));
  }
}
