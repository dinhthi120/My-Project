import 'package:chat_app/validate/validation.dart';
import 'package:chat_app/views/components/flush_bar.dart';
import 'package:chat_app/views/components/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../components/text_field_decoration.dart';

class LoginPage extends StatefulWidget {
  static const route = 'login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with CommonValidation {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String _email;
  late String _password;
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: const CircularProgressIndicator(color: Colors.green))
        : Scaffold(
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
                    children: [
                      const SizedBox(height: 100),
                      TopTitle('Đăng nhập'),

                      // Email field
                      textFieldContainer(
                        context,
                        TextFormField(
                          autofocus: true,
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

                      // Password Field
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

                      forgotPassword(),
                      loginButton(),
                      signUpButton(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget forgotPassword() {
    return const Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(right: 28),
        child: Text(
          'Quên mật khẩu?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return Container(
      margin: const EdgeInsets.only(top: 100, bottom: 24, left: 24, right: 24),
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 2, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Đăng nhập'.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            try {
              await AuthController().signInWithEmailAndPassword(
                email: _email,
                password: _password,
              );
              Navigator.pushReplacementNamed((context), '/');
              // ignore: use_build_context_synchronously
              showFlushBar(context, 'Đăng nhập thành công');
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found' || e.code == 'wrong-password') {
                showFlushBar(context, 'Sai tên hoặc mật khẩu');
              }
            }
          }
        },
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 2, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'Đăng ký'.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed((context), 'sign-up');
        },
      ),
    );
  }
}
