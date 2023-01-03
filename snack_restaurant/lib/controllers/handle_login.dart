import 'package:firebase_auth/firebase_auth.dart';

class HandleLogin {
  final auth = FirebaseAuth.instance;

  // Sign in using signInWithEmailAndPassword from Authentication
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
}
