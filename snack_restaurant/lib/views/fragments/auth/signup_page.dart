import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snack_restaurant/validate/validation.dart';
import 'package:snack_restaurant/views/routes/page_route.dart';
import '../../../controllers/handle_logout.dart';
import '../../../controllers/handle_signup.dart';
import '../../../controllers/handle_user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String routeName = '/signupPage';
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<StatefulWidget> with CommonValidation {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final addressController = TextEditingController();
  final phonesController = TextEditingController();
  late String _emailAddress,
      _password,
      _username,
      _phone,
      _address,
      _confirmPassword;

  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Sign Up Page'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              topImage(),
              fieldUsername(),
              fieldAddress(),
              fieldPhone(),
              fieldEmailAddress(),
              fieldPassword(),
              fieldConfirmPassword(),
              signUpButton(),
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

  Widget fieldUsername() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: usernameController,
        cursorWidth: 2,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, right: 16),
          labelText: 'Full Name',
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
        validator: validateSignUpName,
        onChanged: (value) {
          setState(() {
            _username = value.trim();
          });
        },
      ),
    );
  }

  Widget fieldPhone() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 6),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: phonesController,
        cursorWidth: 2,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, right: 16),
          labelText: 'Phone Number',
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
        validator: validateSignUpPhone,
        onChanged: (value) {
          setState(() {
            _phone = value.trim();
          });
        },
      ),
    );
  }

  Widget fieldAddress() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 6),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        keyboardType: TextInputType.streetAddress,
        controller: addressController,
        cursorWidth: 2,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, right: 16),
          labelText: 'Address',
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
        validator: validateSignUpAddress,
        onChanged: (value) {
          setState(() {
            _address = value.trim();
          });
        },
      ),
    );
  }

  Widget fieldEmailAddress() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 6),
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
        validator: validateSignUpEmailAddress,
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
        validator: validateSignUpPassword,
        onChanged: (value) {
          setState(() {
            _password = value.trim();
          });
        },
      ),
    );
  }

  Widget fieldConfirmPassword() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 6),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        controller: confirmPasswordController,
        cursorWidth: 2,
        obscureText: _confirmPasswordVisible,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          labelText: 'Confirm password',
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
              _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              });
            },
          ),
        ),
        validator: (input) {
          if (input!.isEmpty) {
            return 'You are not confirm your password yet';
          }
          if (_confirmPassword != _password) {
            return 'Wrong password';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            _confirmPassword = value.trim();
          });
        },
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.055,
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextButton(
        onPressed: () async {
          try {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              await HandleSignUp().signUp(
                email: _emailAddress,
                password: _password,
              );
              HandleUser().userInfo(
                username: _username,
                phone: _phone,
                address: _address,
              );
              await HandleLogout().logOut();
              Navigator.pushReplacementNamed(context, PageRoutes.login);
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'email-already-in-use') {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(20),
                content: Text("Sorry email already exists"),
              ));
            }
          }
        },
        child: Text(
          'Sign up'.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
