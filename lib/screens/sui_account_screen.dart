import 'package:flutter/material.dart';
import 'package:sui/sui.dart'; 

import '../providers/secure_storage_provider.dart';

class CreateAccountTab extends StatefulWidget {
  const CreateAccountTab({super.key});

  @override
  State<CreateAccountTab> createState() => _CreateAccountTabState();
}

class _CreateAccountTabState extends State<CreateAccountTab> {
  bool _isCreating = false;
  String? _mnemonic;
  String? _address;
  String? _privateKey;


  Future<void> _createAccount() async {
    setState(() {
      _isCreating = true;
    });

    final mnemonic = SuiAccount.generateMnemonic();
    final account = SuiAccount.fromMnemonics(mnemonic, SignatureScheme.Ed25519);

    final privKey = account.privateKey;
    final addr = account.getAddress(); 

    await storage.write(key: 'sui_private_key', value: '$privKey');
    await storage.write(key: 'sui_address', value: addr);

    setState(() {
      _mnemonic = mnemonic;
      _privateKey = '$privKey';
      _address = addr;
      _isCreating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _isCreating ? null : _createAccount,
              icon: const Icon(Icons.add_circle_outline),
              label: Text(_isCreating ? 'Creating...' : 'Create Sui Account'),
            ),
            const SizedBox(height: 24),
            if (_mnemonic != null) ...[
              Text(
                'Recovery Mnemonic (write this down and keep it safe):',
                style: TextStyle(color: Colors.blue[400]),
              ),
              SelectableText(
                _mnemonic!,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              const SizedBox(height: 24),
            ],
            if (_address != null) ...[
              Text('Address:', style: TextStyle(color: Colors.blue[400]),),
              SelectableText(_address!),
              const SizedBox(height: 16),
            ],
            if (_privateKey != null) ...[
              Text('Private Key:', style: TextStyle(color: Colors.blue[400]),),
              SelectableText(_privateKey!),
            ],
          ],
        ),
      ),
    );
  }
}
