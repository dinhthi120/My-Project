import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('About Us'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon_launcher/icon_launcher.png',
              scale: 2,
            ),
            const SizedBox(
              height: 16,
            ),
            html,
          ],
        ),
      ),
    );
  }

  Widget html = Html(
    data: """<pre>
Memories - Daily Journal\n
A journaling application that helps users have a private place to write down their thoughts, feelings, views on everything from work, study, love, friend</pre>""",
  );
}
