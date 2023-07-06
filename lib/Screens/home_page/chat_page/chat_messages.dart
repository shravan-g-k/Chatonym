import 'package:chatonym/Backend/Cloud_Service/message_service/message_service.dart';
import 'package:chatonym/Models/message_model.dart';
import 'package:chatonym/utils/widgets/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/widgets/loading_widget.dart';

class ChatMessages extends ConsumerStatefulWidget {
  const ChatMessages({super.key, required this.groupId});
  final String groupId;

  @override
  ConsumerState<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends ConsumerState<ChatMessages> {
  late ScrollController _scrollController;
  List<Message>? messages;
  bool gettingOldMessages = false;

  void getInitialMessages() async {
    messages = await ref
        .read(messageServiceProvider)
        .getGroupMessages(widget.groupId, 20);
    setState(() {});
  }

  void updateMessages() async {
    ref
        .read(messageServiceProvider)
        .newMessages(widget.groupId)
        .listen((event) {
      messages?.insertAll(0, event);
      setState(() {});
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
    getInitialMessages();
    updateMessages();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (gettingOldMessages) return;
      setState(() {
        gettingOldMessages = true;
      });
      List<Message> oldMessages = await ref
          .read(messageServiceProvider)
          .getMoreMessages(
              groupId: widget.groupId,
              start: messages![messages!.length - 1].time);
      messages!.addAll(oldMessages);
      setState(() {
        messages = messages;
        gettingOldMessages = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (messages == null) {
      return const Center(
        child: Loading(),
      );
    } else {
      if (messages!.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/nothing_found.png',
                height: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'No messages yet !!',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
      }
      return Column(
        children: [
          if (gettingOldMessages)
            const Center(
              child: Loading(),
            )
          else
            const SizedBox(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: messages!.length,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: messages![index],
                );
              },
            ),
          ),
        ],
      );
    }
  }
}
