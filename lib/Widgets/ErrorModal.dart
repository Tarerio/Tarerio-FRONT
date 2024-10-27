import 'package:flutter/material.dart';

class ErrorModal extends StatelessWidget {
  final String title;
  final String content;

  const ErrorModal({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.error, size: 50, color: Colors.red),
      title:
          Text(title, style: const TextStyle(fontSize: 30, color: Colors.red)),
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
