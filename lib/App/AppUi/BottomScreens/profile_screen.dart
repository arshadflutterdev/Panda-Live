import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:pandlive/App/AppUi/Profile/nextScreens/help_screen.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Help", "icon": Icons.help_outline, "trailing": "24h"},
    {"title": "Level", "icon": Icons.star_border},
    {"title": "Follow Us", "icon": Icons.favorite_border, "social": true},
    {"title": "Logout", "icon": Icons.logout, "danger": true},
  ];
  late final StreamSubscription bgstream;
  List<String> infimages = [
    AppImages.note,
    AppImages.note1,
    AppImages.note2,
    AppImages.note3,
  ];
  //Text on Info Images
  List<String> infoText = [
    "If You Have Any Questions Please Contant Us Immediately",
    "Keep your account information private at all times.",
    "Offical Announcement Beaware of Scams",
    "Keep streams safe: No sexual or explicit conten",
  ];
  RxInt currentbgindex = 0.obs;
  void initState() {
    super.initState();
    bgstream = Stream.periodic(Duration(seconds: 4)).listen((_) {
      if (!mounted) return;

      currentbgindex.value = (currentbgindex.value + 1) % infimages.length;
    });
  }

  void dispose() {
    bgstream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Me", style: AppStyle.btext),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(AppImages.settings, height: 25, width: 25),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black38,
                  backgroundImage: AssetImage(AppImages.eman0),
                ),
                // Gap(10),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Arshad Yahaya",
                        style: AppStyle.logo.copyWith(
                          fontSize: 20,
                          height: 0.50,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black38,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  "ID",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Gap(4),
                            Text(
                              "78491356",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: Icon(Icons.copy, size: 17),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Gap(height * 0.030),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("0", style: TextStyle(fontSize: 20)),
                  Text(
                    "Friends",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("0", style: TextStyle(fontSize: 20)),
                  Text(
                    "Following",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("0", style: TextStyle(fontSize: 20)),
                  Text(
                    "Followers",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("0", style: TextStyle(fontSize: 20)),
                  Text(
                    "Visitors",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          Gap(height * 0.030),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: width * 0.45,
                height: height * 0.080,
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text("Coins"), Text("0")],
                      ),
                      Spacer(),
                      Image(image: AssetImage(AppImages.coins)),
                    ],
                  ),
                ),
              ),
              Container(
                width: width * 0.45,
                height: height * 0.080,
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text("Points"), Text("0")],
                      ),
                      Spacer(),
                      Image(image: AssetImage(AppImages.dollar)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 600),

                child: Container(
                  key: ValueKey(currentbgindex.value),
                  height: height * 0.12,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(infimages[currentbgindex.value]),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              height: height * 0.070,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Image(
                      height: 30,
                      image: AssetImage(AppImages.invite),
                      color: Colors.black54,
                    ),
                    Gap(10),
                    Text(
                      "Invite a friend",
                      style: AppStyle.tagline.copyWith(
                        color: Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.separated(
                  itemCount: menuItems.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade300),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];

                    return ListTile(
                      leading: Icon(
                        item["icon"],
                        color: item["danger"] == true
                            ? Colors.red
                            : Colors.black54,
                      ),
                      title: Text(
                        item["title"],
                        style: TextStyle(
                          fontSize: 16,
                          color: item["danger"] == true
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                      trailing: item["social"] == true
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.facebook, color: Colors.blue),
                                Gap(8),
                                Icon(Icons.play_circle_fill, color: Colors.red),
                              ],
                            )
                          : item["trailing"] != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item["trailing"],
                                  style: TextStyle(color: Colors.black45),
                                ),
                                Gap(6),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.black38,
                                ),
                              ],
                            )
                          : Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black38,
                            ),
                      onTap: () {
                        if (index == 0) {
                          Get.toNamed(AppRoutes.help);
                        } else if (index == 1) {
                          Get.toNamed(AppRoutes.level);
                        } else if (index == 2) {
                          Get.toNamed(AppRoutes.followus);
                        } else if (index == 3) {
                          Get.toNamed(AppRoutes.logout);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
