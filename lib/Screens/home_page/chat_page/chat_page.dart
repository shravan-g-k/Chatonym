import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonym/Backend/Cloud_Service/message_service/message_service.dart';
import 'package:chatonym/Models/group_model.dart';
import 'package:chatonym/Models/message_model.dart';
import 'package:chatonym/Models/user_model.dart';
import 'package:chatonym/Screens/home_page/chat_page/chat_messages.dart';
import 'package:chatonym/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Backend/Cloud_Service/User_Service/user_service.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.group});
  final DBGroup group;
  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late DBGroup group;
  late TextEditingController _controller;
  bool _isComposing = false;

  @override
  void initState() {
    group = widget.group;
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    _controller.dispose();
  }

  void messageSend() {
    ref.read(messageServiceProvider).sendMessageToGroup(
          message: Message(
            message: _controller.text,
            sender: DBUser(
                name: ref.read(userProvider)!.name,
                svg: ref.read(userProvider)!.svg),
            time: DateTime.now(),
          ),
          groupId: group.groupID,
        );
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.groupDetailsRoute,
                arguments: group,
              ).then((value) => setState(() {
                    group = value as DBGroup;
                  }));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                group.profile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                          placeholder: (context, url) => Container(
                            height: 40,
                            width: 40,
                            color: Colors.grey,
                          ),
                          imageUrl: group.profile!,
                        ),
                      )
                    : const Icon(Icons.group),
                const SizedBox(width: 10),
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      group.name,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ChatMessages(
          groupId: group.groupID,
        ),
        bottomNavigationBar: Container(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5).copyWith(bottom: 5),
            child: TextField(
              onSubmitted: (value) {
                messageSend();
              },
              controller: _controller,
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                hintText: 'Type a message',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                contentPadding: const EdgeInsets.all(20),
                suffixIcon: _isComposing
                    ? IconButton(
                        onPressed: () {
                          messageSend();
                        },
                        icon: const Icon(Icons.send),
                      )
                    : null,
              ),
              onChanged: (value) {
                if ((value.trim() != '') != _isComposing) {
                  setState(() {
                    _isComposing = value.isNotEmpty;
                  });
                }
              },
            ),
          ),
        ));
  }
}
