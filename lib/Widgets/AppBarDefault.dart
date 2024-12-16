import 'package:flutter/material.dart';

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color titleColor;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final Color iconColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions; // Añadir este parámetro

  const AppBarDefault({
    super.key,
    required this.title,
    required this.titleColor,
    required this.iconColor,
    this.titleFontSize = 28.0,
    this.titleFontWeight = FontWeight.w600,
    this.iconSize = 28.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.onBackPressed,
    this.actions, // Añadir este parámetro al constructor
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 100.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: iconSize,
          color: iconColor,
        ),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: titleFontSize,
          fontWeight: titleFontWeight,
        ),
      ),
      actions: actions, // Agregar las acciones aquí
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
