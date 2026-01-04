import 'package:flutter/material.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: AppColours.blues,

      decoration: InputDecoration(
        suffixIcon: Icon(Icons.close),
        prefixIcon: Icon(Icons.close),
        hint: Text(
          "Arshad",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),

        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(20),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColours.blues),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
