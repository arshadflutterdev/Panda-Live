import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/main_profile_screen.dart';
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
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.comments.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    itemBuilder: (context, index) {
                      final comment = controller.comments[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Profile Picture
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(comment.profilePic),
                            ),
                            const SizedBox(width: 12),

                            // 2. Comment Content & Replies
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Username
                                  Text(
                                    comment.username,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Comment Text
                                  Text(
                                    comment.comment,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Time & Reply Action
                                  Row(
                                    children: [
                                      const Text(
                                        "Just now",
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      GestureDetector(
                                        onTap: () {
                                          controller.selectedCommentId.value =
                                              comment
                                                  .id; // Comment ID set karein
                                          controller.replyingToUser.value =
                                              comment.username;
                                          _commentController.text =
                                              "@${comment.username} "; // Tag sirf dikhane ke liye
                                          FocusScope.of(context).requestFocus(
                                            FocusNode(),
                                          ); // Keyboard open karne ke liye
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

                                  // --- REPLIES SECTION ---
                                  StreamBuilder<QuerySnapshot>(
                                    stream: controller.getReplies(
                                      videoId,
                                      comment.id,
                                    ),
                                    builder: (context, replySnap) {
                                      if (!replySnap.hasData ||
                                          replySnap.data!.docs.isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent,
                                        ),
                                        child: ExpansionTile(
                                          tilePadding: EdgeInsets.zero,
                                          iconColor: Colors.white38,
                                          collapsedIconColor: Colors.white38,
                                          title: Text(
                                            "View ${replySnap.data!.docs.length} replies",
                                            style: const TextStyle(
                                              color: Colors.white38,
                                              fontSize: 12,
                                            ),
                                          ),
                                          children: replySnap.data!.docs.map((
                                            doc,
                                          ) {
                                            var replyData =
                                                doc.data()
                                                    as Map<String, dynamic>;
                                            String replyId =
                                                doc.id; // Har reply ki apni ID
                                            List replyLikes =
                                                replyData['likes'] ?? [];

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                left: 40,
                                                bottom: 12,
                                                right: 10,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage: NetworkImage(
                                                      replyData['profilePic'] ??
                                                          '',
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          replyData['username'],
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white54,
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          replyData['reply'],
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 13,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            // Reply ke andar reply ke liye tag set karein
                                                            controller
                                                                .selectedCommentId
                                                                .value = comment
                                                                .id;
                                                            controller
                                                                    .replyingToUser
                                                                    .value =
                                                                replyData['username'];
                                                            _commentController
                                                                    .text =
                                                                "@${replyData['username']} ";
                                                          },
                                                          child: const Text(
                                                            "Reply",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white38,
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // --- Reply Like Button ---
                                                  Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () => controller
                                                            .likeReply(
                                                              videoId,
                                                              comment.id,
                                                              replyId,
                                                            ),
                                                        child: Icon(
                                                          replyLikes.contains(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                              )
                                                              ? Icons.favorite
                                                              : Icons
                                                                    .favorite_border,
                                                          size:
                                                              14, // Replies ke liye icons thode chote
                                                          color:
                                                              replyLikes.contains(
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid,
                                                              )
                                                              ? Colors.red
                                                              : Colors.white38,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${replyLikes.length}",
                                                        style: const TextStyle(
                                                          color: Colors.white38,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // 3. Like Section (Right Side)
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.likeComment(
                                    videoId,
                                    comment.id,
                                  ),
                                  child: Icon(
                                    comment.likes.contains(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                        )
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20,
                                    color:
                                        comment.likes.contains(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                        )
                                        ? Colors.red
                                        : Colors.white38,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${comment.likes.length}",
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
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
      extendBody: true, // <--- Ye bottom bar ka gap khatam karega
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Main Video PageView
          Obx(() {
            // --- Empty Following List Check ---
            if (controller.isForYou.value == false &&
                controller.videoList.isEmpty) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_add_alt_1_outlined,
                        color: Colors.white54,
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Follow someone to see videos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          controller.isForYou.value = true;
                          controller.getAllVideos();
                        },
                        child: const Text(
                          "Explore For You",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // --- Aapka Original PageView Builder ---
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.videoList.length,
              itemBuilder: (context, index) {
                final data =
                    controller.videoList[index]; // Firebase se aane wala data

                return Stack(
                  children: [
                    // 1. Actual Video Player
                    VideoPlayerItem(
                      videoUrl: data.videoUrl,
                      videoId: data.id, // <--- Ye lazmi pass
                      filterMatrix: data.filterMatrix,
                    ),
                    // Home Screen ke Stack mein kahi bhi add kar dein
                    Obx(() {
                      final controller = Get.find<ReelsController>();
                      if (controller.isLoading.value) {
                        return Positioned(
                          top: 50,
                          right: 20,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: controller.uploadProgress.value,
                                color: Colors.white,
                                backgroundColor: Colors.white24,
                              ),
                              Text(
                                "${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // 2. Right Side Profile/User Section (TikTok Style)
                    Positioned(
                      right: 15,
                      bottom: 45,
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

                          const SizedBox(height: 15),

                          // --- LIKE BUTTON ---
                          Obx(() {
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

                          const SizedBox(height: 5),

                          // --- COMMENT BUTTON ---
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.getComments(data.id);
                                  showCommentBottomSheet(context, data.id);
                                },
                                child: const Icon(
                                  Icons.comment,
                                  size: 38,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Obx(() {
                                final currentVideo = controller.videoList
                                    .firstWhere((v) => v.id == data.id);
                                return Text(
                                  "${currentVideo.commentCount ?? 0}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                );
                              }),
                            ],
                          ),

                          // --- SAVE (FAVORITE) BUTTON ---
                          StreamBuilder<int>(
                            stream: controller.getTotalSaveCount(data.id),
                            builder: (context, countSnapshot) {
                              int count = countSnapshot.data ?? 0;
                              return StreamBuilder<bool>(
                                stream: controller.isFavorite(data.id),
                                builder: (context, favSnapshot) {
                                  bool isFav = favSnapshot.data ?? false;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          controller.toggleFavorite(
                                            data.id,
                                            data.toJson(),
                                          );
                                        },
                                        icon: Icon(
                                          isFav
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          color: isFav
                                              ? Colors.amber
                                              : Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                      Text(
                                        count > 0 ? "$count" : "Save",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 10),

                          // --- DIRECT DOWNLOAD BUTTON (For All Videos) ---
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () => controller.downloadVideo(
                                  data.videoUrl,
                                  data.id,
                                ),
                                child: const Icon(
                                  Icons.download_for_offline_outlined,
                                  size: 38,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Download",
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

                    //       // --- LIKE BUTTON (Fixed with GetX Obx) ---
                    //       Obx(() {
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

                    //       // --- COMMENT BUTTON (With Real-time Count) ---
                    //       Column(
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               controller.getComments(data.id);
                    //               showCommentBottomSheet(context, data.id);
                    //             },
                    //             child: const Icon(
                    //               Icons.comment,
                    //               size: 38,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //           const SizedBox(height: 5),
                    //           Obx(() {
                    //             final currentVideo = controller.videoList
                    //                 .firstWhere((v) => v.id == data.id);
                    //             return Text(
                    //               "${currentVideo.commentCount ?? 0}",
                    //               style: const TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 13,
                    //               ),
                    //             );
                    //           }),
                    //         ],
                    //       ),

                    //       const SizedBox(height: 20),

                    //       StreamBuilder<int>(
                    //         stream: Get.find<ReelsController>()
                    //             .getTotalSaveCount(data.id),
                    //         builder: (context, countSnapshot) {
                    //           int count = countSnapshot.data ?? 0;

                    //           return StreamBuilder<bool>(
                    //             stream: Get.find<ReelsController>().isFavorite(
                    //               data.id,
                    //             ),
                    //             builder: (context, favSnapshot) {
                    //               bool isFav = favSnapshot.data ?? false;

                    //               return Column(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: [
                    //                   IconButton(
                    //                     onPressed: () {
                    //                       Get.find<ReelsController>()
                    //                           .toggleFavorite(
                    //                             data.id,
                    //                             data.toJson(),
                    //                           );
                    //                     },
                    //                     icon: Icon(
                    //                       isFav
                    //                           ? Icons.bookmark
                    //                           : Icons.bookmark_border,
                    //                       color: isFav
                    //                           ? Colors.amber
                    //                           : Colors.white,
                    //                       size: 35,
                    //                     ),
                    //                   ),
                    //                   Text(
                    //                     count > 0 ? "$count" : "Save",
                    //                     style: const TextStyle(
                    //                       color: Colors.white,
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.bold,
                    //                       shadows: [
                    //                         Shadow(
                    //                           blurRadius: 4.0,
                    //                           color: Colors.black,
                    //                           offset: Offset(1.0, 1.0),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               );
                    //             },
                    //           );
                    //         },
                    //       ),

                    //       // --- SHARE BUTTON ---
                    //       // Share button ko hata kar ye lagayein
                    //       const SizedBox(height: 20),

                    //       if (data.uid !=
                    //           FirebaseAuth.instance.currentUser!.uid)
                    //         _buildActionItem(
                    //           icon: Icons.download_for_offline_outlined,
                    //           label: "Download",
                    //           onTap: () => reelsController.downloadVideo(
                    //             data.videoUrl,
                    //             data.id,
                    //           ),
                    //         )
                    //       else
                    //         _buildActionItem(
                    //           icon: Icons.more_horiz,
                    //           label: "More",
                    //           onTap: () => _showOptionsBottomSheet(
                    //             context,
                    //             data,
                    //             reelsController,
                    //           ),
                    //         ),
                    //       // const Column(
                    //       //   children: [
                    //       //     Icon(Icons.share, size: 35, color: Colors.white),
                    //       //     SizedBox(height: 5),
                    //       //     Text(
                    //       //       "Share",
                    //       //       style: TextStyle(
                    //       //         color: Colors.white,
                    //       //         fontSize: 13,
                    //       //       ),
                    //       //     ),
                    //       //   ],
                    //       // ),

                    //     ],
                    //   ),
                    // ),
                    // User Info Section (Positioned widget jahan caption hai)
                    Positioned(
                      bottom: 20,
                      left: 15,
                      right: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "@${data.username}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data.caption,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                          ),

                          // --- TIKTOK STYLE DOWNLOAD PROGRESS ---
                          Obx(() {
                            if (controller.isDownloading.value) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    // Progress Line
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value:
                                              controller.downloadProgress.value,
                                          backgroundColor: Colors.white24,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(Colors.white),
                                          minHeight: 3, // Bilkul bariki line
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Cancel Text Button
                                    GestureDetector(
                                      onTap: () => controller.cancelDownload(),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ),

                    // Positioned(
                    //   bottom: 20,
                    //   left: 20,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       GestureDetector(
                    //         onTap: () {
                    //           Get.to(
                    //             () => ProfileScreen(uid: data.uid),
                    //             transition: Transition.rightToLeft,
                    //           );
                    //         },
                    //         child: Text(
                    //           "@${data.username}",
                    //           style: const TextStyle(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 16,
                    //           ),
                    //         ),
                    //       ),
                    //       Text(
                    //         data.caption,
                    //         style: const TextStyle(color: Colors.white),
                    //       ),
                    //       Obx(() {
                    //         final currentVideo = controller.videoList
                    //             .firstWhere((v) => v.id == data.id);
                    //         return Row(
                    //           children: [
                    //             const Icon(
                    //               Icons.play_arrow_outlined,
                    //               size: 25,
                    //               color: Colors.white,
                    //             ),
                    //             Text(
                    //               "${currentVideo.views.length}",
                    //               style: const TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         );
                    //       }),

                    //     ],
                    //   ),
                    // ),
                  ],
                );
              },
            );
          }),

          // 2. Top Bar (Tabs & Upload)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // UPLOAD BUTTON (Vesa hi hai jesa aapne manga)
                IconButton(
                  icon: const Icon(
                    Icons.add_box_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => controller.pickVideo(),
                ),

                const SizedBox(width: 20),

                // TABS (Ab clickable aur reactive hain)
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.isForYou.value = false;
                      controller.getFollowingVideos(); // Following logic call
                    },
                    child: Text(
                      "Following",
                      style: TextStyle(
                        color: !controller.isForYou.value
                            ? Colors.white
                            : Colors.white60,
                        fontSize: 17,
                        fontWeight: !controller.isForYou.value
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),
                const Text("|", style: TextStyle(color: Colors.white30)),
                const SizedBox(width: 15),

                Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.isForYou.value = true;
                      controller.getAllVideos(); // For You (All Videos) call
                    },
                    child: Text(
                      "For You",
                      style: TextStyle(
                        color: controller.isForYou.value
                            ? Colors.white
                            : Colors.white60,
                        fontSize: 17,
                        fontWeight: controller.isForYou.value
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
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
