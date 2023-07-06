import 'package:chatonym/Backend/Auth_Service/auth_service.dart';
import 'package:chatonym/Constants/colors.dart';
import 'package:chatonym/Models/user_model.dart';
import 'package:chatonym/route/routes.dart';
import 'package:chatonym/utils/functions/name_generator.dart';
import 'package:chatonym/utils/web_constraint.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttermoji/fluttermoji.dart';

import '../../../Backend/Cloud_Service/User_Service/user_service.dart';

class SelectName extends StatefulWidget {
  // Users Can select a username from this screen and can also select their avatar
  // This is the screen that will be shown to the user when they first sign up
  const SelectName({super.key});

  @override
  State<SelectName> createState() => _SelectNameState();
}

class _SelectNameState extends State<SelectName> {
  late String name;
  void saveUser(WidgetRef ref) async {
    final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
    FluttermojiFunctions fluttermojiFunctions = FluttermojiFunctions();
    String mojisvg = await fluttermojiFunctions.encodeMySVGtoString();
    String svg = fluttermojiFunctions.decodeFluttermojifromString(mojisvg);
    if (context.mounted) {
      ref.read(userServiceProvider).addUser(
          AppUser(name: name, uid: uid, svg: svg, groups: []), context);
    }
  }

  @override
  void initState() {
    name = NameGenerator.generateName(); // Generate a random name initially
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // A Box within which the user can select their username and avatar
    return WebConstraint(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // The container acts as a box that holds the username and avatar
                  decoration: const BoxDecoration(
                    // The box decoration gives the box a border 
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Colors.deepPurple,
                        width: 2,
                      ),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    // The column holds the avatar and username
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          // The Avatar
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                if (!kIsWeb) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return FluttermojiCustomizer();
                                    },
                                  );
                                }
                              },
                              child: kIsWeb
                                  ? const Text(
                                      'Log into App to Select Fluttermoji',
                                    )
                                  : FluttermojiCircleAvatar(
                                      backgroundColor: MyColors.lightPurple,
                                    ),
                            ),
                          ),
                          // The Flutter Moji Text
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Flutter Moji',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // The UserName Text
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Username',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // The random name is shown as a text with a refresh button
                      // to generate a new username
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(name),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                name = NameGenerator.generateName();
                              });
                            },
                            icon: const Icon(Icons.refresh_rounded),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // The Continue Button
              // This button will add the user to the database and take them to the
              // home page
              Consumer(
                builder: (context, ref, child) {
                  return InkWell(
                    onTap: () {
                      saveUser(ref);
                      Navigator.pushReplacementNamed(context, Routes.homeRoute);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple,
                        ),
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        child: const Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
