import 'package:chatonym/Constants/consts.dart';
import 'package:flutter/material.dart';

// error dialog used in failure of functions
void errorDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
    ),
  );
}

// Error Screen Used in case of any error that nedd to be shown instead of some screen
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                ImageConst.logo,
                height: 30,
              ),
              const Text('Chatonym'),
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/error.png',
              ),
              const Text(
                'Something went wrong!',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ));
  }
}
