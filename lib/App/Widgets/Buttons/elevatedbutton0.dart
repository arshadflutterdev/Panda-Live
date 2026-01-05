import 'package:flutter/material.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class MyElevatedButton extends StatelessWidget {
  final String btext;
  final VoidCallback onPressed;
  const MyElevatedButton({
    super.key,
    required this.width,
    required this.btext,
    required this.onPressed,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColours.blues,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        fixedSize: Size(width * 0.60, 45),
      ),
      onPressed: onPressed,
      child: Text(btext, style: AppStyle.btext.copyWith(color: Colors.white)),
    );
  }
}
