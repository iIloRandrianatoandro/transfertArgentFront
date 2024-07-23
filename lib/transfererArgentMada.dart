import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON
import 'package:frontend/seConnecter.dart';

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
    getListeExpediteur();
    getListeDestinataire();
  }
  // Sample data for dropdown lists (replace with actual data fetching)
  final List<String> listeTypeTransaction = ['Bank To Mobile Money', 'Bank To Bank','Mobile Money To Mobile Money'];
  List<String> listeExpediteur=[];
  List<String> listeDestinataire=[];

  // Selected values for dropdowns (initialize with defaults)
  String typeTransactionSelectionne = 'Bank To Bank';
  String? expediteurSelectionne;
  String? destinataireSelectionne;


  //get listes expediteur from backend
  void getListeExpediteur()async{
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/listerCompteExpediteur/${widget.userID}';
    final http.Response response = await http.get(Uri.parse(url));
    final dynamic responseData = json.decode(response.body);
    List<String> numeroComptes = [];
    for (final compteData in responseData) {
      numeroComptes.add(compteData["numeroCompte"] as String);
    }
    setState(() {
      listeExpediteur = numeroComptes;
    });
    print(listeExpediteur);
  }
  //get listes expediteur from backend
  void getListeDestinataire()async{
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/listerCompteDestinataire/${widget.userID}';
    final http.Response response = await http.get(Uri.parse(url));
    final dynamic responseData = json.decode(response.body);
    List<String> numeroComptes = [];
    for (final compteData in responseData) {
      numeroComptes.add(compteData["numeroCompte"] as String);
    }
    setState(() {
      listeDestinataire = numeroComptes;
    });
    print(listeDestinataire);
  }

  // Text controller for the amount input
  final _sommeController = TextEditingController();

  final String ajouterOption = 'Ajouter';

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
                onPressed: () => setState(() => local = true),
                child: Text(local ? 'Local (Sélectionné)' : 'Local'),
                style: ElevatedButton.styleFrom(
                backgroundColor: local ? Colors.blue : Colors.grey[200],
                ),
                ),
                ElevatedButton(
                onPressed: () => setState(() => local = false),
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
                  onChanged: (value) => setState(() => typeTransactionSelectionne = value!),
                  decoration: const InputDecoration(
                    labelText: 'Type de transaction',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: expediteurSelectionne,
                  items: listeExpediteur.map((sender) => DropdownMenuItem(
                    value: sender,
                    child: Text(sender),
                  )).toList(),
                  onChanged: (value) => setState(() => expediteurSelectionne = value!),
                  decoration: const InputDecoration(
                    labelText: 'Expéditeur',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: destinataireSelectionne,
                  items: [ajouterOption, ...listeDestinataire].map((recipient) => DropdownMenuItem(
                    value: recipient,
                    child: Text(recipient),
                  )).toList(),
                  onChanged: (value) {
                    if (value == ajouterOption) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const seConnecter()),
                      );
                    } else {
                      setState(() => destinataireSelectionne = value!);
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
                  onPressed: (){print('Transfert local en cours...');getListeExpediteur();},
                  child: const Text('Transferer'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(500, 50),
                  ),
                ),
              ]
            ],
          )
      ),
    );
  }
}
