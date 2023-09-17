import 'package:uuid/uuid.dart';

class Transaction {
  late String id;
  String userId;
  num amount;
  late DateTime createdAt;

  Transaction._(
    this.id, 
    this.userId, 
    this.amount, 
    this.createdAt, 
  );

  factory Transaction(String userId, num amount) {
    var id = const Uuid().v4();
    var now = DateTime.now();
    return Transaction._(id, userId, amount, now);
  }

  // create factory method to convert json to object of this class
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction._(
      json['id'],
      json['userId'],
      json['amount'],
      json['createdAt'],
    );
  }

  // create method to convert object to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "amount": amount,
        "created_at": createdAt,
      };
}