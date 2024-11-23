import 'package:flutter/material.dart';

class KundaliImageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;

  KundaliImageButton({
    required this.onPressed,
    this.width = 150,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        'assets/kundali.png', // Ensure this path is correct
        width: width,
        height: height,
      ),
    );
  }
}

class AshtakootMilanImageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;

  AshtakootMilanImageButton({
    required this.onPressed,
    this.width = 150,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        'assets/kundali_icon.png', // Ensure this path is correct
        width: width,
        height: height,
      ),
    );
  }
}
