import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchstreamingClass extends StatefulWidget {
  const WatchstreamingClass({super.key});

  @override
  State<WatchstreamingClass> createState() => _WatchstreamingClassState();
}

class _WatchstreamingClassState extends State<WatchstreamingClass> {
  final arg = Get.arguments as Map<String, dynamic>;
  String get images => arg["images"];
  String get namess => arg["names"];
  String get arnames => arg["arabicnam"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(namess)));
  }
}
