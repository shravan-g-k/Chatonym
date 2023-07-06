import 'package:chatonym/Models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: WebsafeSvg.string(
        message.sender.svg,
        height: 40,
        width: 40,
      ),
      title: Row(
        children: [
          Text(
            message.sender.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${message.time.hour}:${message.time.minute} ${message.time.day}/${message.time.month}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Text(
        message.message,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
    );
  }
}
