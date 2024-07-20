import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  // Sample data for dropdown lists (replace with actual data fetching)
  final List<String> transactionTypes = ['Bank To Mobile Money', 'Bank To Bank','Mobile Money To Mobile Money'];
  final List<String> senders = ['John Doe', 'Jane Doe'];
  final List<String> recipients = ['David Lee', 'Alice Smith'];

  // Selected values for dropdowns (initialize with defaults)
  String _selectedTransactionType = 'Bank To Bank';
  String _selectedSender = 'John Doe';
  String _selectedRecipient = 'David Lee';

  // Text controller for the amount input
  final _amountController = TextEditingController();
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
                  value: _selectedTransactionType,
                  items: transactionTypes.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedTransactionType = value!),
                  decoration: const InputDecoration(
                    labelText: 'Type de transaction',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: _selectedSender,
                  items: senders.map((sender) => DropdownMenuItem(
                    value: sender,
                    child: Text(sender),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedSender = value!),
                  decoration: const InputDecoration(
                    labelText: 'Expéditeur',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: _selectedRecipient,
                  items: recipients.map((recipient) => DropdownMenuItem(
                    value: recipient,
                    child: Text(recipient),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedRecipient = value!),
                  decoration: const InputDecoration(
                    labelText: 'Destinataire',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Somme',
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: (){print('Transfert local en cours...');},
                  child: const Text('Transferer'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ]
            ],
          )
      ),
    );
  }
}
