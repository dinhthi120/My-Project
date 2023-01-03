import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/validate/validation.dart';
import 'package:chat_app/views/components/flush_bar.dart';
import 'package:chat_app/views/components/text_field_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/widgets.dart';

class ChangePassPage extends StatefulWidget {
  static const route = 'change-pass-page';

  const ChangePassPage({Key? key}) : super(key: key);

  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> with CommonValidation {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late String _oldPassword, _newPassword, _confirmNewPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Đổi mật khẩu của bạn'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.greenAccent[400],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              editField(
                context,
                'Mật khẩu cũ',
                TextFormField(
                  controller: oldPasswordController,
                  keyboardType: TextInputType.name,
                  cursorWidth: 1,
                  cursorColor: Colors.black,
                  maxLines: 1,
                  obscureText: true,
                  validator: validatePassword,
                  decoration: changePasswordInputDecoration('Nhập mật khẩu cũ'),
                  onChanged: (value) {
                    setState(() {
                      _oldPassword = value.trim();
                    });
                  },
                ),
              ),
              editField(
                context,
                'Mật khẩu mới',
                TextFormField(
                  controller: newPasswordController,
                  keyboardType: TextInputType.phone,
                  cursorWidth: 1,
                  cursorColor: Colors.black,
                  maxLines: 1,
                  obscureText: true,
                  validator: validatePassword,
                  decoration:
                      changePasswordInputDecoration('Nhập mật khẩu mới'),
                  onChanged: (value) {
                    setState(() {
                      _newPassword = value.trim();
                    });
                  },
                ),
              ),
              editField(
                context,
                'Nhập lại mật khẩu mới',
                TextFormField(
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.emailAddress,
                  cursorWidth: 1,
                  cursorColor: Colors.black,
                  maxLines: 1,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu mới';
                    }
                    if (_newPassword != _confirmNewPassword) {
                      return 'Mật khẩu không trùng';
                    }
                    return null;
                  },
                  decoration: changePasswordInputDecoration(
                      'Nhập lại mật khẩu mới để xác nhận'),
                  onChanged: (value) {
                    setState(() {
                      _confirmNewPassword = value.trim();
                    });
                  },
                ),
              ),
              confirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget confirmButton() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.greenAccent[400],
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Cập nhật mật khẩu',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(width: 12),
            Icon(
              Icons.edit_outlined,
              color: Colors.white,
            ),
          ],
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            try {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                await AuthController().updateUserPassword(
                  oldPassword: _oldPassword,
                  newPassword: _newPassword,
                );
                showFlushBar(context, 'Cập nhật thành công');
                Navigator.pop(context);
              }
            } on FirebaseAuthException catch (e) {
              if (e.code == 'wrong-password') {
                showFlushBar(context, 'Mật khẩu cũ không đúng');
              }
            }
          }
        },
      ),
    );
  }
}
