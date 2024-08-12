import 'package:flutter/material.dart';
import 'package:frontend/motDePasse.dart';
import 'package:frontend/sInscrire.dart';

class verifierMail extends StatefulWidget {
  final String code; // Declare the argument
  final String email;

  const verifierMail({super.key, required this.code, required this.email});

  @override
  State<verifierMail> createState() => _verifierMailState();
}

class _verifierMailState extends State<verifierMail> {
  final _codeControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('i-Money'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2596BE), // Couleur de fond de l'AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verification mail',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Veuillez entrer le code envoyé par mail',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var controller in _codeControllers)
                  SizedBox(
                    width: 60.0,
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            FilledButton(
                onPressed: (){
                  // Implement verification logic here
                  // Use the code entered in the text fields to verify the user
                  String enteredCode = '';
                  for (var controller in _codeControllers) {
                    enteredCode += controller.text;
                  }

                  if (enteredCode == widget.code) {
                    // Verification successful
                    print('Verification successful!');
                    // Navigate to the next screen or perform other actions
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => motDePasse(email: widget.email),
                      ),
                    );
                  } else {
                    // Verification failed
                    print('Verification failed!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const sInscrire()),
                    );
                  }
                },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(500, 50), // Set button size
                backgroundColor: const Color(0xFF2596BE),
              ),
              child: const Text('Vérifier'),
            )
          ],
        ),
      ),
    );
  }
}
