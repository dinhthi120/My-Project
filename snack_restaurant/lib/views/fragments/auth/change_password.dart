import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snack_restaurant/views/routes/page_route.dart';
import '../../../controllers/handle_user.dart';
import '../../../validate/validation.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = '/change-password';

  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> with CommonValidation {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  late String _oldPassword, _newPassword;

  bool _oldPasswordVisible = true;
  bool _newPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              topImage(),
              fieldOldPassword(),
              fieldNewPassword(),
              updateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget topImage() {
    return Image.network(
      'https://buomxinh.vn/wp-content/uploads/2021/08/1628663137_620_Hinh-anh-cute-Avatar-chibi-sieu-de-thuong.jpg',
      width: MediaQuery.of(context).size.width * 0.3,
    );
  }

  Widget fieldOldPassword() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        controller: oldPasswordController,
        cursorWidth: 2,
        obscureText: _oldPasswordVisible,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          labelText: 'Old password',
          hintStyle: const TextStyle(fontSize: 15),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _oldPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _oldPasswordVisible = !_oldPasswordVisible;
              });
            },
          ),
        ),
        validator: validateEditOldPassword,
        onChanged: (value) {
          setState(() {
            _oldPassword = value.trim();
          });
        },
      ),
    );
  }

  Widget fieldNewPassword() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        controller: newPasswordController,
        cursorWidth: 2,
        obscureText: _newPasswordVisible,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          labelText: 'New Password',
          hintStyle: const TextStyle(fontSize: 15),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _newPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _newPasswordVisible = !_newPasswordVisible;
              });
            },
          ),
        ),
        validator: validateEditNewPassword,
        onChanged: (value) {
          setState(() {
            _newPassword = value.trim();
          });
        },
      ),
    );
  }

  Widget updateButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextButton(
        onPressed: () async {
          try {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              await HandleUser().updateUserPassword(
                  yourConfirmPassword: _oldPassword, newPassword: _newPassword);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                  content: Text('Update successfully!')));
              Navigator.popAndPushNamed(context, PageRoutes.home);
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'wrong-password') {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(20),
                content: Text("Sorry wrong password"),
              ));
            }
          }
        },
        child: Text(
          'Update'.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
