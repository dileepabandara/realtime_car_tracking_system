import 'package:car_tracking_dashboard/car_page.dart';
import 'package:car_tracking_dashboard/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './theme/app_theme.dart';
import '../theme/data_values.dart';
import 'home_page.dart';

Future<void> main() async {
  final FirebaseConfig firebaseConfig = FirebaseConfig();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: firebaseConfig.apiKey,
    projectId: firebaseConfig.projectId,
    messagingSenderId: firebaseConfig.messagingSenderId,
    appId: firebaseConfig.appId,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: DataValues.appName,
      theme: AppThemeData.darkTheme,
      home: const HomePage(),
    );
  }
}
