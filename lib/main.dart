import 'package:chatonym/Models/group_model.dart';
import 'package:chatonym/Screens/app_desc_pages/about_page.dart';
import 'package:chatonym/Screens/app_desc_pages/privacy_policy.dart';
import 'package:chatonym/Screens/home_page/chat_page/chat_page.dart';
import 'package:chatonym/Screens/home_page/chat_page/group_info_edit_screens/group_details_page.dart';
import 'package:chatonym/Screens/home_page/edit_profile_page/edit_profile.dart';
import 'package:chatonym/Screens/home_page/home_page.dart';
import 'package:chatonym/Screens/login_signup/signup_screen.dart';
import 'package:chatonym/Screens/login_signup/wrapper.dart';
import 'package:chatonym/Screens/login_signup/select_name_page.dart/select_name.dart';
import 'package:chatonym/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/home_page/chat_page/group_info_edit_screens/edit_group_page.dart';
import 'Screens/login_signup/login_screen.dart';
import 'firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(
    child: Chatonym(),
  ));
}

class Chatonym extends StatelessWidget {
  const Chatonym({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Routes.signupRoute: (context) => const SignupScreen(),
        Routes.loginRoute: (context) => const LoginScreen(),
        Routes.selectUsernameRoute: (context) => const SelectName(),
        Routes.homeRoute: (context) => const HomePage(),
        Routes.wrapperRoute: (context) => const Wrapper(),
        Routes.editUserRoute: (context) => const EditProfile(),
        Routes.aboutPageRoute: (context) => const AboutPage(),
        Routes.privacyPolicyPageRoute: (context) => const PrivacyPolicy(),
        Routes.chatRoute: (context) => ChatPage(
            group: ModalRoute.of(context)!.settings.arguments as DBGroup),
        Routes.groupDetailsRoute: (context) => GroupDetailsPage(
            group: ModalRoute.of(context)!.settings.arguments as DBGroup),
        Routes.editGroupRoute: (context) => EditGroup(
            group: ModalRoute.of(context)!.settings.arguments as Group),
      },
      initialRoute: Routes.wrapperRoute,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.rubikTextTheme(),
      ),
    );
  }
}
