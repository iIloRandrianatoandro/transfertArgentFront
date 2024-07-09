import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/verifierMail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON

class sInscrire extends StatefulWidget {
  const sInscrire({super.key});

  @override
  State<sInscrire> createState() => _sInscrireState();
}

class _sInscrireState extends State<sInscrire> {
  final _formKey = GlobalKey<FormState>(); // Create a global key for the form
  final _emailController = TextEditingController(); // Controller for email input

  @override
  void dispose() {
    // Libération des ressources des contrôleurs lorsqu'ils ne sont plus nécessaires
    _emailController.dispose();
    super.dispose();
  }

  void envoiMail() async {
    // Utilisation des contrôleurs pour accéder aux valeurs des champs de texte
    final String email = _emailController.text;

    print('Email: $email');

    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/verifierMail';

    // Données à envoyer
    final Map<String, String> data = {
      'email': email,
    };
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      final String code = response.body;
      print(code);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => verifierMail(code: code, email: email),
        ),
      );
    } catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Assign the global key to the form
      child: Scaffold(
        appBar: AppBar(
          title: const Text('i-Money'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'S\'inscrire',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  controller: _emailController,
                  // Use the controller for email input
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre email.';
                    } else
                    if (!RegExp(r'^[\w-\.]+@[\w-\.]+\.[a-zA-Z]{2,}$').hasMatch(
                        value)) {
                      return 'Veuillez saisir un email valide.';
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          envoiMail();
                        }
                      },
                      child: const Text('Vérifier l\'email '),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(500, 50), // Set button size
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Se connecter avec Google',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap = () => {
                              // Add navigation logic to your sign-up page here
                              print('google'),
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
