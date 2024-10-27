import 'package:flutter/material.dart';

class DefaultSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color activeTrackColor;

  const DefaultSwitch({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.white,
    this.activeTrackColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Switch(
          value: value,
          activeColor: activeColor,
          activeTrackColor: activeTrackColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
