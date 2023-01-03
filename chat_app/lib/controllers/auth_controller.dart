import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final auth = FirebaseAuth.instance;

  // Sign up using createUserWithEmailAndPassword from Authentication
  Future signUp({
    required String email,
    required String password,
  }) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = auth.currentUser?.email;
    if (user != null) {
      print('Đăng ký thành công');
    }
  }

  // Login using signInWithEmailAndPassword from Authentication
  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    final user = auth.currentUser?.email;
    if (user != null) {
      print('Đăng nhập thành công');
    }
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
    required String oldPassword,
    required String newPassword,
  }) async {
    final oldEmail = auth.currentUser!.email;
    await auth
        .signInWithEmailAndPassword(
        email: oldEmail!, password: oldPassword)
        .then((userCredential) {
      userCredential.user!.updatePassword(newPassword);
    });
  }

  // Logout
  Future logOut() async {
    auth.signOut();
    print('Đăng xuất thành công');
  }
}