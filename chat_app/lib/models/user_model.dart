class Users {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String avatar;
  final List? conversations;
  final List? friendList;
  final String? status;

  Users({
    this.uid = '',
    this.name = '',
    this.phone = '',
    this.email = '',
    this.avatar = '',
    this.conversations,
    this.friendList,
    this.status,
});

  @override
  String toString() {
    return 'Users(uid: $uid, name: $name, phone: $phone, email: $email, avatar: $avatar, conversations: $conversations, friend_list: $friendList, status: $status)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'avatar': avatar,
      'conversations': conversations,
      'friend_list': friendList,
      'status': status,
    };
  }

  static Users fromJson(Map<String, dynamic> json) => Users(
    uid: json['uid'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    avatar: json['avatar'],
    conversations: json['conversations'],
    friendList: json['friend_list'],
    status: json['status'],
  );
}