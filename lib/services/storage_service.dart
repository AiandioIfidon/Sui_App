import 'package:shared_preferences/shared_preferences.dart';


class WalletStorage {

  static Future<int> getBalance() async {
    final preferences = await SharedPreferences.getInstance();
    int value = preferences.getInt('Cups_balance') ?? 0;
    return value;
  }
  
  static Future<void> incrementBalance() async {
    final preferences = await SharedPreferences.getInstance();
    int balance = preferences.getInt('Cups_balance') ?? 0;
    balance++;
    preferences.setInt('Cups_balance', balance);
  }

  static Future<void> clearWallet() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear(); // deletes anything stored with shared_preferences.
  }
}