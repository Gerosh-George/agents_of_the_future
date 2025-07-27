import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file
  Future<String?> uploadFile(File file, String path) async {
    try {
      TaskSnapshot snapshot = await _storage.ref(path).putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  // Delete file
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref(path).delete();
    } catch (e) {
      print('Delete error: $e');
    }
  }

  // Get download URL
  Future<String> getDownloadURL(String path) async {
    return await _storage.ref(path).getDownloadURL();
  }
}