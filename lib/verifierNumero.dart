import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON
class verifierNumero extends StatefulWidget {
  final String userID;
  final String code;

  const verifierNumero({Key? key, required this.userID, required this.code}) : super(key: key);

  @override
  State<verifierNumero> createState() => _verifierNumeroState();
}

class _verifierNumeroState extends State<verifierNumero> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
