import 'package:flutter/material.dart';
import 'package:frontend/ajouterCompteDestinataireFromUS.dart';
import 'package:frontend/ajouterCompteExpediteurUS.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON

class transfererArgentUS extends StatefulWidget {
  final String userID;

  const transfererArgentUS({Key? key, required this.userID}) : super(key: key);

  @override
  State<transfererArgentUS> createState() => _transfererArgentUSState();
}

class _transfererArgentUSState extends State<transfererArgentUS> {
  @override
  void initState() {
    super.initState();
    getListeExpediteurUS('US');
    getListeDestinataireMada('Mada');
    expediteurSelectionneUS = null;
    destinataireSelectionneMada = null;
  }
  List<String> listeExpediteurUS=[];
  List<String> listeDestinataireMada=[];
  final List<String> listeTypeTransactionInternational = ['Bank To Bank','Bank To Mobile Money'];
  // Selected values for dropdowns (initialize with defaults)
  String? expediteurSelectionneUS;
  String? destinataireSelectionneMada;
  String typeTransactionSelectionneInternational = 'Bank To Bank';
  final _sommeController = TextEditingController();

  //get listes expediteur from backend
  void getListeExpediteurUS(String adresse)async{
    String typeCompte = 'Compte bancaire';
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/listerCompteExpediteurSelonTypeCompteUS/${widget.userID}';
    print(url);
    // Données à envoyer
    final Map<String, String> data = {
      'typeCompte' : typeCompte,
      'adresse':'US',
    };
    print('data : $data');
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      final dynamic responseData = json.decode(response.body);
      print('responseData $responseData');
      List<String> numeroComptes = [];
      for (final compteData in responseData) {
        numeroComptes.add(compteData["numeroCompte"] as String);
      }
      setState(() {
        listeExpediteurUS = numeroComptes;
      });
      print('listeExpediteur : $listeExpediteurUS');
    }catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }
  //get listes destinataire from backend
  void getListeDestinataireMada(String adresse)async{
    String typeCompte = '';
    if (typeTransactionSelectionneInternational=='Bank To Bank'){
      typeCompte = 'Compte bancaire';
    }
    else if (typeTransactionSelectionneInternational=='Bank To Mobile Money'){
      typeCompte = 'Mobile Money';
    }
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/listerCompteDestinataireSelonTypeCompteMada/${widget.userID}';
    // Données à envoyer
    final Map<String, String> data = {
      'typeCompte' : typeCompte,
      'adresse':'Mada',
    };
    //print(data);
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print(response.body);
      final dynamic responseData = json.decode(response.body);
      List<String> numeroComptes = [];
      for (final compteData in responseData) {
        numeroComptes.add(compteData["numeroCompte"] as String);
      }
      setState(() {
        listeDestinataireMada = numeroComptes;
      });
      //print('listeDestinataire : $listeDestinataireMada');
    }catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }
  String ajouterOption='Ajouter';
  void voirCoutTransactionUS(String porteeTransaction)async{
    // Extract data from controllers
    final String typeTransaction = typeTransactionSelectionneInternational;
    final String compteExpediteur = expediteurSelectionneUS!;
    final String sommeTransaction = _sommeController.text;
    final String compteDestinataire = destinataireSelectionneMada!;
    final String madaToUs='false';
    // Send data to backend
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/voirCoutTransaction/${widget.userID}';
    //print(url);
    // Données à envoyer
    final Map<String, dynamic> data = {
      'typeTransaction' : typeTransaction,
      'compteExpediteur' : compteExpediteur,
      'sommeTransaction' : sommeTransaction,
      'compteDestinataire' : compteDestinataire,
      'porteeTransaction': porteeTransaction,
      'madaToUs':madaToUs,
    };
    //print(data);
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      // Décoder la réponse JSON
      //print(response.body);
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Extraire les informations de la réponse
      final String compteExpediteur = responseData['compteExpediteur'];
      final String compteDestinataire = responseData['compteDestinataire'];
      final String delais = responseData['delais'].toString();
      final String typeTransaction = responseData['typeTransaction'];
      final String fraisTransfert = responseData['fraisTransfert'].toString();
      final String porteeTransaction = responseData['porteeTransaction'];
      final String tauxDeChange = responseData['tauxDeChange'].toString();
      final String sommeTransaction = responseData['sommeTransaction'].toString();

      // Afficher la boîte de dialogue de confirmation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation de transaction'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Compte expéditeur: $compteExpediteur'),
                  Text('Compte destinataire: $compteDestinataire'),
                  Text('Délais: $delais'),
                  Text('Type de transaction: $typeTransaction'),
                  Text('Frais de transfert: $fraisTransfert'),
                  Text('Portée de la transaction: $porteeTransaction'),
                  Text('Taux de change: $tauxDeChange'),
                  Text('Somme de la transaction: $sommeTransaction'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirmer'),
                onPressed: () {
                  print('confirmer');
                  transfererArgent(
                    typeTransaction: typeTransaction,
                    compteExpediteur: compteExpediteur,
                    sommeTransaction: sommeTransaction,
                    compteDestinataire: compteDestinataire,
                    porteeTransaction: porteeTransaction,
                    fraisTransfert: fraisTransfert,
                    tauxDeChange: tauxDeChange,
                    delais: delais,
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
  void transfererArgent({
    required String typeTransaction,
    required String compteExpediteur,
    required String sommeTransaction,
    required String compteDestinataire,
    required String porteeTransaction,
    required String fraisTransfert,
    required String tauxDeChange,
    required String delais,
  })async{
    // Send data to backend
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/creerTransaction/${widget.userID}';
    //print(url);
    // Données à envoyer
    final Map<String, String> data = {
      'typeTransaction' : typeTransaction,
      'compteExpediteur' : compteExpediteur,
      'sommeTransaction' : sommeTransaction,
      'compteDestinataire' : compteDestinataire,
      'porteeTransaction': porteeTransaction,
      'fraisTransfert':fraisTransfert,
      'tauxDeChange':tauxDeChange,
      'delais':delais,

    };
    //print(data);
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      //print(response.body);
      if(response.body=="somme manquante"){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Somme manquante'),
              content: Text('Vous n\'avez pas assez d\'argent dans votre compte.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      else{
        // Afficher la boîte de dialogue de confirmation
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text('L\'argent a été transféré avec succès.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => transfererArgentUS(userID: widget.userID),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
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
              DropdownButtonFormField<String>(
                value: typeTransactionSelectionneInternational,
                items: listeTypeTransactionInternational.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                )).toList(),
                onChanged: (value) {
                  setState(() => typeTransactionSelectionneInternational = value!);
                  getListeExpediteurUS('US');
                  getListeDestinataireMada('Mada');
                  expediteurSelectionneUS = null;
                  destinataireSelectionneMada = null;
                },
                decoration: const InputDecoration(
                  labelText: 'Type de transaction',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: expediteurSelectionneUS,
                items: [...listeExpediteurUS, ajouterOption].map((recipient) => DropdownMenuItem(
                  value: recipient,
                  child: Text(recipient),
                )).toList(),
                onChanged: (value) {
                  if (value == ajouterOption) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ajouterCompteExpediteurUS(userID:widget.userID)),
                    );
                  } else {
                    setState(() => expediteurSelectionneUS = value!);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Expediteur',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: destinataireSelectionneMada,
                items: [...listeDestinataireMada,ajouterOption].map((recipient) => DropdownMenuItem(
                  value: recipient,
                  child: Text(recipient),
                )).toList(),
                onChanged: (value) {
                  if (value == ajouterOption) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ajouterCompteDestinataireFromUS(userID:widget.userID)),
                    );
                  } else {
                    setState(() => destinataireSelectionneMada = value!);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Destinataire',
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
              const SizedBox(height: 20.0),
              FilledButton(
                onPressed: (){voirCoutTransactionUS('international');},
                child: const Text('Transferer'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(500, 50),
                ),
              ),
            ]
        )
      ),
    );
  }
}
