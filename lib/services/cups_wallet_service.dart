import 'package:flutter/material.dart';

import '../providers/secure_storage_provider.dart';

class WalletStorage {

  static Future<int> getBalance() async {
    final String? value = await storage.read(key: 'Cups_Balance');
    int balance = int.tryParse(value ?? '0') ?? 0;
    return balance;
  }

  static Future<void> clearWallet() async {
    int balance = await getBalance();
    for(int i = 0; i < balance; i++) { // if balnace is 0 the code in the forloop won't even execute
      await storage.delete(key: 'Cup_Digest_$i'); // delete Cup digests as they are stored starting from 0, 1, ...
    }
    await storage.delete(key: 'Cups_Balance'); // deletes anything stored with shared_preferences.
  }

  static Future<bool> storeFromTransaction(String digest) async {
    int balance = await getBalance();
    try {
      await storage.write(key: 'Cup_Digest_${balance - 1}', value: digest);
    } catch (e) {
      debugPrint('Failed to store using digest\n $e');
      return false;
    }
    balance++;
    await storage.write(key: 'Cups_Balance', value: balance.toString());
    return true;
  }

  static Future<List<String>> loadCups() async {
    int balance = await getBalance();
    List<String> cups = [];
    for(int i = 0; i < balance; i++){
      String cup = await storage.read(key: 'Cup_Digest_$i') ?? '';
      if(cup.isEmpty){
        debugPrint('There is something wrong with the way you cups are stored');
        break;
      }
      cups.add(cup);
    }
    return cups;
  }
}
