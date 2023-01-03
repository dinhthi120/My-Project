import 'package:firebase_auth/firebase_auth.dart';

class HandleSignUp {
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
}
