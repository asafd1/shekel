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
  Future<Family> createFamily(String name, String? imageUrl) async {
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
  Future<Family> getFamily(String familyId) async {
    CollectionReference families = firestore.collection('families');
    DocumentSnapshot snapshot = await families.doc(familyId).get();
    if (!snapshot.exists) {
      throw StateError('Family with ID $familyId does not exist.');
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

  // a method to create a transaction
  Future<shekel.Transaction> createTransaction(
      String userId, num amount, String description, DateTime datetime) async {
    var transaction = shekel.Transaction(userId: userId, amount: amount, description: description, datetime: datetime);

    CollectionReference transactions = firestore.collection('transactions');
    transactions.doc(transaction.id).set(transaction.toJson());

    // update user balance
    var user = await getUser(userId);
    user.balance += amount;
    updateUser(user);

    return transaction;
  }

  // a method to remove a transaction
  Future<bool> removeTransaction(String transactionId) async {
    CollectionReference transactions = firestore.collection('transactions');
    var transaction = await getTransaction(transactionId);
    await transactions.doc(transactionId).delete();

    // update user balance
    var user = await getUser(transaction.userId);
    user.balance -= transaction.amount;
    await updateUser(user);
    return Future.value(true);
  }

  Future<shekel.Transaction> getTransaction(String transactionId) async {
    CollectionReference transactions = firestore.collection('transactions');
    DocumentSnapshot snapshot = await transactions.doc(transactionId).get();
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
    var family = await getFamily(familyId);
    user.familyId = familyId;
    family.addUser(user, user.role);
    await updateUser(user);
    await updateFamily(family);
    return family;
  }

  Future<Family> _removeUserFromFamily(String familyId, User user) async {
    var family = await getFamily(familyId);
    family.removeUser(user.id, user.role);
    user.familyId = null;
    await updateUser(user);
    await updateFamily(family);
    return family;
  }

  // a method to create a user
  User createUser(User user) {
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
    var user = await getUser(userId);
    await _removeUserFromFamily(user.familyId!, user);
    await users.doc(userId).delete();
    return Future.value(true);
  }

  // a method to update a user
  Future<bool> updateUser(User user) async {
    CollectionReference users = firestore.collection('users');
    await users.doc(user.id).update(user.toJson());
    return Future.value(true);
  }

  // a method to get a user
  Future<User> getUser(String userId) async {
    CollectionReference users = firestore.collection('users');
    DocumentSnapshot snapshot = await users.doc(userId).get();
    return User.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  // a method to get a user by username
  Future<User?> getUserByUsername(String username) async {
    CollectionReference users = firestore.collection('users');
    QuerySnapshot snapshot =
        await users.where('username', isEqualTo: username).get();
    if (snapshot.docs.isEmpty) {
      return Future.value(null);
    }
    return User.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
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
