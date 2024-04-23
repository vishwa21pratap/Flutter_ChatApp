import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/themes/theme_provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    // light vs dark mode
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isCurrentUser
              ? Color.fromARGB(255, 224, 235, 248)
              : isDarkMode
                  ? Colors.grey.shade400
                  : Colors.grey.shade200),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
