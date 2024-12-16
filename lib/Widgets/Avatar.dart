import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String base64Image;
  final double radius;
  final Color backgroundColor;
  final Icon placeholderIcon;
  final double size;
  final VoidCallback? onClear;
  final double borderWidth;
  final Color borderColor;

  const Avatar({
    super.key,
    this.base64Image = '',
    this.radius = 50.0,
    this.size = 150.0,
    this.backgroundColor = const Color(0xFFB0BEC5),
    Icon? placeholderIcon,
    this.onClear,
    this.borderWidth = 0.5,
    this.borderColor = Colors.black,
  }) : placeholderIcon = placeholderIcon ??
            const Icon(Icons.person, size: 150.0, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: radius * 2 + borderWidth,
          height: radius * 2 + borderWidth,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            onBackgroundImageError: (exception, stackTrace) {},
            backgroundImage: MemoryImage(base64Decode(base64Image)),
            child: base64Image == ''
                ? Icon(
                    placeholderIcon.icon,
                    size: size,
                    color: placeholderIcon.color,
                  )
                : null,
          ),
        ),
        if (base64Image != '')
          IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.red,
              size: 24.0,
            ),
            onPressed: onClear,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }
}
