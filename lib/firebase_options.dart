// File generated by FlutterFire CLI.
// ignore_for_file: type=lint

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
    apiKey: 'AIzaSyA_djS1BfzxNBar80ZHIFOmtg7UL3bsRj0',
    appId: '1:593377918460:web:4f5620389d7e58a88c0679',
    messagingSenderId: '593377918460',
    projectId: 'velora-zh',
    authDomain: 'velora-zh.firebaseapp.com',
    storageBucket: 'velora-zh.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5jfuYjDc4L6JkbCRBJxB595RXEto-swQ',
    appId: '1:593377918460:android:96681f9a6874ffe38c0679',
    messagingSenderId: '593377918460',
    projectId: 'velora-zh',
    storageBucket: 'velora-zh.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPl7W2IapX9Bf8GMvHcviM2uyVezvRYkc',
    appId: '1:593377918460:ios:41ed6028f15772f68c0679',
    messagingSenderId: '593377918460',
    projectId: 'velora-zh',
    storageBucket: 'velora-zh.firebasestorage.app',
    iosBundleId: 'com.example.dvelora',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCPl7W2IapX9Bf8GMvHcviM2uyVezvRYkc',
    appId: '1:593377918460:ios:41ed6028f15772f68c0679',
    messagingSenderId: '593377918460',
    projectId: 'velora-zh',
    storageBucket: 'velora-zh.firebasestorage.app',
    iosBundleId: 'com.example.dvelora',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA_djS1BfzxNBar80ZHIFOmtg7UL3bsRj0',
    appId: '1:593377918460:web:c287aab8100f0f688c0679',
    messagingSenderId: '593377918460',
    projectId: 'velora-zh',
    authDomain: 'velora-zh.firebaseapp.com',
    storageBucket: 'velora-zh.firebasestorage.app',
  );
}
