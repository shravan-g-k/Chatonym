import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonym/Backend/Cloud_Service/message_service/message_service.dart';
import 'package:chatonym/Models/group_model.dart';
import 'package:chatonym/Models/message_model.dart';
import 'package:chatonym/Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Backend/Cloud_Service/User_Service/user_service.dart';
import '../../route/routes.dart';

class GroupTile extends ConsumerStatefulWidget {
  const GroupTile({super.key, required this.data});
  final DBGroup data;

  @override
  ConsumerState<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends ConsumerState<GroupTile> {
  late Future<Message> subtitle;

  void updateSubTitle() {
    ref
        .read(messageServiceProvider)
        .newMessages(widget.data.groupID)
        .listen((event) {
      if (event.isEmpty) return;
      subtitle = Future.value(event[0]);
      setState(() {});
    });
  }

  @override
  void initState() {
    subtitle = ref
        .read(messageServiceProvider)
        .getGroupMessages(widget.data.groupID, 1)
        .then((value) => value[0]);
    updateSubTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.chatRoute,
          arguments: widget.data,
        ).then(
          (value) async {
            AppUser user = ref.read(userProvider)!;
            int lastRead = await ref
                .read(messageServiceProvider)
                .latestMessageRead((widget.data).groupID);
            if (mounted) {
              ref.read(userServiceProvider).updateUser(
                  user.copyWith(
                    groups: user.groups.map((e) {
                      if (e.groupID == (widget.data).groupID) {
                        return e.copyWith(lastMessageRead: lastRead.toDouble());
                      }
                      return e;
                    }).toList(),
                  ),
                  context);
            }
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          // check if the group has a profile image
          leading: widget.data.profile != null
              ? ClipRRect(
                  // CIRCULAR BORDER RADIUS
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                    placeholder: (context, url) => Container(
                      width: 50,
                      color: Colors.grey,
                    ),
                    imageUrl: widget.data.profile!,
                  ),
                )
              : const Icon(
                  Icons.group,
                  size: 50,
                ),
          title: Text(
            widget.data.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  '${snapshot.data!.sender.name} ${snapshot.data!.message}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              } else {
                return const SizedBox();
              }
            },
            future: subtitle,
          ),
          trailing: StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == 0) {
                  return const SizedBox();
                } else if (snapshot.data! > 99) {
                  return const Text('99+');
                }
                return CircleAvatar(
                  radius: 10,
                  child: Text(snapshot.data.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                      )),
                );
              }
              return const SizedBox();
            },
            stream:
                ref.read(messageServiceProvider).numberOfUnread(widget.data),
          ),
        ),
      ),
    );
  }
}
