import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/profile_screen.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/reel_player_screen.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReelsController());
    final TextEditingController _commentController = TextEditingController();
    void showCommentBottomSheet(BuildContext context, String videoId) {
      final TextEditingController _commentController = TextEditingController();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Color(0xFF121212),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                "Comments",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.white12),

              Expanded(
                child: Obx(() {
                  if (controller.comments.isEmpty) {
                    return const Center(
                      child: Text(
                        "No comments yet",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.comments.length,
                    itemBuilder: (context, index) {
                      final comment = controller.comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(comment.profilePic),
                        ),
                        title: Text(
                          comment.username,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.comment,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text(
                                  "2h",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ), // Time placeholder
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    // Yahan Reply wala logic trigger karein
                                    _commentController.text =
                                        "@${comment.username} ";
                                  },
                                  child: const Text(
                                    "Reply",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              // Idhar 'videoId' aur 'comment.id' dono pass karne hain
                              onTap: () =>
                                  controller.likeComment(videoId, comment.id),
                              child: Icon(
                                comment.likes.contains(
                                      FirebaseAuth.instance.currentUser!.uid,
                                    )
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 20,
                                color:
                                    comment.likes.contains(
                                      FirebaseAuth.instance.currentUser!.uid,
                                    )
                                    ? Colors.red
                                    : Colors.white54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${comment.likes.length}",
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                  left: 15,
                  right: 15,
                  top: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Add a comment...",
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.postComment(
                          videoId,
                          _commentController.text,
                        );
                        _commentController.clear();
                        FocusScope.of(
                          context,
                        ).unfocus(); // Keyboard hide karne ke liye
                      },
                      icon: const Icon(Icons.send, color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Main Video PageView
          Obx(
            () => PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.videoList.length,
              // ReelsScreen ke PageView.builder mein ye update karein:
              itemBuilder: (context, index) {
                final data =
                    controller.videoList[index]; // Firebase se aane wala data

                return Stack(
                  children: [
                    // 1. Actual Video Player
                    VideoPlayerItem(videoUrl: data.videoUrl),

                    // 2. Right Side Profile/User Section (TikTok Style)
                    Positioned(
                      right: 15,
                      bottom: 120, // Isay likes ke upar set karein
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigating to Profile Screen using GetX
                              // 'data.uid' pass kar rahe hain taake us specific user ki profile khule
                              Get.to(
                                () => ProfileScreen(uid: data.uid),
                                transition: Transition
                                    .cupertino, // iOS style smooth slide transition
                                duration: const Duration(milliseconds: 400),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(
                                2,
                              ), // White border effect
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.black,
                                // --- REAL IMAGE LOADING ---
                                // Agar profilePic link hai to wo dikhao
                                backgroundImage: data.profilePic.isNotEmpty
                                    ? NetworkImage(data.profilePic)
                                    : null,
                                // Agar profilePic khali hai to User ka pehla letter dikhao
                                child: data.profilePic.isEmpty
                                    ? Text(
                                        data.username.isNotEmpty
                                            ? data.username[0].toUpperCase()
                                            : "?",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),

                          // Wo chota sa red plus icon (TikTok Follow Button)
                          // ReelsScreen.dart mein Profile Picture ke neeche wala Plus Icon code:
                          StreamBuilder<bool>(
                            stream: controller.isFollowing(
                              data.uid,
                            ), // Check kar raha hai follow status
                            builder: (context, snapshot) {
                              // Agar data load ho raha ho ya user already followed ho, toh khali box dikhao (Hide icon)
                              if (data.uid ==
                                  FirebaseAuth.instance.currentUser!.uid) {
                                return const SizedBox.shrink();
                              }
                              if (snapshot.data == true) {
                                return const SizedBox.shrink(); // Icon gayab ho jayega
                              }

                              // Agar user followed NAHI hai, toh Plus Icon dikhao
                              return Transform.translate(
                                offset: const Offset(0, -10),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.followUser(
                                      data.uid,
                                    ); // Follow logic call hoga
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // 2. Right Side Action Buttons (TikTok Style)
                    // 2. Right Side Action Buttons (TikTok Style)
                    Positioned(
                      right: 15,
                      bottom: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // --- PROFILE SECTION ---
                          GestureDetector(
                            onTap: () =>
                                Get.to(() => ProfileScreen(uid: data.uid)),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(1.5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: data.profilePic.isNotEmpty
                                        ? NetworkImage(data.profilePic)
                                        : null,
                                    child: data.profilePic.isEmpty
                                        ? Text(data.username[0].toUpperCase())
                                        : null,
                                  ),
                                ),
                                StreamBuilder<bool>(
                                  stream: controller.isFollowing(data.uid),
                                  builder: (context, snapshot) {
                                    if (data.uid ==
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid ||
                                        snapshot.data == true) {
                                      return const SizedBox.shrink();
                                    }
                                    return Positioned(
                                      bottom: -8,
                                      left: 18,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.followUser(data.uid),
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // --- LIKE BUTTON (Fixed with GetX Obx) ---
                          Obx(() {
                            // controller.videoList se current video ka fresh data nikalna zaroori hai
                            final currentVideo = controller.videoList
                                .firstWhere((v) => v.id == data.id);
                            bool isLiked = currentVideo.likes.contains(
                              FirebaseAuth.instance.currentUser!.uid,
                            );

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.likeVideo(data.id),
                                  child: Icon(
                                    Icons.favorite,
                                    size: 38,
                                    color: isLiked ? Colors.red : Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${currentVideo.likes.length}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 20),

                          // --- COMMENT BUTTON (With Real-time Count) ---
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Comments fetch karna aur bottom sheet kholna
                                  controller.getComments(data.id);
                                  showCommentBottomSheet(
                                    context,
                                    data.id,
                                  ); // Niche function call ho raha hai
                                },
                                child: const Icon(
                                  Icons.comment,
                                  size: 38,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('videos')
                                    .doc(data.id)
                                    .collection('comments')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  // Agar comments nahi hain to 'Comment' text show karein
                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return const Text(
                                      "Comment",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    );
                                  }
                                  // Agar comments hain to number show karein
                                  return Text(
                                    "${snapshot.data!.docs.length}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // --- SHARE BUTTON ---
                          const Column(
                            children: [
                              Icon(Icons.share, size: 35, color: Colors.white),
                              const SizedBox(height: 5),
                              Text(
                                "Share",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //   right: 15,
                    //   bottom: 80,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       // --- PROFILE SECTION ---
                    //       GestureDetector(
                    //         onTap: () =>
                    //             Get.to(() => ProfileScreen(uid: data.uid)),
                    //         child: Stack(
                    //           clipBehavior: Clip.none,
                    //           children: [
                    //             Container(
                    //               padding: const EdgeInsets.all(1.5),
                    //               decoration: const BoxDecoration(
                    //                 color: Colors.white,
                    //                 shape: BoxShape.circle,
                    //               ),
                    //               child: CircleAvatar(
                    //                 radius: 25,
                    //                 backgroundImage: data.profilePic.isNotEmpty
                    //                     ? NetworkImage(data.profilePic)
                    //                     : null,
                    //                 child: data.profilePic.isEmpty
                    //                     ? Text(data.username[0].toUpperCase())
                    //                     : null,
                    //               ),
                    //             ),
                    //             StreamBuilder<bool>(
                    //               stream: controller.isFollowing(data.uid),
                    //               builder: (context, snapshot) {
                    //                 if (data.uid ==
                    //                         FirebaseAuth
                    //                             .instance
                    //                             .currentUser!
                    //                             .uid ||
                    //                     snapshot.data == true) {
                    //                   return const SizedBox.shrink();
                    //                 }
                    //                 return Positioned(
                    //                   bottom: -8,
                    //                   left: 18,
                    //                   child: GestureDetector(
                    //                     onTap: () =>
                    //                         controller.followUser(data.uid),
                    //                     child: Container(
                    //                       padding: const EdgeInsets.all(2),
                    //                       decoration: const BoxDecoration(
                    //                         color: Colors.red,
                    //                         shape: BoxShape.circle,
                    //                       ),
                    //                       child: const Icon(
                    //                         Icons.add,
                    //                         color: Colors.white,
                    //                         size: 16,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 );
                    //               },
                    //             ),
                    //           ],
                    //         ),
                    //       ),

                    //       const SizedBox(height: 25),

                    //       // --- LIKE BUTTON (Fixed with GetX Observable) ---
                    //       Obx(() {
                    //         // Hum pure Column ko Obx mein le rahe hain aur controller ki list se data check kar rahe hain
                    //         // Taake error "Improper use of GetX" khatam ho jaye
                    //         final currentVideo = controller.videoList
                    //             .firstWhere((v) => v.id == data.id);
                    //         bool isLiked = currentVideo.likes.contains(
                    //           FirebaseAuth.instance.currentUser!.uid,
                    //         );

                    //         return Column(
                    //           children: [
                    //             GestureDetector(
                    //               onTap: () => controller.likeVideo(data.id),
                    //               child: Icon(
                    //                 Icons.favorite,
                    //                 size: 38,
                    //                 color: isLiked ? Colors.red : Colors.white,
                    //               ),
                    //             ),
                    //             const SizedBox(height: 5),
                    //             Text(
                    //               "${currentVideo.likes.length}",
                    //               style: const TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 13,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ],
                    //         );
                    //       }),

                    //       const SizedBox(height: 20),

                    //       // --- COMMENT BUTTON ---
                    //       Column(
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               // Comments fetch karna shuru karein
                    //               controller.getComments(data.id);

                    //               showModalBottomSheet(
                    //                 context: context,
                    //                 isScrollControlled: true,
                    //                 backgroundColor: Colors.transparent,
                    //                 builder: (context) => Container(
                    //                   height:
                    //                       MediaQuery.of(context).size.height *
                    //                       0.7,
                    //                   decoration: const BoxDecoration(
                    //                     color: Color(
                    //                       0xFF121212,
                    //                     ), // Dark TikTok Theme
                    //                     borderRadius: BorderRadius.vertical(
                    //                       top: Radius.circular(20),
                    //                     ),
                    //                   ),
                    //                   child: Column(
                    //                     children: [
                    //                       const SizedBox(height: 12),
                    //                       const Text(
                    //                         "Comments",
                    //                         style: TextStyle(
                    //                           color: Colors.white,
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 15,
                    //                         ),
                    //                       ),
                    //                       const Divider(
                    //                         color: Colors.white12,
                    //                         thickness: 1,
                    //                       ),

                    //                       // --- COMMENTS LIST ---
                    //                       Expanded(
                    //                         child: Obx(() {
                    //                           return ListView.builder(
                    //                             itemCount:
                    //                                 controller.comments.length,
                    //                             itemBuilder: (context, index) {
                    //                               final comment = controller
                    //                                   .comments[index];
                    //                               return ListTile(
                    //                                 leading: CircleAvatar(
                    //                                   backgroundColor:
                    //                                       Colors.grey,
                    //                                   backgroundImage:
                    //                                       NetworkImage(
                    //                                         comment.profilePic,
                    //                                       ),
                    //                                 ),
                    //                                 title: Text(
                    //                                   comment.username,
                    //                                   style: const TextStyle(
                    //                                     color: Colors.white54,
                    //                                     fontSize: 13,
                    //                                     fontWeight:
                    //                                         FontWeight.bold,
                    //                                   ),
                    //                                 ),
                    //                                 subtitle: Text(
                    //                                   comment.comment,
                    //                                   style: const TextStyle(
                    //                                     color: Colors.white,
                    //                                     fontSize: 14,
                    //                                   ),
                    //                                 ),
                    //                               );
                    //                             },
                    //                           );
                    //                         }),
                    //                       ),

                    //                       const Divider(color: Colors.white12),

                    //                       // --- INPUT FIELD ---
                    //                       Padding(
                    //                         padding: EdgeInsets.only(
                    //                           bottom:
                    //                               MediaQuery.of(
                    //                                 context,
                    //                               ).viewInsets.bottom +
                    //                               10,
                    //                           left: 15,
                    //                           right: 15,
                    //                           top: 5,
                    //                         ),
                    //                         child: Row(
                    //                           children: [
                    //                             Expanded(
                    //                               child: TextField(
                    //                                 controller:
                    //                                     _commentController,
                    //                                 style: const TextStyle(
                    //                                   color: Colors.white,
                    //                                 ),
                    //                                 decoration: InputDecoration(
                    //                                   hintText:
                    //                                       "Add a comment...",
                    //                                   hintStyle: TextStyle(
                    //                                     color: Colors.white38,
                    //                                   ),
                    //                                   filled: true,
                    //                                   fillColor: Colors.white
                    //                                       .withOpacity(0.1),
                    //                                   contentPadding:
                    //                                       const EdgeInsets.symmetric(
                    //                                         horizontal: 20,
                    //                                         vertical: 10,
                    //                                       ),
                    //                                   border: OutlineInputBorder(
                    //                                     borderRadius:
                    //                                         BorderRadius.circular(
                    //                                           30,
                    //                                         ),
                    //                                     borderSide:
                    //                                         BorderSide.none,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                             IconButton(
                    //                               onPressed: () {
                    //                                 controller.postComment(
                    //                                   data.id,
                    //                                   _commentController.text,
                    //                                 );
                    //                                 _commentController.clear();
                    //                               },
                    //                               icon: const Icon(
                    //                                 Icons.send,
                    //                                 color: Colors.blueAccent,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //             child: Column(
                    //               children: [
                    //                 const Icon(
                    //                   Icons.comment,
                    //                   size: 38,
                    //                   color: Colors.white,
                    //                 ),
                    //                 const SizedBox(height: 5),
                    //                 // Real-time comment count (Optional: Iske liye ek aur stream chahiye hogi)
                    //                 const Text(
                    //                   "View",
                    //                   style: TextStyle(
                    //                     color: Colors.white,
                    //                     fontSize: 12,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           SizedBox(height: 5),
                    //           Text(
                    //             "0",
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 13,
                    //             ),
                    //           ),
                    //         ],
                    //       ),

                    //       const SizedBox(height: 20),

                    //       // --- SHARE BUTTON ---
                    //       const Column(
                    //         children: [
                    //           Icon(Icons.share, size: 35, color: Colors.white),
                    //           SizedBox(height: 5),
                    //           Text(
                    //             "Share",
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontSize: 13,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // 3. Bottom Left Overlay (Username aur Caption)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => ProfileScreen(
                                  uid: data.uid,
                                ), // Ab 'uid' define ho chuka hai
                                transition: Transition.rightToLeft,
                              );
                            },
                            child: Text(
                              "@${data.username}", // Dynamic Username
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            data.caption, // Dynamic Caption
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },

              // itemBuilder: (context, index) {
              //   final data = controller.videoList[index];
              //   return Stack(
              //     children: [
              //       // Actual Video Player
              //       VideoPlayerItem(videoUrl: data.videoUrl),

              //       // Caption aur Username overlay (Optional)
              //       Positioned(
              //         bottom: 20,
              //         left: 20,
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "@${data.username}",
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             Text(
              //               data.caption,
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   );
              // },
            ),
          ),

          // 2. Top Bar (Tabs & Upload)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // UPLOAD BUTTON
                IconButton(
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => controller.pickVideo(),
                ),
                const SizedBox(width: 20),
                // TABS
                Text(
                  "Following",
                  style: TextStyle(color: Colors.white60, fontSize: 17),
                ),
                const SizedBox(width: 15),
                Text("|", style: TextStyle(color: Colors.white30)),
                const SizedBox(width: 15),
                Text(
                  "For You",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(width: 50), // Balance ke liye
              ],
            ),
          ),
        ],
      ),
    );
  }
}
