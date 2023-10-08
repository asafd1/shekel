import 'package:cloud_firestore/cloud_firestore.dart';

enum Role {  
  parent,
  child, 
}

class User {
  String id;
  String? familyId;
  Role role;
  String username;
  String firstName;
  String lastName;
  String? image;
  num balance;
  Timestamp createdAt;
  Timestamp updatedAt;

  User._(
    this.id,
    this.familyId,
    this.role,
    this.username,
    this.firstName,
    this.lastName,
    this.image,
    this.balance,
    this.createdAt,
    this.updatedAt,
  );

  factory User({familyId, id, role, username, firstName, lastName, image}) {
    var balance = 0;
    var now = DateTime.now();
    return User._(
      id,
      familyId,
      role,
      username,
      firstName,
      lastName,
      image,
      balance,
      Timestamp.fromDate(now),
      Timestamp.fromDate(now),
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User._(
      json['id'],
      json['familyId'],
      Role.values.byName(json['role']),
      json['username'],
      json['firstName'],
      json['lastName'],
      json['image'],
      json['balance'],
      json['createdAt'],
      json['updatedAt'],
    );
  }

  // create method to convert object to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "familyId": familyId,
        "role": role.name,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
        "balance": balance,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
  };
}