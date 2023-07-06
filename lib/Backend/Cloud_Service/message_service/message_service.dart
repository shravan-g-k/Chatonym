import 'package:chatonym/Backend/Cloud_Service/Group_Service/group_service.dart';
import 'package:chatonym/Constants/firebase_consts.dart';
import 'package:chatonym/Models/group_model.dart';
import 'package:chatonym/Models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final messageServiceProvider = Provider<MessageService>((ref) {
  return MessageService(ref);
});

class MessageService {
  final Ref _ref;
  MessageService(this._ref);

  CollectionReference get groupCollection =>
      _ref.read(groupServiceProvider).groupCollection;

  void sendMessageToGroup(
      {required Message message, required String groupId}) async {
    CollectionReference collectionReference =
        groupCollection.doc(groupId).collection(FirebaseConst.messages);
    collectionReference
        .doc(
          (await collectionReference.count().get()).count.toString(),
        )
        .set(message.toMap());
  }

  Future<List<Message>> getGroupMessages(String groupId, int limit) async {
    return await groupCollection
        .doc(groupId)
        .collection(FirebaseConst.messages)
        .orderBy('time', descending: true)
        .limit(limit)
        .get()
        .then((value) =>
            value.docs.map((e) => Message.fromMap(e.data())).toList());
  }

  Stream<List<Message>> newMessages(String groupId) {
    return groupCollection
        .doc(groupId)
        .collection(FirebaseConst.messages)
        .limit(1)
        .orderBy('time', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Message.fromMap(e.data())).toList();
    });
  }

  Future<List<Message>> getMoreMessages(
      {required String groupId, required DateTime start}) async {
    return await groupCollection
        .doc(groupId)
        .collection(FirebaseConst.messages)
        .orderBy('time', descending: true)
        .limit(30)
        .where('time', isLessThan: start.millisecondsSinceEpoch)
        .get()
        .then((value) =>
            value.docs.map((e) => Message.fromMap(e.data())).toList());
  }

  Stream<int> numberOfUnread(DBGroup group) {
    Stream<int> currrentNumOfMessages = groupCollection
        .doc(group.groupID)
        .collection(FirebaseConst.messages)
        .snapshots()
        .map((event) {
      return event.docs.length - group.lastMessageRead.toInt();
    });
    return currrentNumOfMessages;
  }

  Future<int> latestMessageRead(String groupId) async {
    return await groupCollection
        .doc(groupId)
        .collection(FirebaseConst.messages)
        .get()
        .then((value) => value.docs.length);
  }

}
