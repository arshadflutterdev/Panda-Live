// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final List<Map<String, dynamic>> menuItems = [
    {
      "title": AppLocalizations.of(context)!.help,
      "icon": Icons.help_outline,
      "trailing": "24h",
    },
    // {"title": AppLocalizations.of(context)!.level, "icon": Icons.star_border},
    {
      "title": AppLocalizations.of(context)!.followus,
      "icon": Icons.favorite_border,
      "social": true,
    },
    {
      "title": AppLocalizations.of(context)!.logout,
      "icon": Icons.logout,
      "danger": true,
    },
  ];
  late final StreamSubscription bgstream;
  List<String> infimages = [
    AppImages.note,
    AppImages.note1,
    AppImages.note2,
    AppImages.note3,
  ];
  //arabic on Info Images
  List<String> infoarimages = [
    AppImages.infoar2,
    AppImages.infoar0,
    AppImages.infoar1,
    AppImages.infoar,
  ];
  RxInt currentbgindex = 0.obs;
  RxString username = "".obs;
  RxString userimage = "".obs;
  RxInt followingCount = 0.obs;
  RxInt followersCount = 0.obs;
  RxInt frientsCount = 0.obs;
  RxBool isloading = false.obs;
  RxList<Map<String, dynamic>> followerList = RxList<Map<String, dynamic>>();
  RxList<Map<String, dynamic>> followingList = RxList<Map<String, dynamic>>();
  RxList<Map<String, dynamic>> friendsList = RxList<Map<String, dynamic>>();
  @override
  void initState() {
    super.initState();
    bgstream = Stream.periodic(Duration(seconds: 4)).listen((_) {
      if (!mounted) return;

      currentbgindex.value = (currentbgindex.value + 1) % infimages.length;
    });
    getUserDetails();
  }

  @override
  void dispose() {
    bgstream.cancel();
    super.dispose();
  }

  Future<void> getUserDetails() async {
    isloading.value = true;
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .get();

      final followingSnapshot = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .collection("Following")
          .get();
      followingList.value = followingSnapshot.docs.map((doc) {
        Map<String, dynamic> mydata = doc.data();
        return {
          "uid": doc.id,
          "hostname": mydata["hostname"] ?? "unknown",
          "hostimage": mydata["hostimage"] ?? "",
        };
      }).toList();

      final followerSnapshot = await FirebaseFirestore.instance
          .collection("userProfile")
          .doc(uid)
          .collection("Followers")
          .get();
      followerList.value = followerSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        print("here is follower dataaaaa $data");
        return {
          "uid": doc.id,
          "followername": data["followername"] ?? "no name",
          "followerimage": data["followerimage"] ?? null,
        };
      }).toList();
      //lets play with frinds
      // --- Start of Friends Logic ---
      friendsList.clear();

      // 1. Following IDs nikalen (Mapping mein 'uid' add kiya hai)
      Set<String> followingIds = followingList
          .map((e) => e["uid"].toString())
          .toSet();

      // 2. Followers IDs nikalen (Mapping mein 'uid' add kiya hai)
      Set<String> followerIds = followerList
          .map((e) => e["uid"].toString())
          .toSet();

      // 3. Intersection (Jo dono lists mein common hain)
      final commonIds = followingIds.intersection(followerIds);

      // 4. Friends List populate karein
      for (var id in commonIds) {
        // Following list se us user ka data (name/image) uthayen
        var friendData = followingList.firstWhere(
          (element) => element["uid"] == id,
        );

        friendsList.add({
          "uid": id,
          "name": friendData["hostname"],
          "image": friendData["hostimage"],
        });
      }

      // 5. Count update karein
      frientsCount.value = friendsList.length;
      // --- End of Friends Logic ---
      if (snapshot.exists && snapshot.data() != null) {
        username.value = snapshot.data()?["name"] ?? "no name";
        print("user name $username");
        String uid = snapshot.data()?["userId"] ?? "no id";
        print("user Id $uid");
        userimage.value = snapshot.data()?["userimage"] ?? "no image";
        print("user image $userimage");
        followingCount.value = followingList.length;

        print("here is following list=$followingCount");
        followersCount.value = followerList.length;
        print("here is followers list count $followersCount");

        //below related frients
        Set<String> followingIds = followingSnapshot.docs
            .map((doc) => doc.id)
            .toSet();
        Set<String> followersId = followerSnapshot.docs
            .map((doc) => doc.id)
            .toSet();
        frientsCount.value = followingIds.intersection(followersId).length;
        print("Friends $frientsCount");
        frientsCount.value = friendsList.length;
        followersCount.value = followerList.length;
        followingCount.value = followingList.length;
      }
    } catch (e) {
    } finally {
      isloading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    final localization = AppLocalizations.of(context)!;
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          isArabic ? "أنا" : "Me",
          style: isArabic
              ? AppStyle.arabictext.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                )
              : AppStyle.btext,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.language);
            },
            icon: Image(image: AssetImage(AppImages.settings)),
          ),
        ],
      ),
      body: Obx(
        () => isloading.value
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black38,
                            backgroundImage:
                                userimage.isNotEmpty &&
                                    userimage.startsWith("http")
                                ? NetworkImage(userimage.value)
                                : AssetImage(AppImages.girl) as ImageProvider,
                          ),
                          // Gap(10),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  username.value,
                                  style: isArabic
                                      ? AppStyle.arabictext.copyWith(
                                          fontSize: 22,
                                          height: 0.50,
                                          fontWeight: FontWeight.bold,
                                        )
                                      : AppStyle.logo.copyWith(
                                          fontSize: 20,
                                          height: 0.50,
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                  ),
                  Gap(height * 0.030),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.friends,
                              arguments: {
                                "friendCount": frientsCount.value,
                                "friendList": List.of(friendsList),
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                frientsCount.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                localization.friends,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      )
                                    : TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.following,
                              arguments: {
                                "followingss": followingCount.value,
                                "followingList": List.from(followingList),
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                followingCount.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                localization.following,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      )
                                    : TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.followers,
                              arguments: {
                                "followerss": followersCount.value,
                                "followersList": List.from(followerList),
                              },
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                followersCount.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                localization.followers,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      )
                                    : TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    localization.coins,
                                    style: isArabic
                                        ? AppStyle.arabictext
                                        : TextStyle(),
                                  ),
                                  Text("0"),
                                ],
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    localization.points,
                                    style: isArabic
                                        ? AppStyle.arabictext
                                        : TextStyle(),
                                  ),
                                  Text("0"),
                                ],
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 600),

                        child: Container(
                          key: ValueKey(currentbgindex.value),
                          height: height * 0.12,
                          width: width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: isArabic
                                  ? AssetImage(
                                      infoarimages[currentbgindex.value],
                                    )
                                  : AssetImage(infimages[currentbgindex.value]),
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
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
                              localization.invitefriend,
                              style: isArabic
                                  ? AppStyle.arabictext.copyWith(
                                      fontSize: 20,
                                      color: Colors.black54,
                                    )
                                  : AppStyle.tagline.copyWith(
                                      color: Colors.black54,
                                      fontSize: 18,
                                    ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black54,
                            ),
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
                                    : Colors.black,
                              ),
                              title: Text(
                                item["title"],
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(fontSize: 20)
                                    : TextStyle(
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
                                        Icon(
                                          Icons.facebook,
                                          color: Colors.blue,
                                        ),
                                        Gap(8),
                                        Icon(
                                          Icons.play_circle_fill,
                                          color: Colors.red,
                                        ),
                                      ],
                                    )
                                  : item["trailing"] != null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item["trailing"],
                                          style: TextStyle(
                                            color: Colors.black45,
                                          ),
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
                                  Get.toNamed(AppRoutes.followus);
                                } else if (index == 2) {
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
      ),
    );
  }
}
