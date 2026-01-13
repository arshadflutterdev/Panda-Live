import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  TextEditingController searchController = TextEditingController();

  bool get isArabic => Get.locale?.languageCode == "ar";

  final List<Map<String, dynamic>> updatesList = [
    {
      "icon": Icons.notifications,
      "color": Colors.orange,
      "title_en": "Official Announcement",
      "title_ar": "إعلان رسمي",
      "desc_en": "Live cover new review rules...",
      "desc_ar": "قواعد مراجعة جديدة للبث المباشر...",
      "date": "01/08",
    },
    {
      "icon": Icons.attach_money,
      "color": Colors.green,
      "title_en": "Income Reminder",
      "title_ar": "تذكير بالدخل",
      "desc_en": "Congratulations for completing...",
      "desc_ar": "تهانينا على إكمال...",
      "date": "01/10",
    },
    {
      "icon": Icons.security,
      "color": Colors.red,
      "title_en": "Account Security Center",
      "title_ar": "مركز أمان الحساب",
      "desc_en": "Your account has been logged...",
      "desc_ar": "تم تسجيل الدخول إلى حسابك...",
      "date": "01/06",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          isArabic ? "التحديثات الرسمية" : "Official Updates",
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 0.5,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Image(image: AssetImage(AppImages.settings), height: 28),
                onPressed: () {
                  Get.toNamed(AppRoutes.language);
                },
              ),
              IconButton(
                icon: const Icon(Icons.search, size: 26),
                onPressed: _openSearchDialog,
              ),
            ],
          ),
        ],
      ),

      /// 🔔 Updates List
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: updatesList.length,
        itemBuilder: (context, index) {
          final item = updatesList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Icon
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: item["color"],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item["icon"], color: Colors.white, size: 26),
                ),
                const SizedBox(width: 12),

                /// Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              isArabic ? item["title_ar"] : item["title_en"],
                              style: isArabic
                                  ? AppStyle.arabictext.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isArabic ? "رسمي" : "Official",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isArabic ? item["desc_ar"] : item["desc_en"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["date"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔍 Search Dialog
  void _openSearchDialog() {
    Get.defaultDialog(
      title: isArabic ? "ابحث عن التحديثات" : "Search Updates",
      titleStyle: isArabic
          ? AppStyle.arabictext.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          : const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      content: MyTextFormField(
        controller: searchController,
        keyboard: TextInputType.text,
        hintext: isArabic ? "اكتب للتحديث..." : "Type to search updates...",
      ),
      cancel: TextButton(
        onPressed: () => searchController.clear(),
        child: Text(
          isArabic ? "بحث" : "Search",
          style: TextStyle(
            fontSize: 16,
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      confirm: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          isArabic ? "إلغاء" : "Cancel",
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
