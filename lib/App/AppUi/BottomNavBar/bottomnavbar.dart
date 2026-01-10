import 'package:flutter/material.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Image(image: AssetImage(AppImages.live)),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image(image: AssetImage(AppImages.chat)),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image(image: AssetImage(AppImages.profile)),
            label: "Home",
          ),
        ],
      ),
    );
  }
}
