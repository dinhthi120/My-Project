import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../validate/validation.dart';
import '../../../controllers/handle_user.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/edit-info';

  final Users user;

  const EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with CommonValidation {
  final formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController.text = widget.user.phone;
    emailController.text = widget.user.email;
    addressController.text = widget.user.address;
    nameController.text = widget.user.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit your info'),
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
              fieldPhone(),
              fieldEmail(),
              fieldAddress(),
              fieldName(),
              fieldConfirmPassword(),
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

  Widget fieldPhone() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
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
      ),
    );
  }

  Widget fieldEmail() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
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
      ),
    );
  }

  Widget fieldAddress() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        controller: addressController,
        keyboardType: TextInputType.streetAddress,
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
      ),
    );
  }

  Widget fieldName() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        controller: nameController,
        keyboardType: TextInputType.name,
        cursorWidth: 2,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, right: 16),
          labelText: 'Name',
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
      ),
    );
  }

  Widget fieldConfirmPassword() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        controller: confirmPasswordController,
        keyboardType: TextInputType.visiblePassword,
        cursorWidth: 2,
        obscureText: true,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, right: 16),
          labelText: 'Confirm Password',
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
              await HandleUser().updateUserEmail(
                  yourConfirmPassword: confirmPasswordController.text,
                  newEmail: emailController.text);
              final user = Users(
                phone: phoneController.text,
                email: emailController.text,
                address: addressController.text,
                name: nameController.text,
              );
              HandleUser().updateUser(
                user,
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Update successfully!')));
              Navigator.pop(context);
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'wrong-password') {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(20),
                content: Text("Sorry wrong password"),
              ));
            }
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
          'update'.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
