// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
///import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
///

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
    apiKey: 'AIzaSyBSpWkkXcHJkrLJ_vR7xL2ayigYyhCp0JM',
    appId: '1:892264871371:web:37edc6da81ae2968f6324e',
    messagingSenderId: '892264871371',
    projectId: 'hometasky-f6669',
    authDomain: 'hometasky-f6669.firebaseapp.com',
    storageBucket: 'hometasky-f6669.appspot.com',
    measurementId: 'G-9W7G9S48RG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5EINnAefY8ivdPyVlzCEFJCUuJX_dHcc',
    appId: '1:892264871371:android:f3998ce30a42c7eff6324e',
    messagingSenderId: '892264871371',
    projectId: 'hometasky-f6669',
    storageBucket: 'hometasky-f6669.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1U5ZeUzidSVNGugO0SlO3M-HRyd9V5zc',
    appId: '1:892264871371:ios:219caf73af8f5f8af6324e',
    messagingSenderId: '892264871371',
    projectId: 'hometasky-f6669',
    storageBucket: 'hometasky-f6669.appspot.com',
    iosBundleId: 'com.example.hometasky',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA1U5ZeUzidSVNGugO0SlO3M-HRyd9V5zc',
    appId: '1:892264871371:ios:219caf73af8f5f8af6324e',
    messagingSenderId: '892264871371',
    projectId: 'hometasky-f6669',
    storageBucket: 'hometasky-f6669.appspot.com',
    iosBundleId: 'com.example.hometasky',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBSpWkkXcHJkrLJ_vR7xL2ayigYyhCp0JM',
    appId: '1:892264871371:web:23798cb93b738af3f6324e',
    messagingSenderId: '892264871371',
    projectId: 'hometasky-f6669',
    authDomain: 'hometasky-f6669.firebaseapp.com',
    storageBucket: 'hometasky-f6669.appspot.com',
    measurementId: 'G-4T51M05EKR',
  );
}
