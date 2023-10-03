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
  void removeFamily(String familyId) {
    CollectionReference families = firestore.collection('families');
    families.doc(familyId).delete();
  }

  // a method to update a family
  void updateFamily(Family family) {
    CollectionReference families = firestore.collection('families');
    families.doc(family.id).update(family.toJson());
  }

  // a method to get a family
  Future<Family> getFamily(String familyId) async {
    CollectionReference families = firestore.collection('families');
    DocumentSnapshot snapshot = await families.doc(familyId).get();
    if (!snapshot.exists) {
      throw StateError('Family with ID $familyId does not exist.');
    }
    Family family = Family.fromJson(snapshot.data() as Map<String, dynamic>);
    family.parents = (await getUsers(familyId)).where((user) => user.role == Role.parent).toList();
    family.children = (await getUsers(familyId)).where((user) => user.role == Role.child).toList();
    return family;
  }

  // a method to create a transaction
  Future<(shekel.Transaction, num)> createTransaction(String userId, num amount) async {
    var transaction = shekel.Transaction(userId, amount);
  
    CollectionReference transactions = firestore.collection('transactions');
    transactions.doc(transaction.id).set(transaction.toJson());
    
    // update user balance
    var user = await getUser(userId);
    user.balance += amount;
    updateUser(user);

    return (transaction, user.balance);
  }
  
  // a method to get ordered last X transactions per user
  Future<List<shekel.Transaction>> getTransactions(String userId, int limit) async {
    CollectionReference transactions = firestore.collection('transactions');
    QuerySnapshot snapshot = await transactions.where('userId', isEqualTo: userId).limit(limit).orderBy('createdAt').get();
    return snapshot.docs.map((doc) => shekel.Transaction.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  _addUserToFamily(String familyId, User user) async {
    var family = await getFamily(familyId);
    user.familyId = familyId;
    family.addUser(user, user.role);
    updateUser(user);
    updateFamily(family);
  }

  _removeUserFromFamily(String familyId, User user) async {
    var family = await getFamily(familyId);
    family.removeUser(user.id, user.role);
    user.familyId = null;
    updateUser(user);
    updateFamily(family);
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
  void removeUser(String userId) async {
    CollectionReference users = firestore.collection('users');
    var user = await getUser(userId);
    await _removeUserFromFamily(user.familyId!, user);
    users.doc(userId).delete();
  }

  // a method to update a user
  void updateUser(User user) {
    CollectionReference users = firestore.collection('users');
    users.doc(user.id).update(user.toJson());
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
    QuerySnapshot snapshot = await users.where('username', isEqualTo: username).get();
    if (snapshot.docs.isEmpty) {
      return Future.value(null);      
    }
    return User.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
  }

  // a method to get all users per family
  Future<List<User>> getUsers(String familyId) async {
    CollectionReference users = firestore.collection('users');
    QuerySnapshot snapshot = await users.where('familyId', isEqualTo: familyId).get();
    return snapshot.docs.map((doc) => User.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }
}
