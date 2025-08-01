import 'package:flutter/material.dart';
import 'package:flutter_test_app/screens/store_screen.dart';
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
      routes: {
        '/send': (context) => const SendScreen(),
        '/devices': (context) => const DeviceSelectionScreen(),
        '/payment': (context) => const PaymentConfirmationScreen(),
        '/shop': (context) => const ShopScreen(),
        '/product': (context) => const ProductDetailScreen(),
        '/buy': (context) => const BuyScreen(),
        '/processing': (context) => BleChatPage(title: "Payment processing"),
      },
    );
  }
}
