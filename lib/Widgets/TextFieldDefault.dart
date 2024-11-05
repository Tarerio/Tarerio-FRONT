import 'package:flutter/material.dart';
import 'package:tarerio/Widgets/InformationModal.dart';

class TextFieldDefault extends StatelessWidget {
  final String label, titleInformation, textInformation;
  final TextEditingController controller;
  final Color labelColor;
  final double labelFontSize;
  final double width;
  final EdgeInsets padding;
  final bool obscureText;
  final bool information;

  const TextFieldDefault({
    Key? key,
    required this.label,
    required this.controller,
    this.labelColor = Colors.black,
    this.labelFontSize = 30.0,
    this.width = 350.0,
    this.padding = EdgeInsets.zero,
    this.obscureText = false,
    this.information = false,
    this.titleInformation = '',
    this.textInformation = '',
  }) : super(key: key);

  void _showInformationModal(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InformationModal(title: title, content: content);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
            if (information)
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 12.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.help,
                    size: 30.0,
                    color: Color(0xFF2EC4B6),
                  ),
                  onPressed: () {
                    _showInformationModal(
                        context, titleInformation, textInformation);
                  },
                ),
              ),
          ],
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
