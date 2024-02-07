// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAD5w2fbDZyWB4U1prkdeZa2zGZ81fxG5I',
    appId: '1:956316131173:web:9def51ad15cb1cb2c38b8c',
    messagingSenderId: '956316131173',
    projectId: 'youchat-5af87',
    authDomain: 'youchat-5af87.firebaseapp.com',
    storageBucket: 'youchat-5af87.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoxVp3IdJAkWuqzjSsN0rMSgL1z1atb88',
    appId: '1:956316131173:android:ad33f3107181b9ffc38b8c',
    messagingSenderId: '956316131173',
    projectId: 'youchat-5af87',
    storageBucket: 'youchat-5af87.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBv8Oh0s1ciO3lszomC_-7b6X6eipbef5w',
    appId: '1:956316131173:ios:19164a343b8ee80fc38b8c',
    messagingSenderId: '956316131173',
    projectId: 'youchat-5af87',
    storageBucket: 'youchat-5af87.appspot.com',
    iosBundleId: 'com.whatsapp.youchat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBv8Oh0s1ciO3lszomC_-7b6X6eipbef5w',
    appId: '1:956316131173:ios:9c14e896ebd800a1c38b8c',
    messagingSenderId: '956316131173',
    projectId: 'youchat-5af87',
    storageBucket: 'youchat-5af87.appspot.com',
    iosBundleId: 'com.whatsapp.youchat.RunnerTests',
  );
}