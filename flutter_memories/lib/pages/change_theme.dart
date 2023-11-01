import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../theme/theme_manager.dart';

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({super.key});

  @override
  ChangeThemeState createState() => ChangeThemeState();
}

int _selectedTheme = 0;

final List<String> imgList = [
  'assets/images/slider/light-theme.jpg',
  'assets/images/slider/dark-theme.jpg'
];

class ChangeThemeState extends State<ChangeTheme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Change Theme"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pushReplacementNamed(context, 'setting-page');
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/passcode-img.png',
            ),
          ),
        ),
        child: const ThemeSlider(),
      ),
    );
  }
}

class ThemeSlider extends StatefulWidget {
  const ThemeSlider({super.key});

  @override
  State<ThemeSlider> createState() => _ThemeSliderState();
}

class _ThemeSliderState extends State<ThemeSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.7,
              autoPlay: false,
              aspectRatio: 1.0,
              viewportFraction: 0.75,
              enlargeCenterPage: true,
              initialPage: _selectedTheme,
              onPageChanged: (index, reason) {
                setState(() {
                  _selectedTheme = index;
                });
              },
            ),
            items: imgList
                .map((item) => ClipRRect(
                        child: Stack(
                      children: <Widget>[
                        Image.asset(
                          item,
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width * 0.7,
                          fit: BoxFit.fill,
                        )
                      ],
                    )))
                .toList(),
          ),
          const ConfirmButton(),
        ],
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    themeNotifier.getTheme;
    return Container(
      margin: const EdgeInsets.only(top: 24),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 55,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        onPressed: () async {
          onThemeChange(_selectedTheme, themeNotifier);
        },
        child: Text('Use it'.toUpperCase()),
      ),
    );
  }
}

Future<void> onThemeChange(int value, ThemeNotifier themeNotifier) async {
  if (value == 1) {
    await themeNotifier.setTheme(darkTheme);
  } else if (value == 0) {
    await themeNotifier.setTheme(lightTheme);
  }
  final pref = await SharedPreferences.getInstance();
  await pref.setInt("ThemeMode", value);
}
