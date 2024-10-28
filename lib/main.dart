import 'package:dictio_app_test/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  // WidgetsFlutterBinding
  //     .ensureInitialized(); // Assure l'initialisation complète du framework
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dictionary App",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomeScreen(),
    );
  }
}
