import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              height: height * 0.12,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppImages.bg),
                ),
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Your account details are private. Keep them safe.",
                    style: AppStyle.btext.copyWith(fontSize: 25),
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
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppImages.bg),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Image(
                      height: 40,
                      image: AssetImage(AppImages.invite),
                      color: Colors.limeAccent,
                    ),
                    Gap(10),
                    Text(
                      "Invite a frined",
                      style: AppStyle.tagline.copyWith(color: Colors.white),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Container(
                    height: height * 0.070,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Image(
                            height: 45,
                            image: AssetImage(AppImages.invite),
                            color: Colors.amber.shade500,
                          ),
                          Gap(10),
                          Text(
                            "Invite a frined",
                            style: AppStyle.tagline.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
