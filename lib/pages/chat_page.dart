import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weather/components/chat_bubble.dart';
import 'package:weather/components/my_textfield.dart';
import 'package:weather/services/auth/auth_service.dart';
import 'package:weather/services/auth/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;

  ChatPage({
    super.key,
    required this.recieverEmail,
    required this.recieverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text congtroller
  final TextEditingController _messageController = TextEditingController();

  //chat and auth
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  //for textfield focus

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay for keyboard pop up
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    //scroll down auto
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //send message
  void sendMessage() async {
    //send only if msg in not null
    if (_messageController.text.isNotEmpty) {
      //send
      await _chatService.sendMessage(
          widget.recieverID, _messageController.text);
      // clear text controller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recieverEmail),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 223, 245, 245),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          //display the message
          Expanded(
            child: _buildMessageList(),
          ),
          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recieverID, senderID),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text("Error");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        // return list
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    //align message to right and left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      margin: EdgeInsets.symmetric(vertical: 2.0), // Add vertical margin
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal padding
            child: ChatBubble(
                isCurrentUser: isCurrentUser, message: data["message"]),
          ),
        ],
      ),
    );
  }

  //build msg input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type Your Message Here..",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          //send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
