import 'package:flutter/material.dart';
import 'package:frontend/ajouterCompteDestinataire.dart';
import 'package:frontend/ajouterCompteDestinataireUS.dart';
import 'package:frontend/ajouterCompteExpediteur.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/historiqueTransaction.dart';
import 'dart:convert'; // Pour encoder les données en JSON

class transfererArgentMada extends StatefulWidget {
  final String userID;
  const transfererArgentMada({Key? key, required this.userID}) : super(key: key);

  @override
  State<transfererArgentMada> createState() => _transfererArgentMadaState();
}

class _transfererArgentMadaState extends State<transfererArgentMada> {

  // Flag to indicate selected button (local or international)
  bool local = true;

  @override
  void initState() {
    super.initState();
    getListeExpediteurMada('Mada');
    getListeDestinataireMada('Mada');
    getListeDestinataireUS();
    expediteurSelectionneMada = null;
    destinataireSelectionneMada = null;
    destinataireSelectionneUS = null;
  }
  // Sample data for dropdown lists (replace with actual data fetching)
  final List<String> listeTypeTransaction = ['Bank To Mobile Money', 'Bank To Bank','Mobile Money To Mobile Money'];
  final List<String> listeTypeTransactionInternational = ['Bank To Bank'];
  List<String> listeExpediteurMada=[];
  List<String> listeDestinataireMada=[];
  List<String> listeDestinataireUS=[];

  // Selected values for dropdowns (initialize with defaults)
  String typeTransactionSelectionne = 'Bank To Bank';
  String typeTransactionSelectionneInternational = 'Bank To Bank';
  String? expediteurSelectionneMada;
  String? destinataireSelectionneMada;
  String? destinataireSelectionneUS;


  //get listes expediteur from backend
  void getListeExpediteurMada(String adresse)async{
    String typeCompte = '';
    if (typeTransactionSelectionne=='Bank To Bank'|| typeTransactionSelectionne=='Bank To Mobile Money'){
      typeCompte = 'Compte bancaire';
    }
    else if (typeTransactionSelectionne=='Mobile Money To Mobile Money' ){
      typeCompte = 'Mobile Money';
    }
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/listerCompteExpediteurSelonTypeCompteMada/${widget.userID}';
    // Données à envoyer
    final Map<String, String> data = {
      'typeCompte' : typeCompte,
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
      final dynamic responseData = json.decode(response.body);
      List<String> numeroComptes = [];
      for (final compteData in responseData) {
        numeroComptes.add(compteData["numeroCompte"] as String);
      }
      setState(() {
        listeExpediteurMada = numeroComptes;
      });
      print('listeExpediteur : $listeExpediteurMada');
    }catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }
  //get listes destinataire from backend
  void getListeDestinataireMada(String adresse)async{
    String typeCompte = '';
    if (typeTransactionSelectionne=='Bank To Bank'){
      typeCompte = 'Compte bancaire';
    }
    else if (typeTransactionSelectionne=='Mobile Money To Mobile Money' || typeTransactionSelectionne=='Bank To Mobile Money'){
      typeCompte = 'Mobile Money';
    }
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/listerCompteDestinataireSelonTypeCompteMada/${widget.userID}';
    // Données à envoyer
    final Map<String, String> data = {
      'typeCompte' : typeCompte,
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
      final dynamic responseData = json.decode(response.body);
      List<String> numeroComptes = [];
      for (final compteData in responseData) {
        numeroComptes.add(compteData["numeroCompte"] as String);
      }
      setState(() {
        listeDestinataireMada = numeroComptes;
      });
      print('listeDestinataire : $listeDestinataireMada');
    }catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }
  //get listes expediteur from backend
  void getListeDestinataireUS()async{
    String typeCompte = 'Compte bancaire';
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/listerCompteDestinataireSelonTypeCompteUS/${widget.userID}';
    // Données à envoyer
    final Map<String, String> data = {
      'typeCompte' : typeCompte,
    };
    print(data);
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      final dynamic responseData = json.decode(response.body);
      List<String> numeroComptes = [];
      for (final compteData in responseData) {
        numeroComptes.add(compteData["numeroCompte"] as String);
      }
      setState(() {
        listeDestinataireUS = numeroComptes;
      });
      print('listeDestinataireUS : $listeDestinataireUS');
    }catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }

  // Text controller for the amount input
  final _sommeController = TextEditingController();
  void voirCoutTransaction(String porteeTransaction)async{
    //print('voirCoutTransaction');
    // Extract data from controllers
    final String typeTransaction = typeTransactionSelectionne;
    final String compteExpediteur = expediteurSelectionneMada!;
    final String sommeTransaction = _sommeController.text;
    final String compteDestinataire = destinataireSelectionneMada!;
    final String madaToUs='true';
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
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);

      // Extraire les informations de la réponse
      final String compteExpediteur = responseData['compteExpediteur'];
      final String compteDestinataire = responseData['compteDestinataire'];
      final String delais = responseData['delais'].toString();
      final String typeTransaction = responseData['typeTransaction'];
      final String fraisTransfert = responseData['fraisTransfert'].toString();
      final String porteeTransaction = responseData['porteeTransaction'];
      final String tauxDeChange = responseData['tauxDeChange'].toString();
      final String sommeTransaction = responseData['sommeTransaction'];

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
  void voirCoutTransactionUS(String porteeTransaction)async{
    // Extract data from controllers
    final String typeTransaction = typeTransactionSelectionneInternational;
    final String compteExpediteur = expediteurSelectionneMada!;
    final String sommeTransaction = _sommeController.text;
    final String compteDestinataire = destinataireSelectionneUS!;
    final String madaToUs='true';
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
      print(response.body);
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
    print(data);
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print(response.body);
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
                          builder: (context) => transfererArgentMada(userID: widget.userID),
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
  String ajouterOption='Ajouter';
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => transfererArgentMada(userID: widget.userID)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => historiqueTransaction(userID: widget.userID)),
        );
        break;
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
          child : Column(
            children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align buttons evenly
              children: [
                ElevatedButton(
                onPressed: () => {
      expediteurSelectionneMada = null,
      destinataireSelectionneMada = null,
      destinataireSelectionneUS = null,setState(() => local = true)},
                child: Text(local ? 'Local (Sélectionné)' : 'Local'),
                style: ElevatedButton.styleFrom(
                backgroundColor: local ? Colors.blue : Colors.grey[200],
                ),
                ),
                ElevatedButton(
                onPressed: () => {
                  expediteurSelectionneMada = null,
                  destinataireSelectionneMada = null,
                  destinataireSelectionneUS = null,setState(() => local = false)},
                child: Text(local ? 'International' : 'International (Sélectionné)'),
                style: ElevatedButton.styleFrom(
                backgroundColor: !local ? Colors.blue : Colors.grey[200],
                ),
                ),
              ]
              ),
              const SizedBox(height: 20.0),
              //si local
              if(local) ... [
          DropdownButtonFormField<String>(
                  value: typeTransactionSelectionne,
                  items: listeTypeTransaction.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  )).toList(),
                  onChanged: (value) {
                    setState(() => typeTransactionSelectionne = value!);
                    getListeDestinataireMada('Mada');
                    getListeExpediteurMada('Mada');
                    destinataireSelectionneMada = null;
                    expediteurSelectionneMada= null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Type de transaction',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: expediteurSelectionneMada,
                  items: [...listeExpediteurMada, ajouterOption].map((recipient) => DropdownMenuItem(
                    value: recipient,
                    child: Text(recipient),
                  )).toList(),
                  onChanged: (value) {
                    if (value == ajouterOption) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ajouterCompteExpediteurMada(userID:widget.userID)),
                      );
                    } else {
                      setState(() => expediteurSelectionneMada = value!);
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
                        MaterialPageRoute(builder: (context) => ajouterCompteDestinataireMada(userID:widget.userID)),
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
                  onPressed: (){voirCoutTransaction('local');},
                  child: const Text('Transferer'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(500, 50),
                  ),
                ),
              ]
              //if internationnal
              else if(!local) ... [
                DropdownButtonFormField<String>(
                  value: typeTransactionSelectionneInternational,
                  items: listeTypeTransactionInternational.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  )).toList(),
                  onChanged: (value) {
                    setState(() => typeTransactionSelectionneInternational = value!);
                    getListeDestinataireUS();
                    getListeExpediteurMada('Mada');
                    destinataireSelectionneUS = null;
                    expediteurSelectionneMada= null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Type de transaction',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: expediteurSelectionneMada,
                  items: [...listeExpediteurMada, ajouterOption].map((recipient) => DropdownMenuItem(
                    value: recipient,
                    child: Text(recipient),
                  )).toList(),
                  onChanged: (value) {
                    if (value == ajouterOption) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ajouterCompteExpediteurMada(userID:widget.userID)),
                      );
                    } else {
                      setState(() => expediteurSelectionneMada = value!);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Expediteur',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: destinataireSelectionneUS,
                  items: [...listeDestinataireUS,ajouterOption].map((recipient) => DropdownMenuItem(
                    value: recipient,
                    child: Text(recipient),
                  )).toList(),
                  onChanged: (value) {
                    if (value == ajouterOption) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ajouterCompteDestinataireUS(userID:widget.userID)),
                      );
                    } else {
                      setState(() => destinataireSelectionneUS = value!);
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
            ],
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Transferer argent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
