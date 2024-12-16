import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Color? colorText;
  final double? fontSize;
  final VoidCallback onPressed;
  final Color color;
  final double width;
  final double height;
  final bool upperCase;

  const DefaultButton({
    super.key,
    required this.text,
    this.colorText,
    this.fontSize,
    required this.onPressed,
    required this.color,
    this.width = 200,
    this.height = 40,
    this.upperCase = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          backgroundColor: color,
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            upperCase ? text.toUpperCase() : text,
            style: TextStyle(
              fontSize: fontSize ?? 20,
              color: colorText,
            ),
          ),
        ),
      ),
    );
  }
}
