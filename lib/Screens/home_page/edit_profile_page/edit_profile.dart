import 'package:chatonym/Backend/Cloud_Service/User_Service/user_service.dart';
import 'package:chatonym/Models/user_model.dart';
import 'package:chatonym/route/routes.dart';
import 'package:chatonym/utils/functions/name_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';

import '../../../Backend/Cloud_Service/Group_Service/group_service.dart';
import '../../../Constants/colors.dart';
import '../../../utils/web_constraint.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late String userName;
  @override
  void initState() {
    userName = ref.read(userProvider)!.name;
    super.initState();
  }

  void updateUser() async {
    AppUser user = ref.read(userProvider)!;
    DBUser oldUser = DBUser(name: user.name, svg: user.svg);
    FluttermojiFunctions fluttermojiFunctions = FluttermojiFunctions();
    String mojisvg = await fluttermojiFunctions.encodeMySVGtoString();
    String svg = fluttermojiFunctions.decodeFluttermojifromString(mojisvg);
    if (userName == user.name && svg == user.svg) {
      return;
    } else {
      if (context.mounted) {
        for (int i = 0; i < user.groups.length; i++) {
          ref.read(groupServiceProvider).updateUserOfGroup(
                oldUser,
                DBUser(name: userName, svg: svg),
                user.groups[i].groupID,
                context,
              );
        }
        ref.read(userServiceProvider).updateUser(
              user.copyWith(
                name: userName,
                svg: svg,
              ),
              context,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatonym'),
      ),
      body: WebConstraint(
        child: Center(
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
                              child: Text(userName),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                userName = NameGenerator.generateName();
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
              InkWell(
                onTap: () {
                  updateUser();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, Routes.wrapperRoute);
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
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
