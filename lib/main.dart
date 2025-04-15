import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:taurusai/models/user.dart';
// import 'package:taurusai/screens/splash_screen.dart';
// import 'package:taurusai/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCpiUcU9I5z6_IzzLMp67H1M28_rUpe_mc",
          authDomain: "nestern-1be70.firebaseapp.com",
          projectId: "nestern-1be70",
          storageBucket: "nestern-1be70.firebasestorage.app",
          messagingSenderId: "800461785370",
          appId: "1:800461785370:web:2eb180535a892341e8c4a3",
          measurementId: "G-4MF50PB9WK",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  // User? currentUser = await AuthService().getCurrentUser();
  // runApp(MyApp(initialUser: currentUser));
}

class MyApp extends StatelessWidget {
  // final User? initialUser;

  // const MyApp({Key? key, this.initialUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NESTERN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: SplashScreen(initialUser: initialUser),
    );
  }
}
