import 'package:flutter/material.dart';
import 'package:sui/sui.dart'; 

import '../../services/sui_credential_service.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key, required this.loggedIn});
  final bool loggedIn;
  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  bool _isCreating = false;
  String? _mnemonic;
  String? _address;

  final TextEditingController _mnemonicController = TextEditingController();

  @override
  void dispose() {
    _mnemonicController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    setState(() {
      _isCreating = true;
    });

    final mnemonic = SuiAccount.generateMnemonic();
    final account = SuiAccount.fromMnemonics(mnemonic, SignatureScheme.Ed25519);

    final privKey = account.privateKey();
    final addr = account.getAddress(); 
    await SuiCredentialService.saveWallet(addr, privKey);

    setState(() {
      _mnemonic = mnemonic;
      _address = addr;
    });
  }

  Future<void> _importAccount(String mnemonic) async {
    setState(() {
      _isCreating = true;
    });
    if(mnemonic.isEmpty){
      debugPrint('Mnemonic empty');
      return;
    }
    final account = SuiAccount.fromMnemonics(mnemonic, SignatureScheme.Ed25519);
    final privKey = account.privateKey();
    final addr = account.getAddress();
    await SuiCredentialService.saveWallet(addr, privKey);

    setState(() {
      _address = addr;
    });
  }

  Future<void> _deleteAccount() async {
    await SuiCredentialService.deleteAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Sui Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if(!_isCreating) // only show when account is not being created
              ElevatedButton.icon(
                onPressed: _isCreating ? null : _createAccount,
                icon: const Icon(Icons.add_circle_outline),
                label: Text(_isCreating ? 'Creating...' : 'Create Sui Account'),
              ),
              if(!_isCreating) // only show when account is not being created
              ElevatedButton.icon(
                onPressed: _isCreating ? null : () => _importAccount(_mnemonicController.text),
                icon: const Icon(Icons.add_circle_outline),
                label: Text(_isCreating ? 'Importing Account' : 'Import Account' ),
              ),


              const SizedBox(height: 35),
              if(!_isCreating)
              const Text(
                'Fill in your ed25519 testnet mnemonics \n or use the "Create Sui Account button" to create a new Ed25519 account',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              if(!_isCreating)
              TextField(
                controller: _mnemonicController,
                decoration: InputDecoration(
                  labelText: 'eg. bag shoe sky ...',
                ),
              ),


              
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
                Text('Address:', style: TextStyle(color: Colors.blue[400])),
                SelectableText(_address!),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () => _deleteAccount(),
      tooltip: 'Delete Account from device',
      backgroundColor: Colors.blue[700], // Set background color
      foregroundColor: Colors.white, // Icon/text color
      elevation: 8.0, // Shadow depth
      shape: RoundedRectangleBorder(
        // Custom shape (e.g., rounded rectangle)
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.delete),
      ),
    );
  }
}
