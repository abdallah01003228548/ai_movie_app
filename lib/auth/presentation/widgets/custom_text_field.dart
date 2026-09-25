import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.suffixIcon,
  });

  String label;
  TextEditingController controller;
  IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'Montserrat',
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontFamily: 'Montserrat',
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w900,
          fontFamily: 'Montserrat',
        ),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.grey, size: 20)
            : null,
        filled: true,
        fillColor: Color(0xFF1F1D2B),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20, 
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Color(0xff252836), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Color(0xff252836), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Color(0xff252836), width: 1),
        ),
      ),
    );
  }
}