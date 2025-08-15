import 'package:flutter/material.dart';
import 'package:flutter_test_app/screens/wallet/sui_account_screen.dart';
import 'package:go_router/go_router.dart';

import 'screens/wallet/dashboard_screen.dart';
import 'screens/wallet/send_sui_screen.dart';
import 'screens/dispenser/dispense_screen.dart';
import 'screens/dispenser/ble_chat_screen.dart';
// import 'screens/send_screen.dart';
import 'screens/dispenser/device_selection_screen.dart';
import 'screens/store_and_payment/payment_confirmation_screen.dart';
import 'screens/store_and_payment/shop_screen.dart';
import 'screens/store_and_payment/product_detail_screen.dart';
import 'screens/buy_screen.dart';

void main() {
  runApp(SuiApp());
}

class SuiApp extends StatelessWidget {
  SuiApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/send/:balance',
        name: 'send',
        builder: (context, state) {
          final balance = double.tryParse(state.pathParameters['amount'] ?? '0') ?? 0;
          return SendSuiScreen(balance: balance);
        },
      ),
      GoRoute(
        path: '/devices',
        name: 'devices',
        builder: (context, state) => const DeviceSelectionScreen(),
      ),
      GoRoute(
        path: '/payment/:amount',
        name: 'payment',
        builder: (context, state) {
          final amount = int.parse(state.pathParameters['amount']!);
          return PaymentConfirmationScreen(amount: amount);
        },
      ),
      GoRoute
        path: '/shop',
        name: 'shop',
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: '/product/:amount',
        name: 'product',
        builder: (context, state) {
          final amount = int.parse(state.pathParameters['amount']!);
          return ProductDetailScreen(amount: amount);
        },
      ),
      GoRoute(
        path: '/buy',
        name: 'buy',
        builder: (context, state) => const BuyScreen(),
      ),
      GoRoute(
        path: '/processing',
        name: 'processing',
        builder: (context, state) => BleChatPage(),
      ),
      GoRoute(
        path: '/dispenser',
        name: 'dispenser',
        builder: (context, state) => DispenseScreen(),
      ),
      GoRoute(
        path: '/account/:loggedIn',
        name: 'account',
        builder: (context, state) {
          final bool loggedIn = bool.parse(state.pathParameters['loggedIn']!);
          return AccountTab(loggedIn: loggedIn);
          },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
      routerConfig: _router,
    );
  }
}