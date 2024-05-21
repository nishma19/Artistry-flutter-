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
    apiKey: 'AIzaSyB0nrlsgnI6s3Bn-54Qd305ApaAPBXJAHY',
    appId: '1:1051929817913:web:238da5400bef17eb6beee8',
    messagingSenderId: '1051929817913',
    projectId: 'artistryapp-bc63c',
    authDomain: 'artistryapp-bc63c.firebaseapp.com',
    storageBucket: 'artistryapp-bc63c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdZZ0Bld4AzNKqLFaKshDr4Gn6Wjsvf78',
    appId: '1:1051929817913:android:5428d14c9394de366beee8',
    messagingSenderId: '1051929817913',
    projectId: 'artistryapp-bc63c',
    storageBucket: 'artistryapp-bc63c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeaX98G9KjgRRQWOY_Q_EcdMaa1hf94tg',
    appId: '1:1051929817913:ios:97d0a85047ffa30f6beee8',
    messagingSenderId: '1051929817913',
    projectId: 'artistryapp-bc63c',
    storageBucket: 'artistryapp-bc63c.appspot.com',
    iosBundleId: 'com.ralfiz.artistry',
  );
}
