import '../providers/secure_storage_provider.dart';

class SuiCredentialService {

  Future<String> getWalletAddress() async {
    final String address = await storage.read(key: 'sui_address') ?? '';
    return address;
  }

  Future<String> getWalletPrivateKey() async {
    final String key = await storage.read(key: 'sui_private_key') ?? '';
    return key;
  }
}