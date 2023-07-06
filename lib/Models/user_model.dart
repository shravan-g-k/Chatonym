import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:chatonym/Models/group_model.dart';

class DBUser {
  final String name;
  final String svg;
  DBUser({
    required this.name,
    required this.svg,
  });

  DBUser copyWith({
    String? name,
    String? svg,
  }) {
    return DBUser(
      name: name ?? this.name,
      svg: svg ?? this.svg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'svg': svg,
    };
  }

  factory DBUser.fromMap(Map<String, dynamic> map) {
    return DBUser(
      name: map['name'] ?? '',
      svg: map['svg'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DBUser.fromJson(String source) => DBUser.fromMap(json.decode(source));

  @override
  String toString() => 'DBUser(name: $name, svg: $svg)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DBUser &&
      other.name == name &&
      other.svg == svg;
  }

  @override
  int get hashCode => name.hashCode ^ svg.hashCode;
}


class AppUser {
  final String name;
  final String uid;
  final String svg;
  final List<DBGroup> groups;
  AppUser({
    required this.name,
    required this.uid,
    required this.svg,
    required this.groups,
  });

  AppUser copyWith({
    String? name,
    String? uid,
    String? svg,
    List<DBGroup>? groups,
  }) {
    return AppUser(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      svg: svg ?? this.svg,
      groups: groups ?? this.groups,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'svg': svg,
      'groups': groups.map((x) => x.toMap()).toList(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      svg: map['svg'] ?? '',
      groups: List<DBGroup>.from(map['groups']?.map((x) => DBGroup.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(name: $name, uid: $uid, svg: $svg, groups: $groups)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AppUser &&
      other.name == name &&
      other.uid == uid &&
      other.svg == svg &&
      listEquals(other.groups, groups);
  }

  @override
  int get hashCode {
    return name.hashCode ^
      uid.hashCode ^
      svg.hashCode ^
      groups.hashCode;
  }
}
