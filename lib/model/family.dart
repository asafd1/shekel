import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shekel/model/user.dart';
import 'package:uuid/uuid.dart';

class Family {
  late String id;
  String name;
  String? imageUrl;
  List<User> parents = [];
  List<User> children = [];
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

  factory Family(String name, String? image) {
    var id = const Uuid().v4();
    var now = DateTime.now();
    return Family._(
      id,
      name,
      image,
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

  void addParent(User parent) {
    parents.add(parent);
    updatedAt = Timestamp.fromDate(DateTime.now());
  }

  void addChild(User child) {
    children.add(child);
    updatedAt = Timestamp.fromDate(DateTime.now());
  }

  // create factory method to convert json to object of this class
  factory Family.fromJson(Map<String, dynamic> json) {
    // safely cast from dynamic list to User list
    List<dynamic> parentsDynamicList = json['parents'];
    List<User> parents = parentsDynamicList.cast<User>();
    List<dynamic> childrenDynamicList = json['children'];
    List<User> children = childrenDynamicList.cast<User>();
    
    return Family._(
      json['id'],
      json['name'],
      json['image'],
      parents,
      children,
      json['createdAt'],
      json['updatedAt'],
    );
  }

  // create method to convert object to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": imageUrl,
        "parents": parents,
        "children": children,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
