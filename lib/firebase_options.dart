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
    apiKey: 'AIzaSyCmMKIPv2XufU67Wp8c_NQpJASWOTIx26Y',
    appId: '1:983511242166:web:8c2a0b7cfe383a7cd6dd17',
    messagingSenderId: '983511242166',
    projectId: 'wish-laundry-1b532',
    authDomain: 'wish-laundry-1b532.firebaseapp.com',
    storageBucket: 'wish-laundry-1b532.appspot.com',
    measurementId: 'G-B3V1SPZXX7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbglQsmmuHkqfZesR1Mdfe6RTay0XjldU',
    appId: '1:983511242166:android:752610e006a375d6d6dd17',
    messagingSenderId: '983511242166',
    projectId: 'wish-laundry-1b532',
    storageBucket: 'wish-laundry-1b532.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZcnUV6G3oUVCJEfJvOZW4k_cZRWi9BLE',
    appId: '1:983511242166:ios:1136f523359d763dd6dd17',
    messagingSenderId: '983511242166',
    projectId: 'wish-laundry-1b532',
    storageBucket: 'wish-laundry-1b532.appspot.com',
    iosBundleId: 'com.example.wishlaundry',
  );
}
