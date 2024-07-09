import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON

class seConnecter extends StatefulWidget {
  const seConnecter({super.key});

  @override
  State<seConnecter> createState() => _seConnecterState();
}

class _seConnecterState extends State<seConnecter> {
  final _formKey = GlobalKey<FormState>(); // Create a global key for the form
  final _emailController = TextEditingController(); // Controller for email input
  final _passwordController = TextEditingController(); // Controller for password input

  @override
  void dispose() {
    // Libération des ressources des contrôleurs lorsqu'ils ne sont plus nécessaires
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _login() async {
    // Utilisation des contrôleurs pour accéder aux valeurs des champs de texte
    final String email = _emailController.text;
    final String password = _passwordController.text;

    print('Email: $email');
    print('Mot de passe: $password');

    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/seConnecter';

    // Données à envoyer
    final Map<String, String> data = {
      'email': email,
      'password': password,
    };
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      print(response.body);
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
          title: const Text('Se connecter'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                TextFormField(
                  controller: _passwordController,
                  // Use the controller for password input
                  obscureText: true,
                  // Hide password input
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre mot de passe.';
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
