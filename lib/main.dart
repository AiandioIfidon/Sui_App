import 'package:flutter/material.dart';
import 'package:flutter_test_app/screens/dispense_screen.dart';
import 'package:flutter_test_app/screens/ble_chat_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/send_screen.dart';
import 'screens/device_selection_screen.dart';
import 'screens/payment_confirmation_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/buy_screen.dart';

void main() {
  runApp(const CryptoWaterApp());
}

class CryptoWaterApp extends StatelessWidget {
  const CryptoWaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Water Wallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const DashboardScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/send':
            return MaterialPageRoute(builder: (_) => const SendScreen());

          case '/devices':
            return MaterialPageRoute(
              builder: (_) => const DeviceSelectionScreen(),
            );

          case '/payment':
            final amount = settings.arguments as int; // gotten from the shop
            return MaterialPageRoute(
              builder: (_) => PaymentConfirmationScreen(amount: amount),
            );

          case '/shop':
            return MaterialPageRoute(builder: (_) => const ShopScreen());

          case '/product':
            final amount = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => ProductDetailScreen(amount: amount),
            );

          case '/buy':
            return MaterialPageRoute(builder: (_) => const BuyScreen());

          case '/processing':
            return MaterialPageRoute(builder: (_) => BleChatPage());

          case '/dispenser':
            return MaterialPageRoute(builder: (_) => DispenseScreen());

          default:
            return null;
        }
      },
    );
  }
}
