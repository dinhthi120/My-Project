import 'package:chat_app/controllers/user_controller.dart';
import 'package:chat_app/views/components/extension.dart';
import 'package:flutter/material.dart';
import '../components/widgets.dart';

class PhoneBook extends StatefulWidget {
  const PhoneBook({Key? key}) : super(key: key);

  @override
  State<PhoneBook> createState() => _PhoneBookState();
}

class _PhoneBookState extends State<PhoneBook> {
  var tabs = [
    {"text": "Đang online"},
    {"text": "Đang offline"},
  ];

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: tabs.length,
        child: Scaffold(
          floatingActionButton: Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('add-friend');
              },
              backgroundColor: Colors.greenAccent[400],
              elevation: 2,
              child: const Icon(Icons.person_add),
            ),
          ),
          backgroundColor: Colors.white,
          body: SizedBox(
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  margin: const EdgeInsets.only(
                      left: 12, right: 12, top: 12, bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[400],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar and Title
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: AvatarAndTitle('assets/avatar.jpg', 'Bạn bè'),
                      ),

                      // Top right Icon
                      Container(
                        padding: const EdgeInsets.only(right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('user-info');
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(
                                  Icons.list_rounded,
                                  color: Colors.black38,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Search field
                searchBar(context),

                // Body Tab bar
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TabBar(
                            indicatorWeight: 2,
                            labelStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            unselectedLabelColor: Colors.black54,
                            labelColor: Colors.greenAccent[700],
                            indicatorColor: Colors.greenAccent[400],
                            tabs: tabs
                                .map((tab) => Tab(
                                      text: tab['text'],
                                    ))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: TabBarView(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: StreamBuilder(
                                    stream: UserController().readListFriend(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data['friend_list'] !=
                                            null) {
                                          if (snapshot
                                                  .data['friend_list'].length !=
                                              0) {
                                            return ListView.builder(
                                              padding: const EdgeInsets.only(
                                                  bottom: 80, top: 6),
                                              shrinkWrap: true,
                                              itemCount: snapshot
                                                  .data['friend_list'].length,
                                              itemBuilder: (context, index) {
                                                int reverseIndex = snapshot
                                                        .data['friend_list']
                                                        .length -
                                                    index -
                                                    1;
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6,
                                                          bottom: 6,
                                                          left: 24),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 45,
                                                        height: 45,
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/avatar.jpg'),
                                                          minRadius: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 16,
                                                      ),
                                                      Text(
                                                        capitalizeAllWord(
                                                            getName(snapshot
                                                                        .data[
                                                                    'friend_list']
                                                                [
                                                                reverseIndex])),
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            return const Text('');
                                          }
                                        } else {
                                          return const Text('');
                                        }
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: StreamBuilder(
                                    stream: UserController().readListFriend(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data['friend_list'] !=
                                            null) {
                                          if (snapshot
                                                  .data['friend_list'].length !=
                                              0) {
                                            return ListView.builder(
                                              padding: const EdgeInsets.only(
                                                  bottom: 80, top: 6),
                                              shrinkWrap: true,
                                              itemCount: snapshot
                                                  .data['friend_list'].length,
                                              itemBuilder: (context, index) {
                                                int reverseIndex = snapshot
                                                        .data['friend_list']
                                                        .length -
                                                    index -
                                                    1;
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6,
                                                          bottom: 6,
                                                          left: 24),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 45,
                                                        height: 45,
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/avatar.jpg'),
                                                          minRadius: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 16,
                                                      ),
                                                      Text(
                                                        capitalizeAllWord(
                                                            getName(snapshot
                                                                        .data[
                                                                    'friend_list']
                                                                [
                                                                reverseIndex])),
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            return const Text('');
                                          }
                                        } else {
                                          return const Text('');
                                        }
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
