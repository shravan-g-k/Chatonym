import 'package:chatonym/Models/group_model.dart';
import 'package:chatonym/Models/user_model.dart';
import 'package:chatonym/Screens/home_page/user_home_page.dart/create_group_widget.dart';
import 'package:chatonym/utils/widgets/error_widget.dart';
import 'package:chatonym/utils/widgets/group_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Backend/Cloud_Service/User_Service/user_service.dart';
import '../../../utils/widgets/loading_widget.dart';

class UserGroups extends ConsumerStatefulWidget {
  const UserGroups({super.key, required this.web});

  final bool web;

  @override
  ConsumerState<UserGroups> createState() => _UserGroupsState();
}

class _UserGroupsState extends ConsumerState<UserGroups> {
  List<DBGroup> groups = [];
  late SearchController _controller;
  @override
  void initState() {
    _controller = SearchController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SearchAnchor searchAnchor = SearchAnchor(
      searchController: _controller,
      suggestionsBuilder: (context, controller) {
        Iterable<DBGroup> selected = groups.where((element) {
          return element.name
              .toLowerCase()
              .contains(controller.text.toLowerCase());
        });
        return selected.map((e) => GroupTile(data: e)).toList();
      },
      builder: (context, controller) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Search for your Groups',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.web) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            children: [
              searchAnchor,
              ref.watch(userGroupsProvider).when(
                data: (data) {
                  groups = data;
                  // IF the list is empty return a text
                  if (data.isEmpty) {
                    return const NoGroups();
                  }
                  // ELSE return a list view builder
                  return Expanded(
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: kIsWeb ? false : true,
                      itemBuilder: (context, index) {
                        return GroupTile(
                          data: data[index],
                          key: ValueKey(
                            data[index].groupID,
                          ),
                        );
                      },
                      itemCount: data.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = data.removeAt(oldIndex);
                          data.insert(newIndex, item);
                        });
                        AppUser user = ref.read(userProvider)!.copyWith(
                              groups: data,
                            );
                        ref.read(userServiceProvider).updateUser(user, context);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return const ErrorScreen();
                },
                loading: () {
                  return const Center(
                    child: Loading(),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
    // SCAFFOLD
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // SINGLE CHILD SCROLL VIEW to avoid overflow
      body: Column(
        children: [
          // SEARCH BAR with a prefix icon and a label
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            // TEXT FIELD
            child: searchAnchor,
          ),
          // SIZED BOX
          const SizedBox(
            height: 10,
          ),
          // CONSUMER to get the list of groups
          ref.watch(userGroupsProvider).when(
            data: (data) {
              groups = data;
              // IF the list is empty return a text
              if (data.isEmpty) {
                return const NoGroups();
              }

              // ELSE return a list view builder
              return Expanded(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: kIsWeb ? false : true,
                  itemBuilder: (context, index) {
                    return GroupTile(
                      data: data[index],
                      key: ValueKey(
                        data[index].groupID,
                      ),
                    );
                  },
                  itemCount: data.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = data.removeAt(oldIndex);
                      data.insert(newIndex, item);
                    });
                    AppUser user = ref.read(userProvider)!.copyWith(
                          groups: data,
                        );
                    ref.read(userServiceProvider).updateUser(user, context);
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              return const ErrorScreen();
            },
            loading: () {
              return const Center(
                child: Loading(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
            enableDrag: true,
            context: context,
            builder: (context) => const CreateGroup(
              web: false,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoGroups extends StatelessWidget {
  const NoGroups({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/no_groups_yet.png',
            height: 200,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'You have no groups yet',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
