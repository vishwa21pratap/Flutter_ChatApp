import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:weather/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Future<void> sendPDF(String receiverID, File pdfFile) async {
    try {
      if (!pdfFile.existsSync()) {
        throw Exception("File does not exist at path: ${pdfFile.path}");
      }

      final String currentUserID = _auth.currentUser!.uid;
      final String currentUserEmail = _auth.currentUser!.email!;
      final Timestamp timestamp = Timestamp.now();

      String fileName =
          '${currentUserID}_${timestamp.millisecondsSinceEpoch}.pdf';
      Reference storageRef = _storage.ref().child('pdfs').child(fileName);

      UploadTask uploadTask = storageRef.putFile(pdfFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      String pdfURL = await taskSnapshot.ref.getDownloadURL();
      print('PDF uploaded successfully. URL: $pdfURL');

      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: 'Sent a PDF',
        fileUrl: pdfURL,
        timestamp: timestamp,
      );

      List<String> ids = [currentUserID, receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add(newMessage.toMap());
    } catch (e) {
      print('Error uploading PDF: $e');
      throw e; // Re-throw the error to handle it in the calling function
    }
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<String> getLastMessage(String senderID, String receiverID) async {
    try {
      List<String> ids = [senderID, receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      QuerySnapshot querySnapshot = await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first["message"];
      } else {
        return "No messages yet";
      }
    } catch (e) {
      print('Error fetching last message: $e');
      throw e; // Re-throw the error to handle it in the calling function
    }
  }
}
