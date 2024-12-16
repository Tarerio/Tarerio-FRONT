import 'package:flutter/material.dart';

class ConfirmationModal extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onAccept;

  const ConfirmationModal({
    super.key,
    required this.title,
    required this.content,
    required this.onAccept,
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
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Text(
              '¿Estás seguro de que deseas realizar esta acción?',
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Aceptar'),
          onPressed: () {
            onAccept();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
