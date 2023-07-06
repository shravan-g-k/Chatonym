import 'package:chatonym/Backend/Cloud_Service/User_Service/user_service.dart';
import 'package:chatonym/Constants/firebase_consts.dart';
import 'package:chatonym/Screens/home_page/home_page.dart';
import 'package:chatonym/Screens/login_signup/introduction_page/start_page.dart';
import 'package:chatonym/Screens/login_signup/select_name_page.dart/select_name.dart';
import 'package:chatonym/utils/widgets/error_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Backend/Auth_Service/auth_service.dart';
import '../../utils/widgets/loading_widget.dart';

class Wrapper extends ConsumerStatefulWidget {
  // Shows the Sign up screen if the user is not logged in
  const Wrapper({super.key});

  @override
  ConsumerState<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<Wrapper> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> user;

  void collectUser() {
    User? currentUser = ref.read(firebaseAuthProvider).currentUser;
    user = ref
        .read(cloudFirestoreProvider)
        .collection(FirebaseConst.users)
        .doc(currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateChangesProvider);
    return auth.when(
      data: (data) {
        if (data == null) {
          return const StartPage();
        } else {
          collectUser();
          return FutureBuilder(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!(snapshot.data!.exists)) {
                  return const SelectName();
                } else {
                  return const HomePage();
                }
              } else if (snapshot.hasError) {
                return const ErrorScreen();
              } else {
                return const Center(
                  child: Loading(),
                );
              }
            },
          );
        }
      },
      error: (error, stackTrace) {
        return const ErrorScreen();
      },
      loading: () {
        return const Center(
          child: Loading(),
        );
      },
    );
  }
}
