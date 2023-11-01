import 'package:chat_app/views/components/extension.dart';
import 'package:chat_app/views/components/widgets.dart';
import 'package:flutter/material.dart';

class CallTab extends StatefulWidget {
  const CallTab({Key? key}) : super(key: key);

  @override
  State<CallTab> createState() => _CallTabState();
}

class _CallTabState extends State<CallTab> {
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
                      child: AvatarAndTitle('assets/avatar.jpg', 'Cuộc gọi'),
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
                                Icons.call_outlined,
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

              // List call
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.only(
                            bottom: 12, top: 6, left: 8, right: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 16, right: 16),
                              width: 45,
                              height: 45,
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/avatar.jpg'),
                                minRadius: 16,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  capitalizeAllWord('cù đình thi'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: const Text(
                                        'Cuộc gọi nhỡ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      '14 thg 10',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Spacer(),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.call_missed,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
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
}
