import 'package:flutter/material.dart';
import 'package:flutter_test_app/services/storage_service.dart';

class DispenseScreen extends StatefulWidget{
  const DispenseScreen({super.key});
  @override
  State<DispenseScreen> createState() => _Dispence();
}

class _Dispence extends State<DispenseScreen> {
  final WalletStorage wallet = WalletStorage();
  int _balance = 0;

  @override
  void initState() {
    super.initState();
    loadBalance();
    ///
  }

  Future<void> loadBalance() async {
    int balance = await WalletStorage.getBalance();
    setState(() {
      _balance = balance;
    });
  }

  Future<void> increment() async {
    await WalletStorage.incrementBalance();
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
                            onPressed: () => Navigator.pushNamed(context, '/processing'),
                            icon: const Icon(Icons.local_drink),
                            label: const Text('Drink'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            // onPressed: () => Navigator.pushNamed(context, '/shop'),
                            onPressed: increment,
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
              'Previously Connected',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[50],
                        child: Icon(
                          Icons.device_hub,
                          color: Colors.blue[700],
                        ),
                      ),
                      title: Text('Dispenser ${index + 1}'),
                      subtitle: const Text('Last connected 2 hours ago'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}