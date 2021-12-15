// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8l9cPNXRY86jI1MyqXSD9kw9mGgrlBJw',
    appId: '1:818794097105:android:ca53e0fb1908c5546bd8f0',
    messagingSenderId: '818794097105',
    projectId: 'galleryapp-60bbb',
    storageBucket: 'galleryapp-60bbb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmWIo2wekw5qFQ3hyYAJ48er8OVXiOYX0',
    appId: '1:818794097105:ios:4c271f64080264d46bd8f0',
    messagingSenderId: '818794097105',
    projectId: 'galleryapp-60bbb',
    storageBucket: 'galleryapp-60bbb.appspot.com',
    iosClientId: '818794097105-dqaug6b323spf49vq3mtvdjjq4dari7j.apps.googleusercontent.com',
    iosBundleId: 'com.galleryApp.app',
  );
}
