import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);

IOSOptions _getIOSOptions() => const IOSOptions(
  accessibility: KeychainAccessibility.first_unlock, // apple uses keychain while android uses AES
);

final FlutterSecureStorage storage = FlutterSecureStorage(
  aOptions: _getAndroidOptions(),
  iOptions: _getIOSOptions(),
);


// Read all values
// Map<String, String> allValues = await storage.readAll();

// // Delete value
// await storage.delete(key: key);

// // Delete all
// await storage.deleteAll();
