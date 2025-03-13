import 'package:flutter/material.dart';

class EtudianteItem {
  int id;
  String nom;
  String prenom;
  int filierid;
  String massarId;
  String email;
  String phonenumber;
  String dateofbirth;
  bool? isPresent;
  String? gender;
  Color containerColor;
  IconData iconData;
  Color iconColor;
  Color textColor;

  EtudianteItem({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.filierid,
    required this.massarId,
    required this.gender,
    required this.email,
    required this.phonenumber,
    required this.dateofbirth,
    this.isPresent,
    this.containerColor = Colors.white,
    this.iconData = Icons.front_hand,
    this.iconColor = Colors.grey,
    this.textColor = Colors.black,
  });

  // Getters
  int get getId => id;
  String get getNom => nom;
  String get getPrenom => prenom;
  int get getFilierId => filierid;
  String get getMassarId => massarId;

  // Setters
  set setId(int id) => this.id = id;
  set setNom(String nom) => this.nom = nom;
  set setPrenom(String prenom) => this.prenom = prenom;
  set setFilier(int filierid) => this.filierid = filierid;
  set setMassarId(String massarId) => this.massarId = massarId;
}
