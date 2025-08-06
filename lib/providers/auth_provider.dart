import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/foundation.dart';

class LocalAuth {

    final LocalAuthentication auth  = LocalAuthentication();
    
    Future<bool> checkCapabilities() async {
        final bool canAuthwithBiometric = await auth.canCheckBiometrics;
        final bool canAuth = canAuthwithBiometric || await auth.isDeviceSupported();
        return canAuth;
    }

    Future<String> checkEnrolledBiometrics() async {
        final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

        if(availableBiometrics.isEmpty) {
            return 'No biometrics enrolled';
        }

        if (availableBiometrics.contains(BiometricType.strong) && availableBiometrics.contains(BiometricType.face)) {
            return 'Biometric for strong and face enrolled';
        } else if(availableBiometrics.contains(BiometricType.strong)){
            return 'Biometrics type strong enrolled';
        } else if(availableBiometrics.contains(BiometricType.face)) {
            return 'Biometric for face enrolled';
        }

        return 'Could not check Biometrics enrolled';
    }

    Future<bool> authenticate() async {
        try {
            final bool didAuth = await auth.authenticate(
                localizedReason: 'Authentication needed to use app',
                options: AuthenticationOptions(biometricOnly: false,
                stickyAuth: true)
                );
            return didAuth;
        } on PlatformException catch(error) {
            debugPrint(error.code);
            return false;
        }
    }
}
