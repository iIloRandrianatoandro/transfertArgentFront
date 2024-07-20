import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/sInscrire.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON
import 'package:frontend/transfererArgentMada.dart';
import 'package:frontend/transfererArgentUS.dart';

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

    /*print('Email: $email');
    print('Mot de passe: $password');*/

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

      //print(response.body);
      // Décoder la réponse JSON
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final userId = responseData['userID'];
      final String userIdString = userId.toString();
      final adresse = responseData['adresse'];
      final String adresseString = adresse.toString();
      print(adresseString);
      if (response.body == 'erreur authentification') {
        _showErrorDialog('Erreur d\'authentification ');
      }
      else {
        if (adresseString=='Mada'){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => transfererArgentMada(userID: userIdString),
            ),
          );
        }
        if (adresseString=='US'){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => transfererArgentUS(userID: userIdString),
            ),
          );
        }
      }
    } catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }
    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        ),
      );
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
                  'Se connecter',
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: const Text('Se connecter'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(500, 50), // Set button size
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Pas encore inscrit ? ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'S\'inscrire',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap = () => {
                              // Add navigation logic to your sign-up page here
                              print('Navigate to sign-up page'),
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const sInscrire()),
                              )
                            },
                          ),
                        ],
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
