import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:async';

const String AVATAR = 'avatar';

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

Future<void> uploadUserAvatar(File file, String userId) {
  return uploadFile(file, AVATAR + '/' + userId);
}

Future<String> downloadUserAvatar(String userId) async {
  return await downloadFile(AVATAR + '/' + userId);
}

Future<void> uploadFile(File file, String path) async {
  try {
    await storage
        .ref(path)
        .putFile(file);
  } on firebase_core.FirebaseException catch (e)  {
    print(e.message);
  }
}

Future<String> downloadFile(String address) async {
  try {
    String url = await firebase_storage.FirebaseStorage.instance
        .ref(address)
        .getDownloadURL();
    return url;
  } on firebase_core.FirebaseException catch (e) {
    print(e.message);
  }
  return null;
}