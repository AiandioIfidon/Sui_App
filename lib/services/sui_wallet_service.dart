import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sui/sui.dart';

import 'sui_credential_service.dart';

class SuiWalletService { // will make the address and private key the constructors later

  final SuiCredentialService suiCredentials = SuiCredentialService();

  final testnetClient = SuiClient(SuiUrls.testnet);
  final devnetClient = SuiClient(SuiUrls.devnet);

  final faucet = FaucetClient(SuiUrls.faucetDev);

  final transaction = Transaction();

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

  Future<void> getObjects() async {
    final String address = await suiCredentials.getWalletAddress();
    final obj = await testnetClient.getOwnedObjects(address);
    debugPrint(obj.toString());
  }

  Future<void> mergeObjects() async {
    final String address = await suiCredentials.getWalletAddress();
    final obj = await testnetClient.getOwnedObjects(address);
    final data = obj.data;

    final key = await suiCredentials.getWalletPrivateKey();
    final account = SuiAccount.fromPrivateKey(key, SignatureScheme.Ed25519);

    List <String?> objects = [];
    for (var id in data) {
      objects.add(id.data?.objectId);
    }
    List<String> validIds = objects.whereType<String>().toList();
    if (validIds.length > 1) { // if there are more than one object
      for (int i = validIds.length - 1; i > 0; i--) {
        transaction.mergeCoins(
          transaction.objectId(validIds.first), [ transaction.objectId(validIds[i]) ]
        );
      }
    }
    debugPrint(objects.toString());

  }
}