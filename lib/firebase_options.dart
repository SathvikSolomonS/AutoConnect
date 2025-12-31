import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get android => const FirebaseOptions(
    apiKey: "YOUR_API_KEY",
    appId: "YOUR_APP_ID",
    messagingSenderId: "YOUR_SENDER_ID",
    projectId: "seecar-ca375",
    storageBucket: "seecar-ca375.appspot.com",
  );
}
