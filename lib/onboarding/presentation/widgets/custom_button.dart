import 'package:flutter/material.dart';

class CustomNextButton extends StatelessWidget {
  final VoidCallback onTap;

  const CustomNextButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xff00D9E8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_forward_ios,
            color: Color(0xff1F1D2B),
            size: 18,
          ),
        ),
      ),
    );
  }
}