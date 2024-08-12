import 'package:flutter/material.dart';
import 'package:frontend/ajoutInformation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON

class motDePasse extends StatefulWidget {
  final String email;

  const motDePasse({super.key, required this.email});

  @override
  State<motDePasse> createState() => _motDePasseState();
}

class _motDePasseState extends State<motDePasse> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmedController = TextEditingController();
  @override
  void dispose() {
    // Libération des ressources des contrôleurs lorsqu'ils ne sont plus nécessaires
    _passwordConfirmedController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void signIn() async {
    // URL de votre endpoint Laravel
    const String url = 'http://10.0.2.2:8000/api/sInscrire';

    // Données à envoyer
    final Map<String, String> data = {
      'email': widget.email,
      'password': _passwordController.text,
    };
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      //final String code = response.body;

      // Décoder la réponse JSON
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final userId = responseData['user']["id"];
      final String userIdString = userId.toString();
      print(userIdString);
      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => telephone(userID: userIdString),
        ),
      );*/
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ajoutInformation(userID: userIdString),
          )
      );
    } catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          // Re-enable the app bar if desired
          appBar: AppBar(
            title: const Text('i-Money'),
            centerTitle: true,
            backgroundColor: const Color(0xFF2596BE), // Couleur de fond de l'AppBar
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Créer un mot de passe',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Hide password characters
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
                TextFormField(
                  controller: _passwordConfirmedController,
                  obscureText: true, // Hide confirm password characters
                  decoration: const InputDecoration(
                    labelText: 'Confirmer mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre mot de passe.';
                    }else if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas.';
                    }
                    return null; // No error
                  },
                ),
                const SizedBox(height: 20.0),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('Mot de passe créé avec succès!');
                      signIn();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(500, 50), // Set button size
                    backgroundColor: const Color(0xFF2596BE),
                  ),
                  child: const Text('Confirmer'),
                ),
              ],
            ),
          ),
        )
    );
  }

}
