mixin CommonValidation {
  // Login validation
  String? validateLoginEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@') || !value.contains('.com')) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? validateLoginPassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  // Sign up validation
  String? validateSignUpName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateSignUpAddress(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  String? validateSignUpPhone(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Please input valid phone number';
    }
    return null;
  }

  String? validateSignUpEmailAddress(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@') || !value.contains('.com')) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? validateSignUpPassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password needs at least 6 characters';
    }
    return null;
  }

  String? validateEditOldPassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your old password';
    }
    return null;
  }

  String? validateEditNewPassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your new password';
    }
    return null;
  }

  String? validateEditConfirmPassWord(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your password to confirm';
    }
    return null;
  }
}
