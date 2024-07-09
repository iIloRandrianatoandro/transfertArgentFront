import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON

class ajoutInformation extends StatefulWidget {
  final String userID;

  const ajoutInformation({Key? key, required this.userID}) : super(key: key);

  @override
  State<ajoutInformation> createState() => _ajoutInformationState();
}

class _ajoutInformationState extends State<ajoutInformation> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _adresseController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _dateNaisController = TextEditingController();

  void ajouterInformation() async{
    print('ajout information');
    print(widget.userID);
    // Extract data from controllers
    final String nom = _nomController.text;
    final String prenom = _prenomController.text;
    final String adresse = _adresseController.text;
    final String telephone = _telephoneController.text;
    final String dateNais = _dateNaisController.text;

    /*print(nom);
    print(prenom);*/
    // Implement form validation
    /*if (nom.isEmpty || prenom.isEmpty || adresse.isEmpty || telephone.isEmpty || dateNais.isEmpty) {
      // Display error message (e.g., using a SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }*/
    // Send data to backend
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/ajouterInformation/${widget.userID}';
  print(url);
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
/*
      // Décoder la réponse JSON
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final code = responseData['code'];
      final String codeString = code.toString();
      print(codeString);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => verifierNumero(userID: widget.userID, code: codeString ),
        ),
      );*/
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
            TextField(
              controller: _adresseController,
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
