import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Transaction {
  late String id;
  String userId;
  num amount;
  String description;
  late DateTime createdAt;

  Transaction._(
    this.id,
    this.userId,
    this.amount,
    this.description,
    this.createdAt,
  );

  factory Transaction({
    required userId,
    required amount,
    required description,
    DateTime? datetime,
  }) {
    var id = const Uuid().v4();
    datetime ??= DateTime.now();
    return Transaction._(id, userId, amount, description, datetime);
  }

  // create factory method to convert json to object of this class
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction._(
      json['id'],
      json['userId'],
      json['amount'],
      json['description'],
      json['createdAt'].toDate(),
    );
  }

  // create method to convert object to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "amount": amount,
        "description": description,
        "createdAt": Timestamp.fromDate(createdAt),
      };
}
