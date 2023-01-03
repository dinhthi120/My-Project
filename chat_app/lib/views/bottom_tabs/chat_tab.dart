import 'package:chat_app/controllers/conversation_controller.dart';
import 'package:chat_app/controllers/user_controller.dart';
import 'package:chat_app/views/components/extension.dart';
import 'package:chat_app/views/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/widgets.dart';

class ChatTab extends StatefulWidget {
  static const route = 'chat-tab';

  const ChatTab({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final auth = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              // Top bar
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
                      child: AvatarAndTitle('assets/avatar.jpg', 'Hội thoại'),
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
                                Icons.more_horiz_outlined,
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
              SearchBar(context),

              // List box chat
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: ConversationController().readConversations(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong! ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        final conversations = snapshot.data!;
                        return ListView(
                          padding: const EdgeInsets.only(bottom: 100),
                          children: conversations.map(_buildListChat).toList(),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListChat(Map<String, dynamic> conversation) {
    return FutureBuilder(
      future: UserController().readUser(),
      builder: (context, AsyncSnapshot snapshot) {
        final user = snapshot.data;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BoxChat(
                  conversationId: conversation['conversation_id'],
                  conversationName: conversation['conversation_name'],
                  userName: user.name,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(top: 6, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 24, right: 12),
                  width: 45,
                  height: 45,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.jpg'),
                    minRadius: 16,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizeAllWord('${conversation['conversation_name']}'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        conversation['recent_sender'] == '' ||
                                conversation['recent_message'] == ''
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.72,
                                margin: const EdgeInsets.only(right: 24),
                                child: Text(
                                  'Hãy gửi lời chào cho ${conversation['conversation_name']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 0.78,
                                child: Row(
                                  children: [
                                    Text(
                                        capitalizeAllWord(
                                            '${conversation['recent_sender']}'),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.visible),
                                    Expanded(
                                      child: Text(
                                        ': ${conversation['recent_message']}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black54,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 24),
                                      child: const Text(
                                        '21:10',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
