import 'package:firebase_auth/firebase_auth.dart';

class HandleLogout {
  final auth = FirebaseAuth.instance;

  Future logOut() async {
    auth.signOut();
    print('Đăng xuất thành công');
  }
}
