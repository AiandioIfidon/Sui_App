import 'package:flutter/material.dart';
import 'package:sui/sui.dart';

import 'sui_credential_service.dart';

class SuiWalletService { // will make the address and private key the constructors later

  final SuiCredentialService suiCredentials = SuiCredentialService();

  final testnetClient = SuiClient(SuiUrls.testnet);
  final devnetClient = SuiClient(SuiUrls.devnet);

  final faucet = FaucetClient(SuiUrls.faucetDev);

  Future<String> getAddress() async {
    return await suiCredentials.getWalletAddress();
  }
  
  Future<void> requestFaucetDev() async {
    final String address = await suiCredentials.getWalletAddress();
    if(address.isEmpty) {
      debugPrint('Address is null');
      return;
    }
    try {
      await faucet.requestSuiFromFaucetV1(address);
    } catch(e) {
      debugPrint('$e');
    }
    await Future.delayed(const Duration(seconds: 3));
  }

  Future<int> getAccountBalance() async {
    final String address = await suiCredentials.getWalletAddress();
    final balance = await testnetClient.getBalance(address);
    await Future.delayed(const Duration(seconds: 2));
    return balance.totalBalance.toInt();
  }
}