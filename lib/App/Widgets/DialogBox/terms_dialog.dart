import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class TermsDialog extends StatelessWidget {
  final VoidCallback onAccept;
  const TermsDialog({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        height: height * 0.23,
        width: width * 0.10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Gap(5),
            Text("Terms of service", style: AppStyle.tagline),

            Text("User_agreement_contant"),
            TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.terms);
              },
              child: FittedBox(
                child: Text(
                  "Panda Live terms of services",
                  style: AppStyle.btext,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: FittedBox(
                    child: Text(
                      "Cancel",
                      style: AppStyle.btext.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onAccept,
                  child: FittedBox(
                    child: Text("Accept", style: AppStyle.btext),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
