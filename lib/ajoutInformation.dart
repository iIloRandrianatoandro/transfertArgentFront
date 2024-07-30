import 'package:flutter/material.dart';
import 'package:frontend/transfererArgentMada.dart';
import 'package:frontend/transfererArgentUS.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON

class ajoutInformation extends StatefulWidget {
  final String userID;

  const ajoutInformation({Key? key, required this.userID}) : super(key: key);

  @override
  State<ajoutInformation> createState() => _ajoutInformationState();
}

class _ajoutInformationState extends State<ajoutInformation> {
  final List<String> listeAdresse = ['Mada','US'];
  // Selected values for dropdowns (initialize with defaults)
  String adresseSelectionnee = 'Mada';
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _adresseController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _dateNaisController = TextEditingController();

  void ajouterInformation() async{
    // Extract data from controllers
    final String nom = _nomController.text;
    final String prenom = _prenomController.text;
    final String adresse = adresseSelectionnee;
    final String telephone = _telephoneController.text;
    final String dateNais = _dateNaisController.text;
    // Send data to backend
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/ajouterInformation/${widget.userID}';
    //print(url);
    // Données à envoyer
    final Map<String, String> data = {
      'nom' : nom,
      'prenom' : prenom,
      'adresse' : adresse,
      'telephone' : telephone,
      'dateNais' : dateNais,
    };
    print(data);
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print(response.body);
      if (adresse=='Mada'){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => transfererArgentMada(userID: widget.userID),
          ),
        );
      }
      else if (adresse=='US'){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => transfererArgentUS(userID: widget.userID),
          ),
        );
      }
    } catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('i-Money'),
      ),
      body: SingleChildScrollView( // Allow content to scroll if needed
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align content left
          children: [
            const Text(
              'Ajout d\'information',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: adresseSelectionnee,
              items: listeAdresse.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) => setState(() => adresseSelectionnee = value!),
              decoration: const InputDecoration(
                labelText: 'Adresse',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10.0),
            TextField(
              controller: _telephoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _dateNaisController,
              keyboardType: TextInputType.datetime, // Allow date selection
              decoration: const InputDecoration(
                labelText: 'Date de naissance',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ajouterInformation,
                child: const Text('Ajouter'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
