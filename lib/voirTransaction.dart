import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON
class voirTransaction extends StatefulWidget {
  final String TransactionID;

  const voirTransaction({super.key, required this.TransactionID});

  @override
  State<voirTransaction> createState() => _voirTransactionState();
}

class _voirTransactionState extends State<voirTransaction> {
  @override
  void initState() {
    super.initState();
    consulterTransaction();
  }
  Map<String, dynamic>? transactionData;
  void consulterTransaction()async{
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/consulterTransaction/${widget.TransactionID}';
    print(url);
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
      );
      final dynamic responseData = json.decode(response.body);
      print('responseData $responseData');
      setState(() {
        transactionData = responseData;
      });
    }catch (e) {
      // Gérer les erreurs de réseau ou autres exceptions ici
      print('Exception: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la transaction'),
        backgroundColor: const Color(0xFF2596BE), // AppBar background color
      ),
      body: transactionData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTransactionDetail(
                  'Compte Expéditeur', transactionData!['compteExpediteur']),
              _buildTransactionDetail(
                  'Compte Destinataire', transactionData!['compteDestinataire']),
              _buildTransactionDetail(
                  'Montant', transactionData!['sommeTransaction']),
              _buildTransactionDetail(
                  'Portée de la Transaction', transactionData!['porteeTransaction']),
              _buildTransactionDetail(
                  'Type de Transaction', transactionData!['typeTransaction']),
              _buildTransactionDetail(
                  'Date d\'Envoi', transactionData!['dateEnvoi']),
              _buildTransactionDetail(
                  'Date de Réception', transactionData!['dateReception']),
              _buildTransactionDetail(
                  'Frais de Transfert', transactionData!['fraisTransfert']),
              _buildTransactionDetail(
                  'Taux de Change', transactionData!['tauxDeChange']),
              _buildTransactionDetail('Délai', transactionData!['delais']),
              // Ajoutez d'autres champs ici si nécessaire
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTransactionDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Spacing between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$title :',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
