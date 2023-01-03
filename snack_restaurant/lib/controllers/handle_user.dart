import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class HandleUser {
  final auth = FirebaseAuth.instance;

  // Update user
  Future updateUser(Users user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid);
    final json = user.toJson();
    await docUser.update(json);
  }

  // Set user Info from database
  Future userInfo({
    String? username,
    String? phone,
    String? address,
  }) async {
    String email = auth.currentUser!.email.toString();
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set({
      'name': username,
      'phone': phone,
      'address': address,
      'email': email,
      'role': 'user',
    });
  }

  // Update user's email on Authentication
  Future updateUserEmail({
    required String yourConfirmPassword,
    required String newEmail,
  }) async {
    final oldEmail = auth.currentUser!.email;
    await auth
        .signInWithEmailAndPassword(
            email: oldEmail!, password: yourConfirmPassword)
        .then((userCredential) async { await
      userCredential.user!.updateEmail(newEmail);
    });
  }

  // Update user's password on Authentication
  Future updateUserPassword({
    required String yourConfirmPassword,
    required String newPassword,
  }) async {
    final oldEmail = auth.currentUser!.email;
    await auth
        .signInWithEmailAndPassword(
            email: oldEmail!, password: yourConfirmPassword)
        .then((userCredential) {
      userCredential.user!.updatePassword(newPassword);
    });
  }
}
