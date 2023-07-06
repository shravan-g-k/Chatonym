import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Privacy Policy for Chatonym',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'At Chatonym, we respect your privacy and are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our group chatting app. By using Chatonym, you consent to the practices described in this policy.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Information we collect:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '- Personal Information: When you sign up for an account, we may collect your email address for authentication purposes. However, we do not collect or store any personally identifiable information such as your name, address, or phone number.',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '- Random Usernames: To maintain anonymity within group chats, we assign random usernames to each user. These usernames are generated and do not reveal any personal details.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '2.Usage of Information:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '- Group Chats: Chatonym is a platform for anonymous group chats, and your conversations within groups are treated as private and confidential. We do not monitor content of your messages.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              "- Location-Based Groups: If you enable the location-based option, we collect your device's location information solely for the purpose of displaying groups near your vicinity. This data is used in an anonymous and aggregated form and is not associated with any personally identifiable information.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              "- Group Banners and Profile: You have the option to customize your group's banner and profile. The banners or profiles you create are stored securely on our servers and will be visible to other group members. However, we do not use these banners for any other purpose.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Third-Party Services:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Chatonym may use third-party services, such as cloud hosting providers or analytics tools, to enhance the app's functionality and improve user experience. These third parties may have access to certain information collected by Chatonym, but they are bound by confidentiality and data protection obligations.",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
