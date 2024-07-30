import 'package:flutter/material.dart';
import 'dart:convert'; // Pour encoder les données en JSON
import 'package:http/http.dart' as http;
import 'package:frontend/transfererArgentMada.dart';

class ajouterCompteExpediteurMada extends StatefulWidget {
  final String userID;

  const ajouterCompteExpediteurMada({Key? key, required this.userID}) : super(key: key);

  @override
  State<ajouterCompteExpediteurMada> createState() => _ajouterCompteExpediteurState();
}

class _ajouterCompteExpediteurState extends State<ajouterCompteExpediteurMada> {
  final List<String> listeTypeCompte = ['Compte bancaire','Mobile Money'];
  // Selected values for dropdowns (initialize with defaults)
  String typeCompteSelectionne = 'Compte bancaire';

  final _sommeController = TextEditingController();
  final _numeroController = TextEditingController();
  final _nomController = TextEditingController();
  final _passwordController = TextEditingController();

  void ajouterExpediteur() async{
    // Extract data from controllers
    final String numeroCompte = _numeroController.text;
    final String nomCompte = _nomController.text;
    final String somme = _sommeController.text;
    final String motDePasseCompte = _passwordController.text;
    final String destinataire = "false";
    final String adresse = "Mada";
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
      'adresse': adresse,
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
          title: Text('Succès'),
          content: Text('Le compte a été ajouté avec succès.'),
          actions: [
            TextButton(
              child: Text('OK'),
                onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue
        // Retourner à la page précédente
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
        title: const Text('Transfert d\'argent'),
      ),
      body: SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children : [
          const Text(
            'Ajout d\' un compte expediteur',
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
              onPressed: ajouterExpediteur,
              child: const Text('Ajouter'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),

        ]

      ),

      ),
    );
  }
}
