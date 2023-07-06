import 'package:chatonym/Constants/firebase_consts.dart';
import 'package:chatonym/Models/group_model.dart';
import 'package:chatonym/Models/user_model.dart';
import 'package:chatonym/utils/widgets/error_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Auth_Service/auth_service.dart';
import '../Group_Service/group_service.dart';

// This is the provider for the CLOUD FIRESTORE
final cloudFirestoreProvider = Provider(
  (ref) => FirebaseFirestore.instance,
);
// This is the provider for the [UserService]
final userServiceProvider = Provider(
  (ref) => UserService(ref),
);

final userProvider = StateProvider<AppUser?>(
  (ref) => null,
);

final userGroupsProvider = StreamProvider((ref) {
  return ref.watch(userServiceProvider).getUserGroups();
});

// Class handling all the adding removing and updating of data
// in the cloud firestore
class UserService {
  final Ref _ref;
  UserService(this._ref);

  CollectionReference get _users =>
      _ref.read(cloudFirestoreProvider).collection(FirebaseConst.users);
  String get uid => _ref.read(userProvider)!.uid;

  // This function will add the user to the firestore
  Future<void> addUser(AppUser user, BuildContext context) async {
    _ref.read(userProvider.notifier).update((state) => user);

    try {
      await _users.doc(user.uid).set(
            user.toMap(),
          );
    } catch (e) {
      errorDialog(
        context,
        'Error',
        'Something went wrong while adding the user to the database',
      );
    }
  }

  // This function will update the user name
  Future<void> updateUser(AppUser user, BuildContext context) async {
    try {
      await _users.doc(user.uid).update(user.toMap());
      _ref.read(userProvider.notifier).update((state) => user);
    } catch (e) {
      errorDialog(
        context,
        'Failed to update user',
        'Something went wrong, please try again',
      );
      throw Exception();
    }
  }

  Future<AppUser> getUser(BuildContext context) {
    try {
      return _users
          .doc(_ref.read(firebaseAuthProvider).currentUser!.uid)
          .get()
          .then(
            (value) => AppUser.fromMap(value.data() as Map<String, dynamic>),
          );
    } catch (e) {
      errorDialog(context, 'Something went wrong', 'Please try again');
      throw Exception();
    }
  }

  Stream<List<DBGroup>> getUserGroups() {
    return _users.doc(uid).snapshots().map((event) {
      List<DBGroup> groups =
          AppUser.fromMap(event.data() as Map<String, dynamic>).groups;
      for (int i = 0; i < groups.length; i++) {
        _ref
            .read(groupServiceProvider)
            .getGroupFromId(groups[i].groupID)
            .then((value) {
          groups[i] = groups[i].copyWith(
            name: value.name,
            profile: value.profile,
          );
          return groups;
        });
      }
      return groups;
    });
  }

  Future joinGroup(DBGroup group, BuildContext context) async {
    try {
      await _users.doc(uid).update({
        'groups': FieldValue.arrayUnion([group.toMap()]),
      });
      AppUser user = _ref.read(userProvider.notifier).state!;
      await _ref.read(groupServiceProvider).addUserToGroup(
          group.groupID, DBUser(name: user.name, svg: user.svg));

      _ref.read(userProvider.notifier).update(
        (state) {
          state!.groups.add(group);
          return state;
        },
      );
    } catch (e) {
      errorDialog(
        context,
        'Failed to join group',
        'Something went wrong, please try again',
      );
    }
  }

  void leaveGroup(DBGroup group) async {
    try {
      await _users.doc(uid).update({
        'groups': FieldValue.arrayRemove([group.toMap()]),
      });
      _ref.read(userProvider.notifier).update(
        (state) {
          state!.groups.remove(group);
          return state;
        },
      );
    } catch (e) {
      throw Exception();
    }
  }
}
