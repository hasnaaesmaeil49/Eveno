// File generated manually to match new Firebase configuration.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBf4EViGTpGEU_aqCGh-YMGemJrAtR0L_w',
    appId: '1:956271417888:web:f6c74ecd5e4c9d75523a45',
    messagingSenderId: '956271417888',
    projectId: 'evently-app49',
    authDomain: 'evently-app49.firebaseapp.com',
    storageBucket: 'evently-app49.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDtIzjr02oOI4GqH8_MG5nWIuyF0v5XGsM',
    appId: '1:956271417888:android:ecc4312a7a39b9bc523a45',
    messagingSenderId: '956271417888',
    projectId: 'evently-app49',
    storageBucket: 'evently-app49.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAG6mTnj0ZGojrYHzfr0o-1sTjZcy12xnM',
    appId: '1:956271417888:ios:c203db93dd773a05523a45',
    messagingSenderId: '956271417888',
    projectId: 'evently-app49',
    storageBucket: 'evently-app49.firebasestorage.app',
    androidClientId: '956271417888-0svsb32hrchdoroe7ur7fjsmgsf0mbpe.apps.googleusercontent.com',
    iosClientId: '956271417888-jclkmekruu0lkeju31pvri9d27hh07ef.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventlyApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAG6mTnj0ZGojrYHzfr0o-1sTjZcy12xnM',
    appId: '1:956271417888:ios:c203db93dd773a05523a45',
    messagingSenderId: '956271417888',
    projectId: 'evently-app49',
    storageBucket: 'evently-app49.firebasestorage.app',
    androidClientId: '956271417888-0svsb32hrchdoroe7ur7fjsmgsf0mbpe.apps.googleusercontent.com',
    iosClientId: '956271417888-jclkmekruu0lkeju31pvri9d27hh07ef.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventlyApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBf4EViGTpGEU_aqCGh-YMGemJrAtR0L_w',
    appId: '1:956271417888:web:55a370d5ea44aa01523a45',
    messagingSenderId: '956271417888',
    projectId: 'evently-app49',
    authDomain: 'evently-app49.firebaseapp.com',
    storageBucket: 'evently-app49.firebasestorage.app',
  );

}