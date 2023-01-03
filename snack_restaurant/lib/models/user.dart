class Users {
  final String address;
  final String email;
  final String name;
  final String phone;

  Users({
    this.address = '',
    this.email = '',
    this.phone = '',
    this.name = '',
  });

  @override
  String toString() {
    return 'User(address: $address, email: $email, name: $name, phone: $phone)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'address': address,
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  static Users fromJson(Map<String, dynamic> json) => Users(
        address: json['address'],
        email: json['email'],
        phone: json['phone'],
        name: json['name'],
      );
}
