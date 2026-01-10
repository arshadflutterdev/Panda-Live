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
        iconSize: 50,

        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage(AppImages.live),
              height: 35,
              width: 35,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage(AppImages.chat),
              height: 30,
              width: 30,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage(AppImages.myprofile),
              height: 30,
              width: 30,
            ),
            label: "Home",
          ),
        ],
      ),
    );
  }
}
