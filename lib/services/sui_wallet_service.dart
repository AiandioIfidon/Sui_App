import 'package:flutter/material.dart';
import 'package:sui/sui.dart';

import 'sui_credential_service.dart';

class SuiWalletService { // will make the address and private key the constructors later

  final SuiCredentialService suiCredentials = SuiCredentialService();

  final testnetClient = SuiClient(SuiUrls.testnet);

  final faucet = FaucetClient(SuiUrls.faucetTest);
  
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
    await Future.delayed(const Duration(seconds: 5));
  }

  Future<int> getAccountBalance() async {
    final String address = await suiCredentials.getWalletAddress();

    final PaginatedObjectsResponse response = await testnetClient.getOwnedObjects(
          address,
          options: SuiObjectDataOptions(showContent: true),
        );

    for (final objResp in response.data) {
      final fields = getObjectFields(objResp);

      if (fields is Map && fields.containsKey('balance')) {
        final dynamic balance = fields['balance'];

        // Ensure balance is an int
        if (balance is int) {
          return balance;
        } else if (balance is String) {
          return int.tryParse(balance) ?? 777;
        }
      }
    }

    // Return fallback value if no balance is found
    return 777;
  }

  // Future<int> getAccountBalance() async {
  //   final String address = await suiCredentials.getWalletAddress();
  //   final PaginatedObjectsResponse response = await devnetClient.getOwnedObjects(address,
  //   options: SuiObjectDataOptions(showContent: true));

  //   for (final objResp in response.data) {
  //     final fields = getObjectFields(objResp);
  //     final balance = fields['balance'];
  //     return balance;
  //   }
  //   return 777;// this is the value when it can't check
  // }
}