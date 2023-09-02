import 'package:uuid/uuid.dart';

class Family {
  late String id;
  String name;
  String? image;
  late DateTime createdAt;
  late DateTime updatedAt;

  Family._(
    this.id, 
    this.name, 
    this.image, 
    this.createdAt, 
    this.updatedAt,
  );

  factory Family(String name, String image) {
    var id = const Uuid().v4();
    var now = DateTime.now();
    return Family._(id, name, image, now, now);
  }

  void update(String newName, String newImage) {
    name = newName;
    image = newImage;
    updatedAt = DateTime.now();
  }

  // create factory method to convert json to object of this class
  factory Family.fromJson(Map<String, dynamic> json) {
    return Family._(
      json['id'],
      json['name'],
      json['image'],
      json['createdAt'],
      json['updatedAt'],
    );
  }

  // create method to convert object to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}