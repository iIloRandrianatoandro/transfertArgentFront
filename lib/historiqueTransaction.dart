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

  const historiqueTransaction({super.key, required this.userID});

  @override
  State<historiqueTransaction> createState() => _historiqueTransactionState();
}

class _historiqueTransactionState extends State<historiqueTransaction> {
  List<Transaction> transactionsAchevees = [];
  List<Transaction> transactionsEnCours = [];
  bool _isLoading = true;
  bool _isLoading2 = true;

  @override
  void initState() {
    super.initState();
    getListeTransactionEnCours();
    getListeTransactionAchevee();
  }

  void getListeTransactionEnCours() async {
    final String url =
        'http://10.0.2.2:8000/api/listerTransactionEnCours/${widget.userID}';
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
      );
      final dynamic responseData = json.decode(response.body);
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
        transactionsEnCours = transactions;
        _isLoading2 = false;
      });
    } catch (e) {
      print('Exception: $e');
    }
  }

  void getListeTransactionAchevee() async {
    final String url =
        'http://10.0.2.2:8000/api/listerTransactionAchevee/${widget.userID}';
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
      );
      final dynamic responseData = json.decode(response.body);
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
        transactionsAchevees = transactions;
        _isLoading = false;
      });
    } catch (e) {
      print('Exception: $e');
    }
  }

  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Transactions'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2596BE),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Transactions en Cours'),
              _isLoading2
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactionsEnCours.length,
                itemBuilder: (context, index) {
                  final transaction = transactionsEnCours[index];
                  return _buildTransactionTile(transaction, true);
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Transactions Achevées'),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactionsAchevees.length,
                itemBuilder: (context, index) {
                  final transaction = transactionsAchevees[index];
                  return _buildTransactionTile(transaction, false);
                },
              ),
            ],
          ),
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
        unselectedItemColor: const Color(0xFF2596BE),
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    transfererArgentUS(userID: widget.userID),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    historiqueTransaction(userID: widget.userID),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2596BE),
        ),
      ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction, bool isOngoing) {
    return Card(
      color: isOngoing ? const Color(0xFFE3F2FD) : const Color(0xFFF1F8E9),
      elevation: 5,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(
          isOngoing ? Icons.sync : Icons.check_circle,
          color: isOngoing ? Colors.blue : Colors.green,
        ),
        title: Text(
          'Expéditeur: ${transaction.compteExpediteur}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Destinataire: ${transaction.compteDestinataire}\nMontant: ${transaction.sommeTransaction}',
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16.0,
        ),
        onTap: () {
          print('Transaction sélectionnée: ${transaction.id}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  voirTransaction(TransactionID: transaction.id.toString()),
            ),
          );
        },
      ),
    );
  }
}
