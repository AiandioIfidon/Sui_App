import '../providers/secure_storage_provider.dart';

class SuiCredentialService {

  static Future<String> getWalletAddress() async {
    final String address = await storage.read(key: 'sui_address') ?? '';
    return address;
  }

  static Future<String> getWalletPrivateKey() async {
    final String key = await storage.read(key: 'sui_private_key') ?? '';
    return key;
  }

  static Future<void> saveWallet(String address, String privateKey) async {
    await storage.write(key: 'sui_address', value: address);
    await storage.write(key: 'sui_private_key', value: privateKey);
    Future.delayed(Duration(seconds: 3));
  }

  static Future<void> deleteAccount() async {
    await storage.deleteAll();
  }
}