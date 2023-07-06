import 'dart:io';
import 'dart:typed_data';
import 'package:chatonym/Backend/Cloud_Service/User_Service/user_service.dart';
import 'package:chatonym/Backend/Storage_Service/storage_service.dart';
import 'package:chatonym/Constants/firebase_consts.dart';
import 'package:chatonym/utils/widgets/error_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '../../../Constants/class_consts.dart';
import '../../../Models/group_model.dart';
import '../../../Models/user_model.dart';

final groupServiceProvider = Provider<GroupService>((ref) {
  return GroupService(ref);
});

final nearbyGroupsProvider =
    StreamProvider.family<List<Group>, Locate>((ref, Locate locate) {
  return ref
      .read(groupServiceProvider)
      .getGroupsWithinRadius(locate.radius, locate.center);
});

class GroupService {
  final Ref _ref;
  GroupService(this._ref);

// Firebase group collection
  CollectionReference get groupCollection =>
      _ref.read(cloudFirestoreProvider).collection(FirebaseConst.groups);

// Create Groups
  Future<bool> createGroup({
    required String name,
    required String desc,
    required BuildContext context,
    required dynamic geoPoint,
    File? mobileBanner,
    File? mobileProfile,
    Uint8List? webBanner,
    Uint8List? webProfile,
  }) async {
    StorageService storageService = StorageService();
    String? bannerUrl;
    String? profileUrl;
    try {
      if (mobileBanner != null) {
        bannerUrl = await storageService.uploadGroupImage(
            isBanner: true, mobileImage: mobileBanner);
      } else if (webBanner != null) {
        bannerUrl = await storageService.uploadGroupImage(
            isBanner: true, webImage: webBanner);
      }
      if (mobileProfile != null) {
        profileUrl = await storageService.uploadGroupImage(
            isBanner: false, mobileImage: mobileProfile);
      } else if (webProfile != null) {
        profileUrl = await storageService.uploadGroupImage(
            isBanner: false, webImage: webProfile);
      }

      AppUser user = _ref.read(userProvider.notifier).state!;

      DBUser dbUser = DBUser(name: user.name, svg: user.svg);
      DocumentReference documentReference = groupCollection.doc();
      Group group = Group(
        name: name,
        queryName: name.toLowerCase(),
        description: desc,
        banner: bannerUrl,
        profile: profileUrl,
        members: [dbUser],
        postion: geoPoint,
        groupID: documentReference.id,
      );
      await documentReference.set(group.toMap());

      if (context.mounted) {
        List<DBGroup> groups = user.groups +
            [
              DBGroup(
                name: name,
                groupID: documentReference.id,
                profile: group.profile,
                lastMessageRead: 0,
              )
            ];
        _ref
            .read(userServiceProvider)
            .updateUser(user.copyWith(groups: groups), context);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

// search for groups with the given radius
  Stream<List<Group>> getGroupsWithinRadius(
      double radius, GeoFirePoint center) {
    GeoFlutterFire geo = GeoFlutterFire();
    CollectionReference firestore =
        _ref.read(cloudFirestoreProvider).collection(FirebaseConst.groups);
    return geo
        .collection(collectionRef: firestore)
        .within(
          center: center,
          radius: radius,
          field: 'postion',
          strictMode: true,
        )
        .map((event) => event
            .map((e) => Group.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

// search for groups with the given query
  Future<List<Group>> searchGroups(String query) async {
    List<Group> queryGroups = await groupCollection
        .where('queryName', isGreaterThanOrEqualTo: query.toLowerCase())
        .where(
          'queryName',
          isLessThan: '${query.toLowerCase()}z',
        )
        .get()
        .then(
      (value) {
        List<Group> groups = value.docs
            .map((e) => Group.fromMap(e.data() as Map<String, dynamic>))
            .toList();

        return groups;
      },
    );
    return queryGroups;
  }

// Add user to group
  Future addUserToGroup(String groupID, DBUser user) async {
    await groupCollection.doc(groupID).update({
      'members': FieldValue.arrayUnion([user.toMap()])
    });
  }

// Get group from id
  Future<Group> getGroupFromId(String groupID) async {
    return groupCollection.doc(groupID).get().then(
      (value) {
        Group group = Group.fromMap(value.data() as Map<String, dynamic>);
        return group;
      },
    );
  }

// Remove user from group
  Future<bool> removeUserFromGroup(DBGroup group) async {
    AppUser user = _ref.read(userProvider.notifier).state!;
    try {
      await groupCollection.doc(group.groupID).update(
        {
          'members': FieldValue.arrayRemove(
              [DBUser(name: user.name, svg: user.svg).toMap()])
        },
      );
      _ref.read(userServiceProvider).leaveGroup(group);
      return true;
    } catch (e) {
      return false;
    }
  }

// Update group
  Future<bool> updateGroup({
    required Group group,
    File? mobileBanner,
    File? mobileProfile,
    Uint8List? webBanner,
    Uint8List? webProfile,
    String? name,
    String? desc,
    required BuildContext context,
  }) async {
    StorageService storageService = StorageService();
    String? bannerUrl;
    String? profileUrl;
    try {
      if (mobileBanner != null) {
        bannerUrl = await storageService.uploadGroupImage(
            isBanner: true, mobileImage: mobileBanner);
      } else if (webBanner != null) {
        bannerUrl = await storageService.uploadGroupImage(
            isBanner: true, webImage: webBanner);
      }
      if (mobileProfile != null) {
        profileUrl = await storageService.uploadGroupImage(
            isBanner: false, mobileImage: mobileProfile);
      } else if (webProfile != null) {
        profileUrl = await storageService.uploadGroupImage(
            isBanner: false, webImage: webProfile);
      }
      Group newGroup = group.copyWith(
        name: name ?? group.name,
        queryName: name != null ? name.toLowerCase() : group.queryName,
        description: desc ?? group.description,
        banner: bannerUrl ?? group.banner,
        profile: profileUrl ?? group.profile,
      );
      await groupCollection.doc(group.groupID).update(newGroup.toMap());
      AppUser user = _ref.read(userProvider)!;
      if (context.mounted) {
        _ref.read(userServiceProvider).updateUser(
            user.copyWith(
              groups: user.groups
                  .map((e) => e.groupID == group.groupID
                      ? e.copyWith(name: name, profile: newGroup.profile)
                      : e)
                  .toList(),
            ),
            context,);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void updateUserOfGroup(
      DBUser oldUser, DBUser user, String groupID, BuildContext context) {
    try {
      groupCollection.doc(groupID).update({
        'members': FieldValue.arrayRemove([oldUser.toMap()])
      });
      groupCollection.doc(groupID).update({
        'members': FieldValue.arrayUnion([user.toMap()])
      });
    } catch (e) {
      errorDialog(
        context,
        'Something went Wrong',
        'Please try again later',
      );
    }
  }
}
