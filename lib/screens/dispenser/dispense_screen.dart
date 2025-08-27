import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/cups_wallet_service.dart';

class DispenseScreen extends StatefulWidget{
  const DispenseScreen({super.key});
  @override
  State<DispenseScreen> createState() => _Dispence();
}

class _Dispence extends State<DispenseScreen> {
  int _balance = 0;

  List<String> _cups = [];

  @override
  void initState() {
    super.initState();
    loadBalance();
    loadDigests();
  }

  Future<void> loadBalance() async {
    int balance = await WalletStorage.getBalance();
    setState(() {
      _balance = balance;
    });
  }

  Future<void> loadDigests() async {
    final cups = await WalletStorage.loadCups();
    setState(() {
      _cups = cups;
    });
  }

  Future<void> deleteAll() async {
    await WalletStorage.clearWallet();
    int balance = await WalletStorage.getBalance();
    setState(() {
      _balance = balance;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dispenser Tab"),
      ),
        body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cups Balance',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                     Text(
                      '$_balance Cups',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/processing'),
                            icon: const Icon(Icons.local_drink),
                            label: const Text('Drink'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('Buy more'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Connected Devices
            const Text(
              'Bought cups',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: ListView.builder(
                itemCount: _cups.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[50],
                        child: Icon(
                          Icons.local_drink,
                          color: Colors.blue[700],
                        ),
                      ),
                      title: Text('Cup ${index + 1}'),
                      subtitle: Text('Digest: ${_cups[index].substring(0, 7)}...'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => deleteAll(),
        backgroundColor: Colors.blue[700], // Set background color
        foregroundColor: Colors.white, // Icon/text color
        elevation: 8.0, // Shadow depth
        shape: RoundedRectangleBorder(
          // Custom shape (e.g., rounded rectangle)
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_forever),
      ),
    );
  }
}