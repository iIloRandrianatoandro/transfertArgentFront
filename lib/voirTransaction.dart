import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON
class voirTransaction extends StatefulWidget {
  final String TransactionID;

  const voirTransaction({Key? key, required this.TransactionID}) : super(key: key);

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
        this.transactionData = responseData;
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
      ),
      body: transactionData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Compte Expéditeur: ${transactionData!['compteExpediteur']}'),
            Text('Compte Destinataire: ${transactionData!['compteDestinataire']}'),
            Text('Montant: ${transactionData!['sommeTransaction']}'),
            Text('porteeTransaction: ${transactionData!['porteeTransaction']}'),
            Text('typeTransaction: ${transactionData!['typeTransaction']}'),
            Text('dateEnvoi: ${transactionData!['dateEnvoi']}'),
            Text('dateReception: ${transactionData!['dateReception']}'),
            Text('fraisTransfert: ${transactionData!['fraisTransfert']}'),
            Text('tauxDeChange: ${transactionData!['tauxDeChange']}'),
            Text('delais: ${transactionData!['delais']}'),
            // Ajoutez d'autres champs ici
          ],
        ),
      ),
    ),
    );
  }
}
