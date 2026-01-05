import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';

class MyTextFormField extends StatelessWidget {
  final String hintext;
  final Icon? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputformat;
  final TextInputType keyboard;
  final FormFieldValidator? validator;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const MyTextFormField({
    super.key,
    this.onChanged,

    this.inputformat,
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
      onChanged: onChanged,

      keyboardType: keyboard,
      validator: validator,
      inputFormatters: inputformat,

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
