import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/services/sui_wallet_service.dart';

class SendSuiScreen extends StatefulWidget{
  const SendSuiScreen({super.key, required this.balance, this.fixed=false, this.amount=0, this.address=''});
  final double balance;

  final bool fixed;
  final double amount;
  final String address;
  @override
  State<SendSuiScreen> createState() => _SendSuiPage();
}

class _SendSuiPage extends State<SendSuiScreen> {
  bool _sending = false;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final SuiWalletService suiWallet = SuiWalletService();

  @override
  void dispose() {
    _amountController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<bool> sendCoins( double balance, double amount, String address) async {
    if(amount == 0) {
      debugPrint("Fill in amount greater than zero");
      return false;
    }
    if(address.isEmpty) {
      debugPrint("Please fill in the recipient address");
      return false;
    }
    if(amount > widget.balance) {
      debugPrint("Amount to send greater than balance");
      return false;
    }
    return await suiWallet.sendCoins(balance, amount, address); // hardcoded to mine sui cli address
  }

  void _showPopup({required bool success}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
              size: 60,
            ),
            const SizedBox(height: 10),
            Text(
              (success ? "Transaction Successful!" : "Transaction Failed!"),
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close popup
      if (success) {
        Navigator.of(context).pop(true); 
      } else {
        Navigator.of(context).pop(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title:  const Text('Send Sui'),),

      body: widget.fixed?

      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Fixed transaction',
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Sending:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            Text(
              '-${widget.amount} Sui',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'To address: ${widget.address}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sending?
                () {} : () async {
                  if(!mounted) return;
                  setState(() {
                    _sending = true;
                  });
                  // Remember to invalid decimal values less the billionth value
                  final result = await sendCoins(widget.balance, widget.amount, widget.address);
                  if(result){
                    _showPopup(success: true);
                  } else {
                    _showPopup(success: false);
                  }
                },
                icon: _sending? Icon(Icons.lock_clock_rounded) : Icon(Icons.send),
                label: _sending? Text('Processing') : Text('Send'),
              ),
            ),
          ],
        )
      )


      :


      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Fill in transaction details',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 15),
            
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Recipient Address',
              ),
            ),
             const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.pushNamed(
                    'payment',
                    pathParameters: {'amount': _amountController.text, 'address': _addressController.text},
                  ),
                icon: _sending? Icon(Icons.lock_clock_rounded) : Icon(Icons.send),
                label: _sending? Text('Processing') : Text('Send'),
              ),
            ),
          ],
        )
      ),
    );
  }
}