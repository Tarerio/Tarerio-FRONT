import 'dart:io';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final File? image;
  final double radius;
  final Color backgroundColor;
  final Icon placeholderIcon;
  final double size;
  final VoidCallback? onClear;
  final double borderWidth;
  final Color borderColor;

  const Avatar({
    Key? key,
    this.image,
    this.radius = 50.0,
    this.size = 150.0,
    this.backgroundColor = const Color(0xFFB0BEC5),
    Icon? placeholderIcon,
    this.onClear,
    this.borderWidth = 0.5,
    this.borderColor = Colors.black,
  })  : placeholderIcon = placeholderIcon ??
            const Icon(Icons.person, size: 150.0, color: Colors.white),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: radius * 2 +
              borderWidth,
          height: radius * 2 +
              borderWidth,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: CircleAvatar(
            radius: radius, 
            backgroundColor: backgroundColor,
            backgroundImage: image != null ? FileImage(image!) : null,
            child: image == null
                ? Icon(
                    placeholderIcon.icon,
                    size: size, 
                    color: placeholderIcon.color,
                  )
                : null,
          ),
        ),
        if (image != null)
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
