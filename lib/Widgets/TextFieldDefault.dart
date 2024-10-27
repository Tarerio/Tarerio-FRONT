import 'package:flutter/material.dart';

class TextFieldDefault extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color labelColor;
  final double labelFontSize;
  final double width;
  final EdgeInsets padding;
  final bool obscureText;

  const TextFieldDefault({
    Key? key,
    required this.label,
    required this.controller,
    this.labelColor = Colors.black,
    this.labelFontSize = 30.0,
    this.width = 350.0,
    this.padding = EdgeInsets.zero,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: Text(
            label,
            style: TextStyle(
              fontSize: labelFontSize,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
        ),
        Padding(
          padding: padding,
          child: SizedBox(
            width: width,
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
