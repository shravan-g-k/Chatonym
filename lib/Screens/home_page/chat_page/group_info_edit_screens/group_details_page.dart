import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonym/Constants/enums_consts.dart';
import 'package:chatonym/Models/group_model.dart';
import 'package:chatonym/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:websafe_svg/websafe_svg.dart';
import '../../../../Backend/Cloud_Service/Group_Service/group_service.dart';
import '../../../../utils/widgets/loading_widget.dart';

class GroupDetailsPage extends ConsumerStatefulWidget {
  const GroupDetailsPage({required this.group, super.key});
  final DBGroup group;
  @override
  ConsumerState<GroupDetailsPage> createState() => _GroupDetalisPageState();
}

class _GroupDetalisPageState extends ConsumerState<GroupDetailsPage> {
  late Future<Group> group;
  void removeUserFromGroup(DBGroup group) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave Group'),
          content: const Text('Are you sure you want to leave this group?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (await ref
                    .read(groupServiceProvider)
                    .removeUserFromGroup(group)) {
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                        context, Routes.wrapperRoute);
                  }
                }
              },
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    group = ref.read(groupServiceProvider).getGroupFromId(widget.group.groupID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: group,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 75),
                              child: Container(
                                color: Colors.deepPurple[100],
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: snapshot.data!.banner != null
                                    ? CachedNetworkImage(
                                        imageUrl: snapshot.data!.banner!,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.group,
                                        size: 100,
                                      ),
                              ),
                            ),
                            Positioned(
                              top: 160,
                              left: MediaQuery.of(context).size.width / 2 - 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: snapshot.data!.profile != null
                                      ? CachedNetworkImage(
                                          imageUrl: snapshot.data!.profile!,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: Colors.deepPurple[50],
                                          child: const Icon(
                                            Icons.group,
                                            size: 50,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            textAlign: TextAlign.center,
                            snapshot.data!.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: Text(
                            snapshot.data!.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Members',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.members.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: WebsafeSvg.string(
                                  snapshot.data!.members[index].svg,
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              title: Text(snapshot.data!.members[index].name),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black54),
                        shape: MaterialStateProperty.all(const CircleBorder()),
                      ),
                      onPressed: () {
                        Navigator.pop(
                            context,
                            widget.group.copyWith(
                              name: snapshot.data!.name,
                              profile: snapshot.data!.profile,
                            ));
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: PopupMenuButton(
                        color: Colors.white,
                        onSelected: (value) {
                          if (value == GroupOptions.editGroup) {
                            Navigator.pushNamed(
                              context,
                              Routes.editGroupRoute,
                              arguments: snapshot.data!,
                            ).then((value) => setState(() {
                                  group = ref
                                      .read(groupServiceProvider)
                                      .getGroupFromId(widget.group.groupID);
                                }));
                          } else if (value == GroupOptions.leaveGroup) {
                            removeUserFromGroup(widget.group);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: GroupOptions.editGroup,
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Edit Group'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: GroupOptions.leaveGroup,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Leave Group'),
                                ],
                              ),
                            )
                          ];
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Loading(),
              );
            }
          },
        ),
      ),
    );
  }
}
