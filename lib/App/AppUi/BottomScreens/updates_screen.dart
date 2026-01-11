import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Official Updates",
          style: TextStyle(fontSize: 22, letterSpacing: 1, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: isArabic ? "ابحث عن التحديثات" : "Search Updates",
                titleStyle: isArabic
                    ? AppStyle.arabictext.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                    : const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                content: MyTextFormField(
                  controller: searchController,
                  keyboard: TextInputType.text,
                  hintext: isArabic
                      ? "اكتب للتحديث.."
                      : "Type to search updates...",
                ),
                cancel: TextButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  child: Text(
                    isArabic ? "بحث" : "Search",
                    style: isArabic
                        ? AppStyle.arabictext.copyWith(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          )
                        : const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                  ),
                ),
                confirm: TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    isArabic ? "إلغاء" : "Cancel",
                    style: isArabic
                        ? AppStyle.arabictext.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          )
                        : const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.search, size: 26),
          ),
        ],
      ),
    );
  }
}
