import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather/models/message.dart';

class ChatService {
  //instance of firestore and auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  /*
  list<map<string,dynamic>>
{
  'email': test@gmail.com,
  'id': ..
}
]
  */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each individual user
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String recieverID, message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    // create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: recieverID,
        message: message,
        timestamp: timestamp);
    // construct chat room id
    List<String> ids = [currentUserID, recieverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    //add mssg to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("message")
        .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct a chatroom id
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("message")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
