import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserController {
  final auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Create user
  Future userInfo(String name, String phone, String email) async {
    String email = auth.currentUser!.email.toString();
    String dayCreated = auth.currentUser!.metadata.creationTime.toString();
    String uid = auth.currentUser!.uid.toString();
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set({
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'avatar': 'avatar.jpg',
      'conversations': [],
      'friend_list': [],
      'day_created': dayCreated,
      'status': 'offline',
    });
  }

  // Read user's info
  Future<Users?> readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return Users.fromJson(snapshot.data()!);
    }
  }

  // Update user's info
  Future updateUserInfo(Users user) async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid);
    await docUser
        .update({'name': user.name, 'phone': user.phone, 'email': user.email});
  }

  // Update user's avatar
  Future updateUserAvatar(Users user) async {
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid);
    await docUser.update({'avatar': user.avatar});
  }

  // Search Friend
  Future searchName(friendEmail, userEmail) async {
    var document = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: friendEmail, isNotEqualTo: userEmail)
        .get();
    return document;
  }

  // Add friends
  Future addFriend(friendId, friendName, userName) async {
    // Update user's friend List
    DocumentReference userDocumentReference =
        userCollection.doc(auth.currentUser!.uid);
    await userDocumentReference.update({
      'friend_list': FieldValue.arrayUnion(["${friendId}_$friendName"])
    });

    // Update friend's friend List
    DocumentReference friendDocumentReference = userCollection.doc(friendId);
    await friendDocumentReference.update({
      'friend_list':
          FieldValue.arrayUnion(["${auth.currentUser!.uid}_$userName"])
    });
  }

  Future<bool> isUserAreFriendOrNot(friendId, friendName) async {
    DocumentReference userDocumentReference =
        userCollection.doc(auth.currentUser!.uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> friendList = await documentSnapshot['friend_list'];
    if (friendList.contains("${friendId}_$friendName")) {
      return true;
    } else {
      return false;
    }
  }

  // Read friend list
  readListFriend() {
    return userCollection.doc(auth.currentUser!.uid).snapshots();
  }
}
