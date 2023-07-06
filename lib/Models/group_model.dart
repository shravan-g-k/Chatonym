import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:chatonym/Models/user_model.dart';

class DBGroup {
  final String name;
  final String? profile;
  final String groupID;
  final double lastMessageRead;
  DBGroup({
    required this.name,
    this.profile,
    required this.groupID,
    required this.lastMessageRead,
  });

  DBGroup copyWith({
    String? name,
    String? profile,
    String? groupID,
    double? lastMessageRead,
  }) {
    return DBGroup(
      name: name ?? this.name,
      profile: profile ?? this.profile,
      groupID: groupID ?? this.groupID,
      lastMessageRead: lastMessageRead ?? this.lastMessageRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profile': profile,
      'groupID': groupID,
      'lastMessageRead': lastMessageRead,
    };
  }

  factory DBGroup.fromMap(Map<String, dynamic> map) {
    return DBGroup(
      name: map['name'] ?? '',
      profile: map['profile'],
      groupID: map['groupID'] ?? '',
      lastMessageRead: map['lastMessageRead']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DBGroup.fromJson(String source) => DBGroup.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DBGroup(name: $name, profile: $profile, groupID: $groupID, lastMessageRead: $lastMessageRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DBGroup &&
      other.name == name &&
      other.profile == profile &&
      other.groupID == groupID &&
      other.lastMessageRead == lastMessageRead;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      profile.hashCode ^
      groupID.hashCode ^
      lastMessageRead.hashCode;
  }
}

class Group {
  final String name;
  final String queryName;
  final String description;
  final String? banner;
  final String? profile;
  final List<DBUser> members;
  final dynamic postion;
  final String groupID;
  Group({
    required this.name,
    required this.queryName,
    required this.description,
    this.banner,
    this.profile,
    required this.members,
    required this.postion,
    required this.groupID,
  });

  Group copyWith({
    String? name,
    String? queryName,
    String? description,
    String? banner,
    String? profile,
    List<DBUser>? members,
    dynamic postion,
    String? groupID,
  }) {
    return Group(
      name: name ?? this.name,
      queryName: queryName ?? this.queryName,
      description: description ?? this.description,
      banner: banner ?? this.banner,
      profile: profile ?? this.profile,
      members: members ?? this.members,
      postion: postion ?? this.postion,
      groupID: groupID ?? this.groupID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'queryName': queryName,
      'description': description,
      'banner': banner,
      'profile': profile,
      'members': members.map((x) => x.toMap()).toList(),
      'postion': postion,
      'groupID': groupID,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      name: map['name'] ?? '',
      queryName: map['queryName'] ?? '',
      description: map['description'] ?? '',
      banner: map['banner'],
      profile: map['profile'],
      members: List<DBUser>.from(map['members']?.map((x) => DBUser.fromMap(x))),
      postion: map['postion'],
      groupID: map['groupID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Group(name: $name, queryName: $queryName, description: $description, banner: $banner, profile: $profile, members: $members, postion: $postion, groupID: $groupID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Group &&
        other.name == name &&
        other.queryName == queryName &&
        other.description == description &&
        other.banner == banner &&
        other.profile == profile &&
        listEquals(other.members, members) &&
        other.postion == postion &&
        other.groupID == groupID;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        queryName.hashCode ^
        description.hashCode ^
        banner.hashCode ^
        profile.hashCode ^
        members.hashCode ^
        postion.hashCode ^
        groupID.hashCode;
  }
}
