import 'package:flutter/material.dart';
// Pour encoder les données en JSON
class verifierNumero extends StatefulWidget {
  final String userID;
  final String code;

  const verifierNumero({super.key, required this.userID, required this.code});

  @override
  State<verifierNumero> createState() => _verifierNumeroState();
}

class _verifierNumeroState extends State<verifierNumero> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
