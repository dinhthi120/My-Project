import 'package:chat_app/controllers/conversation_controller.dart';
import 'package:chat_app/views/components/extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoxChat extends StatefulWidget {
  final String conversationId;
  final String conversationName;
  final String userName;

  const BoxChat(
      {Key? key,
      required this.conversationId,
      required this.conversationName,
      required this.userName})
      : super(key: key);

  @override
  State<BoxChat> createState() => _BoxChatState();
}

class _BoxChatState extends State<BoxChat> {
  final messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Stream<QuerySnapshot>? messages;

  @override
  void initState() {
    // TODO: implement initState
    readMessage();
    super.initState();
  }

  readMessage() {
    ConversationController().readMessage(widget.conversationId).then((value) {
      setState(() {
        messages = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top bar
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Back Button
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.greenAccent[400],
                            size: 22,
                          ),
                        ),

                        // Username and avatar
                        Row(
                          children: [
                            const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/avatar.jpg'),
                                minRadius: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              capitalizeAllWord(widget.conversationName),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),

                        // Top right button
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('user-info');
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Icon(
                                Icons.call_outlined,
                                color: Colors.greenAccent[400],
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // List message
              Expanded(
                child: StreamBuilder(
                  stream: messages,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                          padding: const EdgeInsets.only(top: 12, bottom: 4),
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) => messageContent(
                              snapshot.data.docs[index]['message'],
                              snapshot.data.docs[index]['sender'],
                              widget.userName ==
                                  snapshot.data.docs[index]['sender']));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),

              // Bottom bar
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200]!,
                          blurRadius: 6,
                          offset: const Offset(2, 0),
                        )
                      ]),
                      // Bottom toolbar
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_file_outlined,
                                  color: Colors.greenAccent[400],
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.greenAccent[400],
                                )
                              ],
                            ),
                          ),

                          // Input Field
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            height: 55,
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextField(
                              controller: messageController,
                              cursorWidth: 1,
                              cursorColor: Colors.black,
                              maxLines: 1,
                              textAlignVertical: TextAlignVertical.center,
                              autofocus: false,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                            ),
                          ),

                          // Send Button
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: IconButton(
                              onPressed: () {
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(microseconds: 300),
                                    curve: Curves.easeInOut);
                                sendMessage();
                              },
                              icon: Icon(
                                Icons.send_outlined,
                                color: Colors.greenAccent[400],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "created_at": DateTime.now().millisecondsSinceEpoch
      };

      ConversationController()
          .sendMessage(widget.conversationId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  Widget messageContent(message, sender, bool sentByCurrentUser) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      child: Align(
        alignment: (sentByCurrentUser ? Alignment.topRight : Alignment.topLeft),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                decoration: BoxDecoration(
                  borderRadius: (sentByCurrentUser
                      ? const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  color: (sentByCurrentUser
                      ? Colors.greenAccent[400]
                      : Colors.grey[300]),
                ),
                child: Text(
                  capitalize(message),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
