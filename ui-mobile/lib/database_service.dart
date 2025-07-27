import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add document
  Future<void> addUser(String uid, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(uid).set(userData);
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  // Get document
  Future<DocumentSnapshot> getUser(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  // Update document
  Future<void> updateUser(String uid, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(uid).update(userData);
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Delete document
  Future<void> deleteUser(String uid) async {
    try {
      await _db.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  // Get collection stream
  Stream<QuerySnapshot> getUsersStream() {
    return _db.collection('users').snapshots();
  }
}