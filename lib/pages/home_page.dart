import 'package:flutter/material.dart';
import 'package:weather/components/my_drawer.dart';
import 'package:weather/components/user_tile.dart';
import 'package:weather/pages/chat_page.dart';
import 'package:weather/services/auth/auth_service.dart';
import 'package:weather/services/auth/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => FutureBuilder<String>(
                    future: _chatService.getLastMessage(
                      _authService.getCurrentUser()!.uid,
                      userData["uid"],
                    ),
                    builder: (context, lastMessageSnapshot) {
                      if (lastMessageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Text("Loading..");
                      }
                      if (lastMessageSnapshot.hasError) {
                        return const Text("Error");
                      }
                      final lastMessage =
                          lastMessageSnapshot.data ?? "No messages yet";

                      return _buildUserListItem(userData, lastMessage, context);
                    },
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, String lastMessage, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        lastMessage: lastMessage,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
