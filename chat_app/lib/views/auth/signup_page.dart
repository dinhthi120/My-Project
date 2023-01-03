import 'package:chat_app/controllers/user_controller.dart';
import 'package:chat_app/validate/validation.dart';
import 'package:chat_app/views/components/extension.dart';
import 'package:chat_app/views/components/flush_bar.dart';
import 'package:chat_app/views/components/text_field_decoration.dart';
import 'package:chat_app/views/components/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class SignUpPage extends StatefulWidget {
  static const route = 'sign-up';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with CommonValidation {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late String _name, _phone, _email;
  String _password = '', _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/login_top_img.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(),
                TopTitle('Đăng ký'),

                // Username field
                textFieldContainer(
                  context,
                  TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    cursorWidth: 2,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: textInputDecoration.copyWith(
                      label: const Text('Tên của bạn'),
                    ),
                    validator: validateName,
                    onChanged: (value) {
                      setState(() {
                        _name = capitalizeAllWord(value).trim();
                      });
                    },
                  ),
                ),

                // Email field
                textFieldContainer(
                  context,
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    cursorWidth: 2,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: textInputDecoration.copyWith(
                      label: const Text('Email'),
                    ),
                    validator: validateEmail,
                    onChanged: (value) {
                      setState(() {
                        _email = value.trim();
                      });
                    },
                  ),
                ),

                // Phone field
                textFieldContainer(
                  context,
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    cursorWidth: 2,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: textInputDecoration.copyWith(
                      label: const Text('Phone'),
                    ),
                    validator: validatePhone,
                    onChanged: (value) {
                      setState(() {
                        _phone = value.trim();
                      });
                    },
                  ),
                ),

                // Password field
                textFieldContainer(
                  context,
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    cursorWidth: 2,
                    cursorColor: Colors.white,
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: textInputDecoration.copyWith(
                      label: const Text('Mật khẩu'),
                    ),
                    validator: validatePassword,
                    onChanged: (value) {
                      setState(() {
                        _password = value.trim();
                      });
                    },
                  ),
                ),

                // Confirm password field
                textFieldContainer(
                  context,
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: confirmPasswordController,
                    cursorWidth: 2,
                    cursorColor: Colors.white,
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: textInputDecoration.copyWith(
                      label: const Text('Nhập lại mật khẩu'),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui lòng nhập lại mật khẩu để xác nhận';
                      }
                      if (_confirmPassword != _password) {
                        return 'Mật khẩu không trùng';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _confirmPassword = value.trim();
                      });
                    },
                  ),
                ),

                signUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget backButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: IconButton(
        onPressed: () {
          Navigator.pushReplacementNamed((context), 'login');
        },
        icon: const Icon(
          Icons.arrow_back_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 16, left: 24, right: 24),
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 2, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
        child: Text(
          'Đăng ký'.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onPressed: () async {
          try {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              await AuthController().signUp(
                email: _email,
                password: _password,
              );
              UserController().userInfo(
                _name,
                _phone,
                _email,
              );
              await AuthController().logOut();
              showFlushBar(context, 'Đăng ký thành công');
              Navigator.pushReplacementNamed((context), 'login');
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'email-already-in-use') {
              showFlushBar(context, 'Tài khoản này đã tồn tại');
            }
          }
        },
      ),
    );
  }
}
