import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomeTextField extends StatelessWidget {
  CustomeTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });
  String? hintText;
  bool?  obscureText;
  TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child:  Padding(
          padding:const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller:controller ,
            obscureText:obscureText! ,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
