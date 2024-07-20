import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour encoder les données en JSON

class transfererArgentUS extends StatefulWidget {
  final String userID;

  const transfererArgentUS({Key? key, required this.userID}) : super(key: key);

  @override
  State<transfererArgentUS> createState() => _transfererArgentUSState();
}

class _transfererArgentUSState extends State<transfererArgentUS> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
