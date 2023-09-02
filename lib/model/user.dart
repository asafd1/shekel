import 'package:uuid/uuid.dart';

enum Role {  
  parent,
  child, 
}
  

class User {
  String id;
  String familyId;
  Role role;
  String username;
  String firstName;
  String lastName;
  String image;
  int balance;
  DateTime createdAt;
  DateTime updatedAt;

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

  factory User(familyId, role, username, firstName, lastName, image) {
    var id = const Uuid().v4();
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
      now,
      now,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User._(
      json['id'],
      json['familyId'],
      json['role'],
      json['username'],
      json['firstName'],
      json['lastName'],
      json['image'],
      json['balance'],
      DateTime.parse(json['createdAt']),
      DateTime.parse(json['updatedAt']),
    );
  }

  // create method to convert object to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "familyId": familyId,
        "role": role,
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
        "balance": balance,
        "created_at": createdAt,
        "updated_at": updatedAt,
  };
}