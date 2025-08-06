import '../providers/secure_storage_provider.dart';

class WalletStorage {

  static Future<int> getBalance() async {
    final String? value = await storage.read(key: 'Cups_Balance');
    int balance = int.tryParse(value ?? '0') ?? 0;
    return balance;
  }
  
  static Future<void> incrementBalance() async {
    final String? balance = await storage.read(key: 'Cups_Balance');
    int value = int.tryParse(balance ?? '0') ?? 0;
    value++;
    await storage.write(key: 'Cups_Balance', value: '$value');
  }

  static Future<void> clearWallet() async {
    await storage.delete(key: 'Cups_Balance'); // deletes anything stored with shared_preferences.
  }
}