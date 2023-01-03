import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/controllers/user_controller.dart';
import 'package:chat_app/validate/validation.dart';
import 'package:chat_app/views/components/flush_bar.dart';
import 'package:chat_app/views/components/text_field_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../components/widgets.dart';

class EditPage extends StatefulWidget {
  static const route = 'edit-page';

  const EditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> with CommonValidation {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Chỉnh sửa thông tin của bạn'),
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
          child: FutureBuilder<Users?>(
            future: UserController().readUser(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              }
              if (snapshot.hasData) {
                final user = snapshot.data;
                nameController.text = user.name;
                phoneController.text = user.phone;
                emailController.text = user.email;
                return Column(
                  children: [
                    editField(
                      context,
                      'Tên của bạn',
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        cursorWidth: 1,
                        cursorColor: Colors.black,
                        maxLines: 1,
                        validator: validateName,
                        decoration: editInputDecoration,
                      ),
                    ),
                    editField(
                      context,
                      'Số điện thoại',
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        cursorWidth: 1,
                        cursorColor: Colors.black,
                        maxLines: 1,
                        validator: validatePhone,
                        decoration: editInputDecoration,
                      ),
                    ),
                    editField(
                      context,
                      'Email',
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorWidth: 1,
                        cursorColor: Colors.black,
                        maxLines: 1,
                        validator: validateEmail,
                        decoration: editInputDecoration,
                      ),
                    ),
                    editField(
                      context,
                      'Nhập mật khẩu để xác nhận',
                      TextFormField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        cursorWidth: 1,
                        cursorColor: Colors.black,
                        maxLines: 1,
                        obscureText: true,
                        validator: validateConfirmPassWord,
                        decoration: editInputDecoration.copyWith(
                          hintText: 'Mật khẩu của bạn',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    confirmButton(),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
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
              'Cập nhật thông tin',
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
              await AuthController().updateUserEmail(
                yourConfirmPassword: confirmPasswordController.text,
                newEmail: emailController.text,
              );
              final user = Users(
                phone: phoneController.text,
                email: emailController.text,
                name: nameController.text,
              );
              UserController().updateUserInfo(
                user,
              );
              showFlushBar(context, 'Cập nhật thành công');
            } on FirebaseAuthException catch (e) {
              if (e.code == 'wrong-password') {
                showFlushBar(context, 'Mật khẩu không đúng');
              }
              if (e.code == 'email-already-in-use') {
                showFlushBar(context, 'Email này đã tồn tại');
              }
            }
          }
        },
      ),
    );
  }
}
