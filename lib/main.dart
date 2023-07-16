import 'package:flutter/material.dart';
import 'package:shoppingbusiness/MainScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ShoppingDev());
}

class ShoppingDev extends StatelessWidget {
  ShoppingDev({super.key});
  final seedColor = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 7, 107, 190),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      theme: ThemeData().copyWith(
        colorScheme: seedColor,
        useMaterial3: true,
      ),
    );
  }
}
