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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB0cN6o4biFmVKYUHpMOYLABj0XTWMZVRE',
    appId: '1:364873093278:web:8aeb049ab24cb4234cab8f',
    messagingSenderId: '364873093278',
    projectId: 'kateringku-fe3c4',
    authDomain: 'kateringku-fe3c4.firebaseapp.com',
    storageBucket: 'kateringku-fe3c4.appspot.com',
    measurementId: 'G-23GP25QZ28',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlayIrEYBUc4WU01XkolPzX0bKdPr3FfA',
    appId: '1:364873093278:android:7ed9663bd21a88c04cab8f',
    messagingSenderId: '364873093278',
    projectId: 'kateringku-fe3c4',
    storageBucket: 'kateringku-fe3c4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_l1QIM-p_NRkWLB4HXOKVfq2hhSYEXt8',
    appId: '1:364873093278:ios:179aba0b538584864cab8f',
    messagingSenderId: '364873093278',
    projectId: 'kateringku-fe3c4',
    storageBucket: 'kateringku-fe3c4.appspot.com',
    iosClientId: '364873093278-lshfk980bpusik27e72jfab2cv862vq5.apps.googleusercontent.com',
    iosBundleId: 'com.example.kateringkuMobile',
  );
}
