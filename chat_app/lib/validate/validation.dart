mixin CommonValidation {
  String? validateEmail(String? value) {
    if(value!.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if(!value.contains('@gmail.com')) {
      return 'Vui lòng nhập email hợp lệ';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if(value!.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu cần ít nhất 6 ký tự';
    }
    return null;
  }

  String? validateConfirmPassWord(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu để xác nhận';
    }
    return null;
  }

  String? validateName(String? value) {
    if(value!.isEmpty) {
      return 'Vui lòng nhập tên của bạn';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Vui lòng nhập số điện thoại hợp lệ';
    }
    return null;
  }

}