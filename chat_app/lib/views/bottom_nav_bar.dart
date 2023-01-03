import 'package:chat_app/views/bottom_tabs/friend_tab.dart';
import 'package:flutter/material.dart';
import 'bottom_tabs/call_tab.dart';
import 'bottom_tabs/chat_tab.dart';

class BotNavigationBar extends StatefulWidget {
  const BotNavigationBar({Key? key}) : super(key: key);

  @override
  _BotNavigationBarState createState() => _BotNavigationBarState();
}

class _BotNavigationBarState extends State<BotNavigationBar> {
  int _selectedIndex = 0;

  final screen = [
    ChatTab(),
    CallTab(),
    PhoneBook(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          screen[_selectedIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.greenAccent[400]
              ),
              child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconBottomBar(
                        text: "Hội thoại",
                        icon: Icons.home,
                        selected: _selectedIndex == 0,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                      ),
                      IconBottomBar(
                        text: "Cuộc gọi",
                        icon: Icons.call,
                        selected: _selectedIndex == 1,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                      ),
                      IconBottomBar(
                        text: "Bạn bè",
                        icon: Icons.list_alt,
                        selected: _selectedIndex == 2,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar({
    Key? key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: IconButton(
              onPressed: onPressed,
              splashRadius: 25,
              icon: Icon(
                icon,
                size: 25,
                color: selected ? Colors.white : Colors.black38,
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 0.1,
              color: selected ? Colors.white : Colors.black38,
            ),
          )
        ],
      ),
    );
  }
}
