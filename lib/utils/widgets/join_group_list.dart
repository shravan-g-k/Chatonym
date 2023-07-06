import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Backend/Cloud_Service/User_Service/user_service.dart';
import '../../Models/group_model.dart';

class JoinGroupList extends ConsumerStatefulWidget {
  const JoinGroupList({super.key, required this.data});
  final List<Group> data;

  @override
  ConsumerState<JoinGroupList> createState() => _JoinGroupListState();
}

class _JoinGroupListState extends ConsumerState<JoinGroupList> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Expanded(
      // LISTVIEW to show the groups
      child: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final user = ref.watch(userProvider.notifier).state!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // EXPANSIONTILE to show the group details
            child: ExpansionTile(
              controlAffinity: ListTileControlAffinity.leading,
              trailing: TextButton(
                child: Text(
                  'Join',
                  style: TextStyle(
                      color: user.groups.every((element) {
                    return element.groupID != widget.data[index].groupID;
                  })
                          ? Theme.of(context).primaryColor
                          : Colors.grey),
                ),
                onPressed: () async {
                  if (user.groups.every(
                        (element) =>
                            element.groupID != widget.data[index].groupID,
                      ) ||
                      user.groups.isEmpty) {
                    await ref.read(userServiceProvider).joinGroup(
                          DBGroup(
                            profile: widget.data[index].profile,
                            name: widget.data[index].name,
                            groupID: widget.data[index].groupID,
                            lastMessageRead: 0,
                          ),
                          context,
                        );
                    setState(() {});
                  }
                },
              ),
              tilePadding: const EdgeInsets.all(5),
              // TITLE group name
              title: Text(
                widget.data[index].name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // SUBTITLE group description
              subtitle: Text(
                widget.data[index].description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // GROUP PROFILE
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: widget.data[index].profile == null
                    // if the profile is null then show the icon
                    ? const Icon(
                        Icons.group,
                        size: 50,
                      )
                    // if the profile is not null then show the image
                    : CachedNetworkImage(
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        imageUrl: widget.data[index].profile!,
                        placeholder: (context, url) => Container(
                          width: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
              children: [
                // DESCRIPTION
                Wrap(
                  children: [
                    Text(
                      widget.data[index].description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
