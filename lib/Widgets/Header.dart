import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String nickname;
  final String? imageUrl;

  const Header({
    super.key,
    required this.nickname,
    this.imageUrl,
  });

  Color _getColorFromInitial(String initial) {
    final int hash = initial.codeUnitAt(0);
    final int colorIndex = hash % Colors.primaries.length;
    return Colors.primaries[colorIndex];
  }


  @override
  Widget build(BuildContext context) {
    String initial = nickname.isNotEmpty ? nickname[0].toUpperCase() : 'U';
    Color avatarColor = _getColorFromInitial(initial);

    return AppBar(
      automaticallyImplyLeading: false, // Quita la flecha de volver atrás
      toolbarHeight: 100, // Adjust the height of the AppBar
      elevation: 4,
      shadowColor: Colors.black,
      title: Row(
        children: [
          // User image or initial with background color
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: imageUrl != null
                ? ClipOval(
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            )
                : CircleAvatar(
              radius: 30,
              backgroundColor: avatarColor,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Title of the AppBar
          Text(
            nickname,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(), // Pushes the menu icon to the right
          TextButton.icon(
            icon: const Icon(Icons.menu_book, size: 40, color: Colors.black),
            label: const Text(
              'Menú',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100); // Define the size of the AppBar
}