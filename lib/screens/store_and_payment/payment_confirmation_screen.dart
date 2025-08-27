  import 'package:flutter/material.dart';

  import '/services/sui_wallet_service.dart';

  class PaymentConfirmationScreen extends StatefulWidget {
    const PaymentConfirmationScreen({super.key, required this.amount, required this.address});
    final double amount;
    final String address;

    @override
    State<PaymentConfirmationScreen> createState() => _PaymentConfirmPage();
  }

  class _PaymentConfirmPage extends State<PaymentConfirmationScreen> {

    bool _sending = false;
    double _balance = 0;

    final SuiWalletService suiWallet = SuiWalletService();

    final vendorAddress = "0x192e2910724dfbe63579eaa3a0f2276af0047641270153c881f7976d7d4fb3c7";

    @override
    void initState() {
      initAccount();
      super.initState();
    }

    Future<void> initAccount() async {
      final balance = await suiWallet.getAccountBalance();
      setState(() {
        _balance = balance/1000000000;
      });
    }

    Future<bool> sendCoins(double balance, double amount, String address) async {
      if (amount == 0) {
        debugPrint("Fill in amount greater than zero");
        return false;
      }
      if (address.isEmpty) {
        debugPrint("Please fill in the recipient address");
        return false;
      }
      if (amount > balance) {
        debugPrint("Amount to send greater than balance");
        return false;
      }
      return await suiWallet.sendCoins(
        balance,
        amount,
        address,
      ); // hardcoded to mine sui cli address
    }

    void _showPopup({required bool success}) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red,
                size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  (success ? "Transaction Successful!" : "Transaction Failed!"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  (success ? "Your tranaction has been completed" : "Try again later"),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Return'),
              ),
            ],
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pay'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Amount Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.amount}',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Breakdown
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Outflow'),
                                Text(
                                  '-${widget.amount} Sui',
                                  style: TextStyle(
                                    color: Colors.red[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'To Address:  ${widget.address}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Remaining Balance',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${_balance-widget.amount} Sui',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Warning
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange[700],
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Crypto transfers are irreversible. Please double-check the details before proceeding.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                        minimumSize: const Size(0, 50),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _sending
                          ? null
                          : () async {
                              if (!mounted) return;
                              setState(() {
                                _sending = true;
                              });
                              // Remember to invalid decimal values less the billionth value
                              final result = await sendCoins(
                                _balance,
                                widget.amount,
                                widget.address,
                              );
                              if (result) {
                                _showPopup(success: true);
                              } else {
                                _showPopup(success: false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(0, 50),
                      ),
                      child: const Text('Pay'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

