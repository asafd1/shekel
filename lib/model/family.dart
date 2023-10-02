import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shekel/model/user.dart';
import 'package:uuid/uuid.dart';

class Family {
  late String id;
  String name;
  String? imageUrl;
  late List<User> parents;
  late List<User> children;
  Timestamp createdAt;
  Timestamp updatedAt;

  Family._(
    this.id,
    this.name,
    this.imageUrl,
    this.parents,
    this.children,
    this.createdAt,
    this.updatedAt,
  );

  factory Family({required String name, String? imageUrl}) {
    var id = const Uuid().v4();
    var now = DateTime.now();
    return Family._(
      id,
      name,
      imageUrl,
      [],
      [],
      Timestamp.fromDate(now),
      Timestamp.fromDate(now),
    );
  }

  void update(String newName, String newImage) {
    name = newName;
    imageUrl = newImage;
    updatedAt = Timestamp.fromDate(DateTime.now());
  }

  void addUser(User user, Role role) {
    var list = role == Role.parent ? parents : children;
    list.add(user);
    updatedAt = Timestamp.fromDate(DateTime.now());
  }

  void removeUser(String userId, Role role) {
    var list = role == Role.parent ? parents : children;
    list.removeWhere((userId) => userId == userId);
    updatedAt = Timestamp.fromDate(DateTime.now());
  }

  // create factory method to convert json to object of this class
  factory Family.fromJson(Map<String, dynamic> json) {    
    return Family._(
      json['id'],
      json['name'],
      json['image'],
      [], // parents
      [], // children
      json['createdAt'],
      json['updatedAt'],
    );
  }

  // create method to convert object to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": imageUrl,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
