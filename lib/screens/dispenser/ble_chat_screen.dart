import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/services/ble_service.dart';

class BleChatPage extends StatefulWidget { // remember to use the device and isScanning for something
  const BleChatPage({super.key});
  @override
  State<BleChatPage> createState() => _BleChatPageState();
}

class _BleChatPageState extends State<BleChatPage> {

  final List<String> _messages = [];
  // final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final _appMessageController = StreamController<String>.broadcast();
  Stream<String> get _appMessageStream => _appMessageController.stream;

  bool _isScanning = false;
  bool _isConnected = false;

  //only adding timer for test
  Timer? _timer;

  @override // overriding inherited method so I can properly initialize Streams and controllers
  void initState() {
    super.initState();
    final bleService = BleService(appMessageStream: _appMessageStream);
    bleService.initialize();

    // listener for the bleDevice stream from the BLEservice calls
    bleService.bleDeviceMessage.listen((message) {
      setState(() {
        _messages.add(message);
        _scrollToBottom();
      });
    });

    // listener for the scanning and connection status. Scanning status is not very necesssary but could be used later
    bleService.isScanning.listen((status) {
      setState(() {
        _isScanning = status;
      });
    });
    bleService.isConnected.listen((status) {
      setState(() {
        _isConnected = status;
      });
    });

    //only adding this timer for tests
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      sendToBle("Test message");
    });
  }

  // void _sendMessage() async {
  //   final text = _textController.text.trim();
  //   if (text.isEmpty) return;
  //   try {
  //     sendToBle(text);
  //   } catch (e) {
  //     debugPrint("Send error: $e");
  //   }
  // }

  void sendToBle(message) async {
    _appMessageController.add(message);
    _messages.add(message);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Dispensing'), backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
      body: _isConnected
        ? Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (_, index) {
                  final msg = _messages[index];
                  return ListTile(
                    title: Text(
                      msg,
                      style: TextStyle(
                        color: msg.startsWith("Processing...") ? Colors.blue : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           controller: _textController,
            //           decoration: const InputDecoration(
            //             hintText: 'Enter message',
            //             border: OutlineInputBorder(),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 8),
            //       ElevatedButton(
            //         onPressed: _sendMessage,
            //         child: const Text('Send'),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        )
      : const Center(child: CircularProgressIndicator()),
      );
  }
}


