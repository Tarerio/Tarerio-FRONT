import 'package:flutter/material.dart';

class SuccessModal extends StatelessWidget {
  final String title;
  final String content;

  const SuccessModal({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.check, size: 50, color: Colors.green),
      title: Text(title, style: const TextStyle(fontSize: 30, color: Colors.green)),
      content: Text(content, style: const TextStyle(fontSize: 20)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('De acuerdo', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}
