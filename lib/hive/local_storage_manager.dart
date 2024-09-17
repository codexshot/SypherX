import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../model/guide.dart';
import '../model/collab_model.dart';

class LocalStorageManager {
  static final LocalStorageManager _singleton = LocalStorageManager._internal();

  static const String BOX_NAME = 'tempo_drafts';
  static const String ENCRYPT_KEY = 'ASDFGHJKLASDFGHJ';
  static const String IN_APP_TUTORIALS_BOX_NAME = 'inAppTutorials';

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late Box<bool> inAppTutorialsBox;
  late Box<String> encryptedBox;

  factory LocalStorageManager() {
    return _singleton;
  }

  LocalStorageManager._internal() {
    generateOrGetKey();
    openBox();
    openInAppTutorialsBox();
  }

  Future<Box<String>> openBox() async {
    var encryptionKey = base64Url.decode(await secureStorage.read(key: ENCRYPT_KEY) ?? '');
    final directory = await getApplicationDocumentsDirectory();

    try {
      await Directory('${directory.path}/dir').create(recursive: true).then((Directory directory) async {
        encryptedBox = await Hive.openBox(
          BOX_NAME,
          path: directory.path,
          encryptionCipher: HiveAesCipher(encryptionKey), // You should define 'encryptionKey' as your encryption key
        );
      });
    } catch (e) {
      print(e);
    }

    /*Directory('${directory.path}/dir')
        .create(recursive: true)
        // The created directory is returned as a Future.
        .then((Directory directory) async {
      draftCollection = await BoxCollection.open(
        'Tempo Explore', // Name of your database
        {BOX_NAME}, // Names of your boxes
        path: directory.path, // Path where to store your boxes (Only used in Flutter / Dart IO)
        key: HiveAesCipher(encryptionKey), // Key to encrypt your boxes (Only used in Flutter / Dart IO)
      );
    });*/
    return encryptedBox;
  }

  Future<void> generateOrGetKey() async {
    var containsEncryptionKey = await secureStorage.read(key: ENCRYPT_KEY);
    if (containsEncryptionKey == null) {
      List<int> key = Hive.generateSecureKey();
      await secureStorage.write(key: ENCRYPT_KEY, value: base64UrlEncode(key));
    }
  }

  Future<void> insertDraft(String key, Collab value) async {
    final jsonString = jsonEncode(value.toMap());
    await encryptedBox.put(value.id, jsonString);
  }

  Future<void> deleteDraft(String key) async {
    await encryptedBox.delete(key);
  }

  Future<List<Guide>?> getAllDrafts() async {
    List<Guide> savedGuides = [];

    final savedString = encryptedBox.values;
    for (var element in savedString) {
      savedGuides.add(Guide.fromJson(element));
      if (kDebugMode) {
        print(element);
      }
    }

    return savedGuides;
  }

  openInAppTutorialsBox() async {
    var encryptionKey = base64Url.decode(await secureStorage.read(key: ENCRYPT_KEY) ?? '');
    final directory = await getApplicationDocumentsDirectory();

    try{
      await Directory('${directory.path}/dir').create(recursive: true).then((Directory directory) async {
        inAppTutorialsBox = await Hive.openBox(
          IN_APP_TUTORIALS_BOX_NAME,
          path: directory.path,
          encryptionCipher: HiveAesCipher(encryptionKey), // You should define 'encryptionKey' as your encryption key
        );
      });
    }catch(e){

    }

  }

  Future<bool> getTutorialBool(String key) async {
    final tutorialMap = inAppTutorialsBox.get(key);
    return tutorialMap != null;
  }

  Future<void> setTutorialBool(String key, bool value) async {
    await inAppTutorialsBox.put(key, value);
  }

// ------------------------------------------------------------------------
// Future<bool> getBool() async {
//   return prefs?.getBool(variable) ?? false;
// }
// Future<void> setBool(bool value) async {
//   await prefs?.setBool(variable, value);
// }
}
