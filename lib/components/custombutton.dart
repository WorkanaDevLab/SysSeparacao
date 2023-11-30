import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final Color color;
  final bool outlined;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.color,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: outlined
            ? BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(15),
        )
            : BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
                color: outlined ? color : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Satoshi'
            ),
          ),
        ),
      ),
    );
  }
}