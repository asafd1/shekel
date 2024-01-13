import 'dart:io';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shekel/widgets/delete_confirmation.dart';

bool isValidUrl(String url) {
  return Uri.parse(url).isAbsolute;
}

bool isValidEmail(String email) {
  return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

Future<bool> showDeleteConfirmation(BuildContext context, String text) async {
  return await showModalBottomSheet<bool>(
        context: context,
        builder: (BuildContext context) => DeleteConfirmationWidget(text),
      ) ??
      false;
}

// Upload a file to Google Cloud Storage.
Future<Uri> uploadFile(File file, String path) async {
  final storage = FirebaseStorage.instance;
  final reference = storage.ref(path);

  await reference.putFile(file);
  return Uri.parse(await reference.getDownloadURL());
}

// Upload a file to Google Cloud Storage.
// Future<void> loadFile(File file, String path) async {
//   final storage = FirebaseStorage.instance;
//   final reference = storage.ref(path);

//   await reference.putFile(file);
// }

Future<File> getFileByUri(String url) async {
  Uri uri = Uri.parse(Uri.decodeFull(url));
  // Check if the file is cached on the device.
  final directory = await getApplicationDocumentsDirectory();
  String filename = '${directory.path}/${hash(uri.toString())}_${uri.pathSegments.last}';
  final file = File(filename);
  if (!file.existsSync()) {
    // Download to the file if not cached.
    final response = await http.get(uri);
    await file.writeAsBytes(response.bodyBytes);
  }

  return file;
}

String hash(String str) {
  final bytes = utf8.encode(str);
  final digest = sha256.convert(bytes);
  return digest.toString();
}