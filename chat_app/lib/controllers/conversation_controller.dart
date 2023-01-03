import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationController {
  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection('conversations');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final String? uid;

  ConversationController({this.uid});

  // Create Conversation
  Future createConversation(conversationName, friendId) async {
    DocumentReference conversation = await conversationCollection.add({
      'conversation_id': '',
      'conversation_name': conversationName,
      'creator_id': uid,
      'friend_id': friendId,
      'members': [],
      'recent_message': '',
      'recent_sender': '',
      'created_at': '',
    });

    // Update conversation members and ic
    await conversation.update({
      'members': FieldValue.arrayUnion(["$uid", friendId]),
      'conversation_id': conversation.id,
    });

    // Update user's conversation List
    DocumentReference userDocumentReference = userCollection.doc(uid);
    await userDocumentReference.update({
      "conversations": FieldValue.arrayUnion([(conversation.id)]),
    });

    // Update friend conversation list
    DocumentReference friendDocumentReference = userCollection.doc(friendId);
    await friendDocumentReference.update({
      "conversations": FieldValue.arrayUnion([(conversation.id)]),
    });
  }

  // Read Conversation
  Stream<List<Map<String, dynamic>>> readConversations() {
    final conversations = FirebaseFirestore.instance
        .collection('conversations')
        .where('members'.allMatches(FirebaseAuth.instance.currentUser!.uid).toString())

        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

    return conversations;
  }

  // Send Message
  sendMessage(conversationId, Map<String, dynamic> chatMessageData) async {
    conversationCollection
        .doc(conversationId)
        .collection('message')
        .add(chatMessageData);
    conversationCollection.doc(conversationId).update({
      "recent_message": chatMessageData['message'],
      "recent_sender": chatMessageData['sender'],
      "created_at": chatMessageData['created_at'].toString(),
    });
  }

  // read message
  readMessage(conversationId) async {
    return conversationCollection
        .doc(conversationId)
        .collection('message')
        .orderBy('created_at')
        .snapshots();
  }
}
