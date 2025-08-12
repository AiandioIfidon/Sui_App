import 'package:flutter/material.dart';
import '/services/sui_wallet_service.dart';

import 'send_sui_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _Dashboard();
}

class _Dashboard extends State<DashboardScreen> {

  final SuiWalletService suiWallet = SuiWalletService();

  double _suiBalance = 0; 
  String _address = 'loading';
  @override
  void initState() {
    super.initState();
    loadWallet();
  }

  Future<void> loadWallet() async {
    final int balance = await suiWallet.getAccountBalance();
    final address = await suiWallet.getAddress();
    setState(() {
      _suiBalance = balance/1000000000;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.pushNamed(context, '/shop'),
          ),
        ],
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
                      'Balance',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_suiBalance Sui',
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
                            onPressed: () async { 
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SendSuiScreen(balance: _suiBalance,)),
                              );
                              if(result) {
                                loadWallet();
                              }},
                            icon: const Icon(Icons.send),
                            label: const Text('Send'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download),
                            label: const Text('Receive'),
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
            const SizedBox(height: 20),
            
            // Connect Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.link),
                label: const Text('Convert to naira'),
              ),
            ),
            
            const SizedBox(height: 24),

            Text('Address:', style: TextStyle(color: Colors.blue[400])),
                SelectableText(_address!),
                const SizedBox(height: 16),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/dispenser'),
        tooltip: 'Delete Wallet Balance',
        backgroundColor: Colors.blue[700], // Set background color
        foregroundColor: Colors.white, // Icon/text color
        elevation: 8.0, // Shadow depth
        shape: RoundedRectangleBorder(
          // Custom shape (e.g., rounded rectangle)
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.local_drink_outlined),
      ),
    );
  }
}
