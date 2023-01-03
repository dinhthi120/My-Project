import 'package:chat_app/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controllers/conversation_controller.dart';

class AddFriendPage extends StatefulWidget {
  static const route = 'add-friend';

  const AddFriendPage({Key? key}) : super(key: key);

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final auth = FirebaseAuth.instance;
  final searchController = TextEditingController();
  late String _name = '';
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;

  String getId(String res) {
    return res.substring(res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Thêm bạn'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.greenAccent[400],
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Search Field
          Container(
            margin: const EdgeInsets.only(top: 6),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  height: 65,
                  width: MediaQuery.of(context).size.width * 0.82,
                  child: TextField(
                    controller: searchController,
                    cursorWidth: 1,
                    cursorColor: Colors.black,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    autofocus: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                      hintText: 'Nhập tên người bạn cần tìm',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _name = value.trim();
                      });
                    },
                  ),
                ),

                //Find button
                FutureBuilder(
                  future: UserController().readUser(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final user = snapshot.data;
                      return Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent[400],
                            borderRadius: BorderRadius.circular(40)),
                        child: TextButton(
                          onPressed: () {
                            initiateSearchMethod(user.email);
                          },
                          child: const Text(
                            'Tìm',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Text('');
                    }
                  },
                ),
              ],
            ),
          ),

          userList(),
        ],
      ),
    );
  }

  initiateSearchMethod(userEmail) async {
    await UserController().searchName(_name, userEmail).then((snapshot) {
      setState(() {
        searchSnapshot = snapshot;
        hasUserSearched = true;
      });
    });
  }

  userList() {
    return hasUserSearched
        ? FutureBuilder(
            future: UserController().readUser(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchSnapshot!.docs.length,
                    itemBuilder: (context, index) {
                      return SearchList(
                          name: searchSnapshot!.docs[index]['name'],
                          email: searchSnapshot!.docs[index]['email'],
                          friendId: searchSnapshot!.docs[index]['uid'],
                          userName: user.name,
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })
        : Container();
  }
}

class SearchList extends StatefulWidget {
  final String name;
  final String email;
  final String friendId;
  final String userName;

  const SearchList(
      {Key? key,
      required this.name,
      required this.email,
      required this.friendId,
      required this.userName})
      : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  bool _isFriend = false;

  @override
  Widget build(BuildContext context) {
    friendOrNot(friendId, friendName) async {
      await UserController()
          .isUserAreFriendOrNot(friendId, friendName)
          .then((value) {
         setState(() {
          _isFriend = value;
        });
      });
    }

    friendOrNot(widget.friendId, widget.name);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: 80,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            width: 50,
            height: 50,
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.jpg'),
              minRadius: 16,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  widget.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          const Spacer(),
          _isFriend
              ? Container(
                  height: 30,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[400],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'Bạn bè',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 30,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[400],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextButton(
                    onPressed: () {
                      UserController().addFriend(
                          widget.friendId, widget.name, widget.userName);
                      ConversationController(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createConversation(widget.name, widget.friendId);
                    },
                    child: const Text(
                      'Kết bạn',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
        ],
      ),
    );
  }


}



