import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snack_restaurant/validate/validation.dart';
import 'package:snack_restaurant/views/routes/page_route.dart';
import '../../../controllers/handle_login.dart';
import '../error.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/loginPage';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<StatefulWidget> with CommonValidation {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String _emailAddress;
  late String _password;
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Login Page'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopImage(),
              fieldEmailAddress(),
              fieldPassword(),
              loginButton(),
              signUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget TopImage() {
    return Image.network(
      'https://symbols.vn/wp-content/uploads/2021/12/Hinh-anh-do-an-sieu-dang-yeu.jpg',
      width: MediaQuery.of(context).size.width * 0.3,
    );
  }

  Widget fieldEmailAddress() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        cursorWidth: 2,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, right: 16),
          labelText: 'Email',
          hintStyle: TextStyle(fontSize: 15),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
        ),
        validator: validateLoginEmail,
        onChanged: (value) {
          setState(() {
            _emailAddress = value.trim();
          });
        },
      ),
    );
  }

  Widget fieldPassword() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 6),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        controller: passwordController,
        cursorWidth: 2,
        obscureText: _passwordVisible,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          labelText: 'Password',
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
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        validator: validateLoginPassword,
        onChanged: (value) {
          setState(() {
            _password = value.trim();
          });
        },
      ),
    );
  }

  Widget loginButton() {
    return Container(
        margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.058,
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: BorderRadius.circular(6),
        ),
        child: TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              try {
                await HandleLogin().signInWithEmailAndPassword(
                  email: _emailAddress,
                  password: _password,
                );
                Navigator.pushReplacementNamed(context, PageRoutes.home);
                // After completing login, system will push user to HomeScreen
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.all(20),
                    content: Text(loginEmailError),
                  ));
                }
                if (e.code == 'wrong-password') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.all(20),
                    content: Text(loginPassError),
                  ));
                }
              }
            }
          },
          child: Text(
            'Login'.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ));
  }

  Widget signUpButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Text(
            'No account?',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 8),
          GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, PageRoutes.signUp);
              },
              child: const Text(
                'Create One',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
