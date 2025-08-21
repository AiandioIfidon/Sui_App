import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class BleService {
  StreamSubscription<String>? _appMessageSubscription;
  // class contructor
  BleService({Stream<String>? appMessageStream}) {
    if (appMessageStream != null) {
      _appMessageSubscription = appMessageStream.listen((message) {
        _sendMessage(message);
        }
      );
    }
  }

  final _ble = FlutterReactiveBle();

  final Uuid _serviceUuid = Uuid.parse(dotenv.env['SERVICE_UUID'] ?? '');
  final Uuid _charUuid = Uuid.parse(dotenv.env['CHARACTERISTIC_UUID'] ?? '');

  DiscoveredDevice? _device;
  QualifiedCharacteristic? _chatChar;

  final _scanController = StreamController<bool>.broadcast();
  Stream<bool> get isScanning => _scanController.stream; // to be used to check whether the app is scanning
  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get isConnected => _connectionController.stream; // to be used to check connection status
  final _bleDeviceController = StreamController<String>.broadcast();
  Stream<String> get bleDeviceMessage => _bleDeviceController.stream; // used to check was the reply from the bleDevice is


  Future<void> initialize() async {
    await Permission.bluetooth.request();
    await Permission.location.request();
    setInitialConnectionState();
    _startBle();
  }

  void setInitialConnectionState() {
    _scanController.add(false);
    _connectionController.add(false);
  }

  void _startBle() {
    _ble.scanForDevices(withServices: [_serviceUuid]).listen((device) {
      _scanController.add(true);
      if (device.name == "Transceiver") {
        _scanController.add(false);
        _connectToDevice(device);
      }
    });
  }

  void _connectToDevice(DiscoveredDevice device) {
    _ble
        .connectToDevice(id: device.id)
        .listen(
          (state) {
            if (state.connectionState == DeviceConnectionState.connected) {
              _connectionController.add(true); // updating stream value so the rest of the app knows its connected

              _chatChar = QualifiedCharacteristic(
                serviceId: _serviceUuid,
                characteristicId: _charUuid,
                deviceId: device.id,
              );

              _ble.subscribeToCharacteristic(_chatChar!).listen((data) {
                _bleDeviceController.add( String.fromCharCodes(data) ); // sending the reply to the bleDeviceMessage stream for whichever screen needs it

              });
            } else if (state.connectionState ==
              DeviceConnectionState.disconnected) {
              _connectionController.add(false); // updating stream value so the rest of the app know its disconnected
            }
          },
          onError: (e) {
            debugPrint("Connection error: $e");
          },
        );
  }

  void _sendMessage(String message) async {
    if (message.isEmpty || _chatChar == null) return;
    try {
      await _ble.writeCharacteristicWithoutResponse(
        _chatChar!,
        value: message.codeUnits,
      );
    } catch (e) {
      debugPrint("Send error: $e");
    }
  }

  void dispose() {
    _appMessageSubscription?.cancel();
    _scanController.close();
    _connectionController.close();
    _bleDeviceController.close();
  }
}
