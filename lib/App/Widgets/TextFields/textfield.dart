import 'package:flutter/material.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';

class MyTextFormField extends StatelessWidget {
  final String hintext;
  final Icon? prefix;
  final Icon? suffix;
  final TextInputType keyboard;
  final FormFieldValidator? validator;
  final TextEditingController? controller;
  const MyTextFormField({
    super.key,
    required this.keyboard,
    this.validator,
    required this.hintext,
    this.prefix,
    this.suffix,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboard,
      validator: validator,
      cursorColor: AppColours.blues,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffix,
        prefixIcon: prefix,

        hint: Text(
          hintext,
          style: TextStyle(fontSize: 16, color: Colors.black54),
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
