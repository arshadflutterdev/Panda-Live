import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/chat_screen.dart';
import 'package:pandlive/App/AppUi/BottomScreens/homescreen.dart';
import 'package:pandlive/App/AppUi/BottomScreens/profile_screen.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  RxInt selectedScreen = 0.obs;
  List<Widget> screens = [Homescreen(), ChatScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedScreen.value],
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          selectedItemColor: Colors.black,

          currentIndex: selectedScreen.value,
          onTap: (index) {
            selectedScreen.value = index;
          },
          iconSize: 50,

          unselectedItemColor: Colors.black54,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(AppImages.live),
                color: selectedScreen.value == 0
                    ? Colors.black
                    : Colors.black38,
                height: 35,
                width: 35,
              ),
              label: "Live",
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(AppImages.chat),
                color: selectedScreen.value == 1
                    ? Colors.black
                    : Colors.black38,

                height: 30,
                width: 30,
              ),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(AppImages.myprofile),
                color: selectedScreen.value == 2
                    ? Colors.black
                    : Colors.black38,

                height: 30,
                width: 30,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
