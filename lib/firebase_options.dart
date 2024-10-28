// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCPhSKlQO99TcMU5x3A2y0mIu0cPRNgNa0',
    appId: '1:195282944857:web:89c88392652909e0dc8248',
    messagingSenderId: '195282944857',
    projectId: 'employess-app-co',
    authDomain: 'employess-app-co.firebaseapp.com',
    storageBucket: 'employess-app-co.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7SjFPHsKe0wpcQVvWv98KB6mq2_IAgKU',
    appId: '1:195282944857:android:7cf9118de5cdfb28dc8248',
    messagingSenderId: '195282944857',
    projectId: 'employess-app-co',
    storageBucket: 'employess-app-co.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqnVns-EmGaHkT_M_mZ6XZx8F0OtNsJ3I',
    appId: '1:195282944857:ios:6ba5940266e22866dc8248',
    messagingSenderId: '195282944857',
    projectId: 'employess-app-co',
    storageBucket: 'employess-app-co.appspot.com',
    iosBundleId: 'com.cjamcu.employess',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAqnVns-EmGaHkT_M_mZ6XZx8F0OtNsJ3I',
    appId: '1:195282944857:ios:6ba5940266e22866dc8248',
    messagingSenderId: '195282944857',
    projectId: 'employess-app-co',
    storageBucket: 'employess-app-co.appspot.com',
    iosBundleId: 'com.cjamcu.employess',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCPhSKlQO99TcMU5x3A2y0mIu0cPRNgNa0',
    appId: '1:195282944857:web:6a1d6a3ab8467acddc8248',
    messagingSenderId: '195282944857',
    projectId: 'employess-app-co',
    authDomain: 'employess-app-co.firebaseapp.com',
    storageBucket: 'employess-app-co.appspot.com',
  );
}
