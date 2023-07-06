import 'package:chatonym/Constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      // body: const Loading(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                ImageConst.logo,
                height: 100,
              ),
              const Text(
                'Chatonym',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Welcome to our anonymous chatting app!',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Chatonym is a unique group chatting app that prioritizes anonymity and convenience. \nJoin Chatonym today and experience the freedom of anonymous group chatting!",
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Key Features:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '- Anonymous Usernames: Each user is assigned a random username to ensure anonymity within group chats.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '- Location-Based Groups: Create or discover groups within a certain radius, making it easy to connect with people nearby.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '- Global Reach: Connect with users from different countries and cultures.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '- Customizable Profiles: Add a Flutter Moji to your account to make it easier for others to find you.',
                style: TextStyle(fontSize: 16.0),
              ),
              const Text(
                'How to Get Started:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                '1. Sign up with your email and create a unique account.',
                style: TextStyle(fontSize: 16.0),
              ),
              const Text(
                '2. Explore groups either by searching for specific names or find groups near you.',
                style: TextStyle(fontSize: 16.0),
              ),
              const Text(
                '3. Join group chats and start anonymous conversations with other members.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),
              const Text(
                'Credits: ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      launchUrl(
                          Uri.parse('https://www.instagram.com/chaheljayaram'),
                          mode: LaunchMode.externalApplication);
                    },
                    child: const Text(
                      '@chaheljayaram ',
                      style: TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text(
                    'for the idea',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const Text(
                'Dall E for the logo',
                style: TextStyle(fontSize: 16.0),
              ),
              const Text(
                'UnDraw for the illustrations',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '© Shravan',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                      ),
                      child: Image.asset(
                        'assets/images/sk.png',
                        height: 25,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(UrlConst.github),
                            mode: LaunchMode.externalApplication);
                      },
                      child: Image.asset(
                        'assets/images/github-mark.png',
                        height: 25,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(UrlConst.twitter),
                            mode: LaunchMode.externalApplication);
                      },
                      child: Image.asset(
                        'assets/images/twitter_logo.png',
                        height: 25,
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
}
