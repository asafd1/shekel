import '../model/user.dart';
import '../model/family.dart';
import '../model/transaction.dart' as shekel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DefaultService {
  late FirebaseFirestore firestore;

  DefaultService(FirebaseApp app) {
    firestore = FirebaseFirestore.instanceFor(app: app);
  }

  // // Listen for changes to the data.
  // myRef.snapshots().listen((snapshot) {
  //   // Do something with the data.
  //   for (DocumentSnapshot doc in snapshot.docs) {
  //     print(doc.data());
  //   }
  // });

  Future<Map<String, dynamic>> docToJson(DocumentReference<Object?> doc) async {
    return (await doc.get()).data() as Map<String, dynamic>;
  }

  // a method to create a family
  Future<Family> createFamily(String name, [String? imageUrl]) async {
    var family = Family(name: name, imageUrl: imageUrl);

    CollectionReference families = firestore.collection('families');
    await families.doc(family.id).set(family.toJson());
    return family;
  }

  // a method to remove a family
  Future<bool> removeFamily(String familyId) async {
    CollectionReference families = firestore.collection('families');
    await families.doc(familyId).delete();
    return Future.value(true);
  }

  // a method to update a family
  Future<Family> updateFamily(Family family) async {
    CollectionReference families = firestore.collection('families');
    await families.doc(family.id).update(family.toJson());
    return family;
  }

  // a method to get a family
  Future<Family?> getFamily(String familyId) async {
    CollectionReference families = firestore.collection('families');
    DocumentSnapshot snapshot = await families.doc(familyId).get();
    if (!snapshot.exists) {
      return Future.value(null);
    }
    Family family = Family.fromJson(snapshot.data() as Map<String, dynamic>);
    family.parents = (await getUsers(familyId))
        .where((user) => user.role == Role.parent)
        .toList();
    family.children = (await getUsers(familyId))
        .where((user) => user.role == Role.child)
        .toList();
    return family;
  }

  Future<bool> isFamilyExists(String familyId) async {
    CollectionReference families = firestore.collection('families');
    DocumentSnapshot snapshot = await families.doc(familyId).get();
    return snapshot.exists;
  }

  // a method to create a transaction
  Future<shekel.Transaction> createTransaction(
      String userId, num amount, String description, DateTime datetime) async {
    var transaction = shekel.Transaction(userId: userId, amount: amount, description: description, datetime: datetime);

    CollectionReference transactions = firestore.collection('transactions');
    transactions.doc(transaction.id).set(transaction.toJson());

    // update user balance
    User? user = await getUser(userId);
    if (user == null) {
      return Future.error('User with ID $userId does not exist.');
    }
    user.balance += amount;
    updateUser(user);

    return transaction;
  }

  // a method to remove a transaction
  Future<bool> removeTransaction(String transactionId) async {
    CollectionReference transactions = firestore.collection('transactions');
    shekel.Transaction? transaction = await _getTransaction(transactionId);
    if (transaction == null) {
      return Future.error('Transaction with ID $transactionId does not exist.');
    }
    await transactions.doc(transactionId).delete();

    // update user balance
    User? user = await getUser(transaction.userId);
    if (user == null) {
      return Future.error('User with ID ${transaction.userId} does not exist.');
    }
    user.balance -= transaction.amount;
    await updateUser(user);
    return Future.value(true);
  }

  Future<shekel.Transaction?> _getTransaction(String transactionId) async {
    CollectionReference transactions = firestore.collection('transactions');
    DocumentSnapshot snapshot = await transactions.doc(transactionId).get();
    if (!snapshot.exists) {
      return Future.value(null);
    }
    return shekel.Transaction.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  // a method to get ordered last X transactions per user
  Future<List<shekel.Transaction>> getTransactions(
      String userId, int limit) async {
    CollectionReference transactions = firestore.collection('transactions');
    // get all transactions by familyId and userId
    QuerySnapshot snapshot = await transactions
    .where('userId', isEqualTo: userId)
    .limit(limit)
    .orderBy('createdAt', descending: true)
    .get();
    return snapshot.docs
        .map((doc) =>
            shekel.Transaction.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Family> _addUserToFamily(String familyId, User user) async {
    Family? family = await getFamily(familyId);
    if (family == null) {
      return Future.error('Family with ID $familyId does not exist.');
    }
    user.familyId = familyId;
    family.addUser(user, user.role);
    await updateUser(user);
    return family;
  }

  Future<Family> _removeUserFromFamily(String familyId, User user) async {
    Family? family = await getFamily(familyId);
    if (family == null) {
      return Future.error('Family with ID $familyId does not exist.');
    }
    family.removeUser(user.id, user.role);
    await updateFamily(family);
    return family;
  }

  // a method to create a user
  User createUser({String? familyId, required String id, required Role role, required String username, String? firstName, String? lastName, String? image}) {
    User user = User(familyId: familyId, id: id, username: username, role: role, firstName: firstName, lastName: lastName, image: image); 

    CollectionReference users = firestore.collection('users');
    users.doc(user.id).set(user.toJson());

    if (user.familyId != null) {
      _addUserToFamily(user.familyId!, user);
    }
    return user;
  }

  // a method to remove a user
  Future<bool> removeUser(String userId) async {
    CollectionReference users = firestore.collection('users');
    User? user = await getUser(userId);
    if (user == null) {
      return Future.error('User with ID $userId does not exist.');
    }
    await users.doc(userId).delete();
    await _removeUserFromFamily(user.familyId!, user);
    return Future.value(true);
  }

  // a method to update a user
  Future<bool> updateUser(User user) async {
    CollectionReference users = firestore.collection('users');
    await users.doc(user.id).update(user.toJson());
    return Future.value(true);
  }

  // a method to get a user
  Future<User?> getUser(String userId) async {
    CollectionReference users = firestore.collection('users');
    DocumentSnapshot snapshot = await users.doc(userId).get();
    if (snapshot.data() == null) {
      return Future.value(null);
    }
    return User.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  // a method to get all users per family
  Future<List<User>> getUsers(String familyId) async {
    CollectionReference users = firestore.collection('users');
    QuerySnapshot snapshot =
        await users.where('familyId', isEqualTo: familyId).get();
    return snapshot.docs
        .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
