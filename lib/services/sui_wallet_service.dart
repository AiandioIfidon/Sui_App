import 'dart:convert';

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

  Future<void> getCoins() async {
    final String address = await suiCredentials.getWalletAddress();
    final obj = await testnetClient.getCoins(address, coinType: '0x2::sui::SUI');
    for(var object in obj.data) {
      debugPrint('Object Id: ${object.objectId.toString()}');
    }
  }

  Future<bool> sendCoins(int amount, String destination) async {
    final String address = await suiCredentials.getWalletAddress();
    final balance = await getAccountBalance();

    if(amount > balance) {
      debugPrint("Amount to send greater than balance");
      return false; 
    }
    final privateKey = await suiCredentials.getWalletPrivateKey();
    final account = SuiAccount.fromPrivateKey(privateKey, SignatureScheme.Ed25519);

    final transaction = Transaction();
    final coins = await testnetClient.getCoins(address, coinType: '0x2::sui::SUI');
    List<dynamic> amounts = [];
    for(var coin in coins.data) {
      amounts.add(BigInt.from(int.tryParse(coin.balance.toString()) ?? 0));
    }
    debugPrint(amounts.toString());

    final coin = transaction.splitCoins(transaction.gas, amounts);
    transaction.transferObjects([coin], destination);
    final result = await testnetClient.signAndExecuteTransactionBlock(account, transaction);
    debugPrint(result.digest);
    return true;
  }

  Future<void> mergeObjects() async {
    final String address = await suiCredentials.getWalletAddress();
    final obj = await testnetClient.getCoins(address, coinType: '0x2::sui::SUI');
    final data = obj.data;

    final key = await suiCredentials.getWalletPrivateKey();
    final account = SuiAccount.fromPrivateKey(key, SignatureScheme.Ed25519);

    List<String> validIds = [];
    for (var coin in data) {
      if (coin.coinObjectId.isNotEmpty) {
        validIds.add(coin.coinObjectId);
      }
    }

    debugPrint("Found ${validIds.length} valid SUI coins");
    debugPrint("Valid coin IDs: $validIds");

    if(validIds.length <= 1) {
      debugPrint("Not more than 2 coins so can't merge");
      return;
    }
    if (validIds.length > 1) {

      final transaction = Transaction();
      final address = await suiCredentials.getWalletAddress();
      transaction.setSender(address);

      List<Map<String, dynamic>> coinsToMerge = [];
      for(int i = 1; i < validIds.length - 1; i++) { // creating the sources starting with the second coin object
        coinsToMerge.add(transaction.objectId(validIds[i]));
      }
      transaction.mergeCoins( transaction.objectId(validIds[0]), coinsToMerge );
      final result = await testnetClient.signAndExecuteTransactionBlock(
        account,
        transaction,
      );
      debugPrint(result.digest.toString());
    }
  }
}
