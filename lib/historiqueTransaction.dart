import 'package:flutter/material.dart';
import 'package:frontend/transfererArgentUS.dart';
import 'package:frontend/voirTransaction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON

class Transaction {
  final int id;
  final String compteExpediteur;
  final String compteDestinataire;
  final String sommeTransaction;

  Transaction({
    required this.id,
    required this.compteExpediteur,
    required this.compteDestinataire,
    required this.sommeTransaction,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      compteExpediteur: json['compteExpediteur'],
      compteDestinataire: json['compteDestinataire'],
      sommeTransaction: json['sommeTransaction'],
    );
  }
}

class historiqueTransaction extends StatefulWidget {
  final String userID;

  const historiqueTransaction({Key? key, required this.userID}) : super(key: key);

  @override
  State<historiqueTransaction> createState() => _historiqueTransactionState();
}

class _historiqueTransactionState extends State<historiqueTransaction> {
  List<Transaction> transactionsAchevees =[];
  List<Transaction> transactionsEnCours =[];
  bool _isLoading = true;
  bool _isLoading2 = true;
  @override
  void initState() {
    super.initState();
    getListeTransactionEnCours();
    getListeTransactionAchevee();
  }

  //get listes expediteur from backend
  void getListeTransactionEnCours()async{
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/listerTransactionEnCours/${widget.userID}';
    print(url);
    // Envoi de la requête POST
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
      );
      final dynamic responseData = json.decode(response.body);
      print('responseData $responseData');
      List<Transaction> transactions = [];
      for (var item in responseData) {
        if (item is Map<String, dynamic>) {
          try {
            transactions.add(Transaction.fromJson(item));
          } catch (e) {
            print('Error parsing transaction: $e');
          }
        } else {
          print('Unexpected data type: $item');
        }
      }
      setState(() {
        this.transactionsEnCours = transactions;
        _isLoading2 = false;
      });

    }catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }
  void getListeTransactionAchevee()async{
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/listerTransactionAchevee/${widget.userID}';
    print(url);
    // Envoi de la requête POST
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
      );
      final dynamic responseData = json.decode(response.body);
      print('responseData $responseData');
      List<Transaction> transactions = [];
      for (var item in responseData) {
        if (item is Map<String, dynamic>) {
          try {
            transactions.add(Transaction.fromJson(item));
          } catch (e) {
            print('Error parsing transaction: $e');
          }
        } else {
          print('Unexpected data type: $item');
        }
      }
      setState(() {
        this.transactionsAchevees = transactions;
        _isLoading = false;
      });

    }catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Historique des transactions'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text('Transactions en cours'),
              _isLoading2 ? Center(child: CircularProgressIndicator()) :
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactionsEnCours.length,
                itemBuilder: (context, index) {
                  final transaction = transactionsEnCours[index];
                  return ListTile(
                    title: Text('Expéditeur:${transaction.compteExpediteur}'),
                        subtitle: Text('Destinataire: ${transaction.compteDestinataire}\nMontant: ${transaction.sommeTransaction}'),
                    onTap: () {
                      print('Transaction sélectionnée: ${transaction.id}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => voirTransaction(TransactionID:transaction.id.toString())),
                      );

                    },
                  );
                },
              ),
              Text('Transactions achevées'),
              _isLoading ? Center(child: CircularProgressIndicator()) :
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactionsAchevees.length,
                itemBuilder: (context, index) {
                  final transaction = transactionsAchevees[index];
                  return ListTile(
                    title: Text('Expéditeur: ${transaction.compteExpediteur}'),
                        subtitle: Text('Destinataire: ${transaction.compteDestinataire}\nMontant: ${transaction.sommeTransaction}'),
                    onTap: () {
                      // Action à effectuer lors du clic, par exemple :
                      print('Transaction sélectionnée: ${transaction.id}');
                      // Naviguer vers une autre page avec les détails de la transaction
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => voirTransaction(TransactionID:transaction.id.toString())),
                      );
                    },
                  );
                },

              ),
            ],
          ),
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
          selectedItemColor: Colors.grey,
          unselectedItemColor: Colors.blue,
          onTap:  (index) {
            if (index == 0) {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) =>
                      transfererArgentUS(userID: widget.userID),
                ),
              );
            } else if (index == 1) {
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) =>
                      historiqueTransaction(userID: widget.userID),
                ),
              );
            }
          }
        ),
    );
  }
}
