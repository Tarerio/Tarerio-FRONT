import 'package:flutter/material.dart';

class InformationModal extends StatelessWidget {
  final String title;
  final String content;

  const InformationModal({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 30.0,
          color: Color(0xFF2EC4B6),
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(
          fontSize: 20.0,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'De acuerdo',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    );
  }
}
