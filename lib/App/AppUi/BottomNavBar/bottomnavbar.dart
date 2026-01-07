import 'package:flutter/material.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("BottomNavBar", style: AppStyle.logo)),
    );
  }
}
