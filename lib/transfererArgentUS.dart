import 'package:flutter/material.dart';
import 'package:frontend/ajouterCompteDestinataireFromUS.dart';
import 'package:frontend/ajouterCompteExpediteurUS.dart';
import 'package:frontend/historiqueTransaction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON

class transfererArgentUS extends StatefulWidget {
  final String userID;

  const transfererArgentUS({super.key, required this.userID});

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
    const String madaToUs='false';
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // Bordures arrondies pour le dialogue
            ),
            title: const Text(
              'Confirmation de transaction',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2596BE), // Couleur du texte du titre
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  _buildTransactionDetail('Compte expéditeur:', compteExpediteur),
                  _buildTransactionDetail('Compte destinataire:', compteDestinataire),
                  _buildTransactionDetail('Délais:', delais),
                  _buildTransactionDetail('Type de transaction:', typeTransaction),
                  _buildTransactionDetail('Frais de transfert:', fraisTransfert),
                  _buildTransactionDetail('Portée de la transaction:', porteeTransaction),
                  _buildTransactionDetail('Taux de change:', tauxDeChange),
                  _buildTransactionDetail('Somme de la transaction:', sommeTransaction),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  backgroundColor: Colors.grey.shade200, // Couleur de fond du bouton Annuler
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordures arrondies pour le bouton
                  ),
                ),
                child: const Text(
                  'Annuler',
                  style: TextStyle(
                    color: Colors.black, // Couleur du texte du bouton Annuler
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  backgroundColor: const Color(0xFF2596BE), // Couleur de fond du bouton Confirmer
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordures arrondies pour le bouton
                  ),
                ),
                child: const Text(
                  'Confirmer',
                  style: TextStyle(
                    color: Colors.white, // Couleur du texte du bouton Confirmer
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Bordures arrondies pour le dialogue
              ),
              title: const Text(
                'Somme manquante',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2596BE), // Couleur du texte du titre
                ),
              ),
              content: const Text(
                'Vous n\'avez pas assez d\'argent sur votre compte.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54, // Couleur du texte du contenu
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF2596BE), // Couleur de fond du bouton
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bordures arrondies pour le bouton
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white, // Couleur du texte du bouton
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
      else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Bordures arrondies pour le dialogue
              ),
              title: const Text(
                'Confirmation',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2596BE), // Couleur du texte du titre
                ),
              ),
              content: const Text(
                'L\'argent a été transféré avec succès.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54, // Couleur du texte du contenu
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF2596BE), // Couleur de fond du bouton
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bordures arrondies pour le bouton
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white, // Couleur du texte du bouton
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
  final int _selectedIndex = 0;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => transfererArgentUS(userID: widget.userID)),
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
  // Définition de la fonction helper pour styliser les détails de la transaction
  Widget _buildTransactionDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Espacement vertical entre les lignes
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4, // Contrôle la largeur du titre
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 6, // Contrôle la largeur de la valeur
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfert d\'argent'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2596BE), // Couleur de fond de l'AppBar
        automaticallyImplyLeading: false, // Supprime la flèche de retour
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
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(500, 50),
                  backgroundColor: const Color(0xFF2596BE),
                ),
                child: const Text('Transferer'),
              ),
            ]
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
