import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatonym/route/routes.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class StartPage extends StatefulWidget {
  // Has an Introduction Page
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isPressed = false; //user for neomorphic design
  AppBar appBar = AppBar(
    backgroundColor: Colors.deepPurple[100],
    centerTitle: true,
    title: const Text('Chatonym'),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Offset distance = isPressed ? const Offset(10, 10) : const Offset(5, 5);
    double blur = isPressed ? 5 : 10;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget neomorphicButton = Padding(
      // Neomorphic Button
      padding: const EdgeInsets.only(bottom: 40),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isPressed = !isPressed;
          });
          Navigator.pushNamed(context, Routes.signupRoute);
        },
        child: Container(
          // Button Container with the shadow
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                inset: isPressed,
                blurRadius: blur,
                offset: -distance,
                color: Colors.white.withOpacity(0.5),
              ),
              BoxShadow(
                inset: isPressed,
                blurRadius: blur,
                offset: distance,
                color: Colors.black.withOpacity(0.5),
              )
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepPurple,
          ),
          child: Row(
            // Row for the Get started and icon
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Get Started',
                style: TextStyle(color: Colors.deepPurple[50]),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.login_rounded,
                color: Colors.deepPurple[50],
              )
            ],
          ),
        ),
      ),
    );

    if (width > 500) {
      return Scaffold(
        backgroundColor: Colors.deepPurple[100],
        appBar: appBar,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              totalRepeatCount: 50,
              animatedTexts: [
                TyperAnimatedText(
                  textAlign: TextAlign.center,
                  'Your Gateway to Engaging Communities',
                  speed: const Duration(milliseconds: 100),
                  textStyle: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/chatonym_logo.png',
                      width: width / 4,
                    ),
                    const Text(
                      'Chatonym',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/intro_image_1.png',
                      width: width / 4,
                    ),
                    neomorphicButton,
                  ],
                )
              ],
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[100],
        appBar: appBar,
        body: Center(
          child: Column(
            // Main Column for the page
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/chatonym_logo.png',
                height: (height - (appBar.preferredSize.height + 300)) / 3,
              ),
              Image.asset(
                'assets/images/intro_image_1.png',
                height: (height - (appBar.preferredSize.height + 300)) / 1.5,
              ),
              // Rounded Container with animated text and button
              Container(
                height: 250,
                width: 350,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                  color: Colors.deepPurple.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  // Column having text and button
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      // Padding for the animated text
                      padding: const EdgeInsets.only(top: 25),
                      child: SizedBox(
                        child: DefaultTextStyle(
                          style: const TextStyle(),
                          child: AnimatedTextKit(
                            totalRepeatCount: 50,
                            animatedTexts: [
                              TyperAnimatedText(
                                textAlign: TextAlign.center,
                                'Your Gateway to Engaging Communities',
                                speed: const Duration(milliseconds: 100),
                                textStyle: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    neomorphicButton,
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
