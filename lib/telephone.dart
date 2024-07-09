import 'package:flutter/material.dart';
import 'package:frontend/verifierNumero.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON

class telephone extends StatefulWidget {
  final String userID;

  const telephone({Key? key, required this.userID}) : super(key: key);

  @override
  State<telephone> createState() => _telephoneState();
}

class _telephoneState extends State<telephone> {
  final _phoneController = TextEditingController(); // Controller for phone number input

  @override
  void dispose() {
    // Libération des ressources des contrôleurs lorsqu'ils ne sont plus nécessaires
    _phoneController.dispose();
    super.dispose();
  }

  void _verifyPhone() async{
    final String phone = _phoneController.text;
    print('Phone number: $phone');
    // URL de votre endpoint Laravel
    final String url = 'http://10.0.2.2:8000/api/envoyerCodeSmsVerificationTelephone';

    // Données à envoyer
    final Map<String, String> data = {
      'numero': _phoneController.text,
    };
    // Envoi de la requête POST
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      //final String code = response.body;

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
      );
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Vérification du numéro de téléphone',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Numéro de téléphone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (){
                    _verifyPhone();
                  },
                  child: const Text('Vérifier'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
