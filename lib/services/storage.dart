import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';

const String AVATAR = 'avatar';

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

Future<String> uploadUserAvatar(File file, String userId) {
  return uploadFile(file, AVATAR + '/' + userId);
}

Future<String> downloadUserAvatar(String userId) async {
  return await downloadFile(AVATAR + '/' + userId);
}

Future<String> uploadFile(File file, String path) async {
  try {
    UploadTask task = storage.ref(path)
        .putFile(file);
    String avatarUrl;
    await task.whenComplete(() {}).then((value) async {
      avatarUrl = await value.ref.getDownloadURL();
    });
    return avatarUrl;
  } on firebase_core.FirebaseException catch (e)  {
    print(e.message);
  }
  return "";
}

Future<String> downloadFile(String address) async {
  try {
    String url = await storage
        .ref(address)
        .getDownloadURL();
    return url;
  } on firebase_core.FirebaseException catch (e) {
    print(e.message);
  }
  return null;
}