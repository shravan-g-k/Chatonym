import 'package:chatonym/Backend/Auth_Service/auth_service.dart';
import 'package:chatonym/Backend/Cloud_Service/User_Service/user_service.dart';
import 'package:chatonym/Constants/enums_consts.dart';
import 'package:chatonym/Constants/consts.dart';
import 'package:chatonym/Models/user_model.dart';
import 'package:chatonym/Screens/home_page/location_page/location_page.dart';
import 'package:chatonym/Screens/home_page/search_page/search_page.dart';
import 'package:chatonym/Screens/home_page/user_home_page.dart/create_group_widget.dart';
import 'package:chatonym/Screens/home_page/user_home_page.dart/user_groups.dart';
import 'package:chatonym/route/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';

import '../../utils/widgets/loading_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<AppUser> user;
  late Nav _currentNav;
  int _currentIndex = 1;
  late String userName;
  @override
  void initState() {
    userName = 'Loading...';
    user = ref.read(userServiceProvider).getUser(context);
    user.then((value) {
      setState(() {
        userName = value.name;
      });
      ref.read(userProvider.notifier).update((state) => value);
    });
    _currentNav = Nav.home;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    AppBar appBar = AppBar(
      title: Row(
        children: [
          Image.asset(
            ImageConst.logo,
            height: 30,
          ),
          const SizedBox(
            width: 15,
          ),
          const Text('Chatonym'),
        ],
      ),
    );

    Drawer drawer = Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              children: [
                kIsWeb
                    ? const Text(
                        'FlutterMoji on Web not supported.',
                        style: TextStyle(color: Colors.white),
                      )
                    : FluttermojiCircleAvatar(
                        backgroundColor: Colors.deepPurple[100],
                        radius: 50,
                      ),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pushNamed(context, Routes.editUserRoute);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(authProvider).signOut(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.aboutPageRoute);
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.privacyPolicyPageRoute);
            },
          ),
        ],
      ),
    );

    if (width > 500) {
      return Scaffold(
          appBar: appBar,
          drawer: drawer,
          body: Row(
            children: [
              NavigationRail(
                groupAlignment: 0,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.location_on_rounded),
                    label: Text('Location'),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.home_rounded),
                    label: Text('Home'),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search_rounded),
                    label: Text('Search'),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ],
                selectedIndex: _currentIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    _currentIndex = value;
                    switch (value) {
                      case 0:
                        _currentNav = Nav.location;
                        break;
                      case 1:
                        _currentNav = Nav.home;
                        break;
                      case 2:
                        _currentNav = Nav.search;
                        break;
                      default:
                    }
                  });
                },
              ),
              FutureBuilder(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (_currentNav) {
                      case Nav.home:
                        return const UserGroups(
                          web: true,
                        );
                      case Nav.location:
                        return const LocationPage(
                          web: true,
                        );
                      case Nav.search:
                        return const SearchPage(
                          web: true,
                        );
                      default:
                    }
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                            "Something went wrong. Please try again later."));
                  } else {
                    return const Center(
                      child: Loading(),
                    );
                  }
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateGroup(
                    web: true,
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // App Bar for the page
      appBar: appBar,
      drawer: drawer,
      // Body of the page which loads the data first
      body: Center(
        child: FutureBuilder(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (_currentNav) {
                case Nav.home:
                  return const UserGroups(
                    web: false,
                  );
                case Nav.location:
                  return const LocationPage(
                    web: false,
                  );
                case Nav.search:
                  return const SearchPage(
                    web: false,
                  );
                default:
              }
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.stackTrace.toString()),
              );
            } else {
              return const Center(
                child: Loading(),
              );
            }
          },
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: SizedBox(
        // constrainting the height of the bottom navigation bar
        height: 60,
        child: Container(
          // Container gives color shadow and border radius to the bottom navigation bar
          decoration: BoxDecoration(
            // decoration for the bottom navigation bar
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepPurple[200],
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            // Stack is used to position the indicator
            children: [
              // Indicator
              AnimatedPositioned(
                top: 5,
                left: (_currentIndex * width / 3) + width / 6 - 25,
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticInOut,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.purple[900],
                  ),
                  height: 50,
                  width: 50,
                ),
              ),
              // Row is used to position the icons
              Row(
                children: [
                  // Location Icon
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentIndex = 0;
                            _currentNav = Nav.location;
                          });
                        },
                        child: const Center(
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Home Icon
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _currentIndex = 1;
                          _currentNav = Nav.home;
                        });
                      },
                      child: const Center(
                        child: Icon(
                          Icons.home_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Search Icon
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: InkWell(
                        onTap: () {
                          setState(
                            () {
                              _currentIndex = 2;
                              _currentNav = Nav.search;
                            },
                          );
                        },
                        child: const Center(
                          child: Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
