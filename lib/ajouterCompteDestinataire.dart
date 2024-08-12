import 'package:flutter/material.dart';
import 'dart:convert'; // Pour encoder les données en JSON
import 'package:http/http.dart' as http;
import 'package:frontend/transfererArgentMada.dart';

class ajouterCompteDestinataireMada extends StatefulWidget {
  final String userID;

  const ajouterCompteDestinataireMada({super.key, required this.userID});

  @override
  State<ajouterCompteDestinataireMada> createState() => _ajouterCompteDestinataireState();
}

class _ajouterCompteDestinataireState extends State<ajouterCompteDestinataireMada> {
  final List<String> listeTypeCompte = ['Compte bancaire','Mobile Money'];
  // Selected values for dropdowns (initialize with defaults)
  String typeCompteSelectionne = 'Compte bancaire';
  final _sommeController = TextEditingController();
  final _numeroController = TextEditingController();
  final _nomController = TextEditingController();
  final _passwordController = TextEditingController();
  final String adresse = "Mada";
  void ajouterDestinataire() async{
    // Extract data from controllers
    final String numeroCompte = _numeroController.text;
    final String nomCompte = _nomController.text;
    final String somme = _sommeController.text;
    final String motDePasseCompte = _passwordController.text;
    const String destinataire = "true";
    // Send data to backend
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/associerCompte/${widget.userID}';
    print(url);
    // Données à envoyer
    final Map<String, String> data = {
      'numeroCompte' : numeroCompte,
      'nomCompte' : nomCompte,
      'somme' : somme,
      'motDePasseCompte' : motDePasseCompte,
      'typeCompte' : typeCompteSelectionne,
      'destinataire': destinataire,
      'adresse':adresse,
    };
    print(data);
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      // Affichage d'une boîte de dialogue
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Succès',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2596BE), // Custom color for the title
              ),
            ),
            content: const Text(
              'Le compte a été ajouté avec succès.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54, // Subtle color for the content text
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // Rounded corners for the dialog
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF2596BE), // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners for the button
                  ),
                ),
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  // Navigate back to the previous page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => transfererArgentMada(userID: widget.userID),
                    ),
                  );
                },
              ),
            ],
          );

        },
      );
    }catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('i-Money'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2596BE), // Couleur de fond de l'AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children : [
              const Text(
                'Ajout d\' un compte destinataire',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: typeCompteSelectionne,
                items: listeTypeCompte.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                )).toList(),
                onChanged: (value) => setState(() => typeCompteSelectionne = value!),
                decoration: const InputDecoration(
                  labelText: 'Type du compte',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _numeroController,
                decoration: const InputDecoration(
                  labelText: 'Numero',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _sommeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Somme',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ajouterDestinataire,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    backgroundColor: const Color(0xFF2596BE),
                  ),
                  child: const Text('Ajouter'),
                ),
              ),

            ]

        ),

      ),
    );
  }
}
