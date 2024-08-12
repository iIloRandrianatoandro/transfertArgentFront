import 'package:flutter/material.dart';
import 'package:frontend/seConnecter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application de transfert d\'argent',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        children: [
          // Add your logo image here
          Image.asset('assets/Images/logo1.png'), // Replace 'path/to/your/logo.png' with the actual path to your logo image
          const SizedBox(height: 20), // Add some space between logo and text
          Text(
            'Transférer votre argent en toute sécurité',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20), // Add some space between text and button
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const seConnecter()),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(350, 50), // Set button size
              backgroundColor: const Color(0xFF2596BE),
            ),
            child: const Text('Se connecter'),
          ),
        ],
      ),
    ),
    );
  }
}

