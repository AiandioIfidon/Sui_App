import 'package:flutter_test_app/screens/dashboard_screen.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget{
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateScreen();
}

class _AuthGateScreen extends State<AuthGate> {
  final LocalAuth _auth = LocalAuth();
  bool _isChecking = true;
  bool _isAuthenticated = false;
  String _failResult = 'Not even starting ';

  @override
  void initState() {
    super.initState();
    _runAuth();
  }

  Future<void> _runAuth() async {
    final canAuth = await _auth.checkCapabilities();
    if(!canAuth) { // if it can't auth (canAuth == false)
      _failResult = await _auth.checkEnrolledBiometrics();    
      setState(() {
        _isChecking = false;
      });
      return;
    }
    final result = await _auth.authenticate();
    if(result) {
      setState(() {
        _isChecking = false;
        if(result) {
          _isAuthenticated = true;
        } else {
          _failResult = "Auth failed";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_isChecking) {
      return  Scaffold(
        body: Center(child: Text(_failResult),),
      );
    }

    if(_isAuthenticated) {
      return const DashboardScreen();
    } else {
      return Scaffold(
        body: Center(
          child: Text(_failResult),
        ),
      );
    }
  }




}