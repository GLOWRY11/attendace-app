import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/authentication/chose_page_login.dart';
import 'package:attendance_appschool/models/EnseignantItem.dart';
import 'package:attendance_appschool/models/FonctionnaireItem.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  final DBHelper _dbHelper;
  EnseignantItem? _authenticatedEnseignant;
  FonctionnaireItem? _authenticatedFonctionnaire;

  AuthenticationProvider(this._dbHelper);

  void setContext(BuildContext context) {
  }

  EnseignantItem? get authenticatedEnseignant => _authenticatedEnseignant;

  FonctionnaireItem? get authenticatedFonctionnaire =>
      _authenticatedFonctionnaire;

  Future<bool> authenticateFonctionnaire(String email, String password) async {
    final fonctionnaireItemId =
    await _dbHelper.authenticateFonctionnaire(email, password);
    if (fonctionnaireItemId != -1) {
      final fonctionnaireDetails =
      await _dbHelper.getFonctionnaireDetails(email);
      _authenticatedFonctionnaire = FonctionnaireItem(
        id: fonctionnaireDetails[DBHelper.FONCTIONNAIRE_ID],
        cin: fonctionnaireDetails[DBHelper.FONCTIONNAIRE_CIN],
        nom: fonctionnaireDetails[DBHelper.FONCTIONNAIRE_NOM],
        prenom: fonctionnaireDetails[DBHelper.FONCTIONNAIRE_PRENOM],
        email: fonctionnaireDetails[DBHelper.FONCTIONNAIRE_EMAIL],
        gender: fonctionnaireDetails[DBHelper.FONCTIONNAIRE_SEXE],
        phonenumber: fonctionnaireDetails[DBHelper.FONCTIONNAIRE_PHONENUMBER],
        dateofbirth: fonctionnaireDetails[DBHelper.FONCTIONNAIRE_DATE],
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> authenticateEnseignant(String email, String password) async {
    final enseignantId =
    await _dbHelper.authenticateEnseignant(email, password);
    if (enseignantId != -1) {
      final enseignantDetails = await _dbHelper.getEnseignantDetails(email);
      _authenticatedEnseignant = EnseignantItem(
        id: enseignantDetails[DBHelper.ENSEIGNANT_ID],
        cin: enseignantDetails[DBHelper.ENSEIGNANT_CIN],
        nom: enseignantDetails[DBHelper.ENSEIGNANT_NOM],
        prenom: enseignantDetails[DBHelper.ENSEIGNANT_PRENOM],
        email: enseignantDetails[DBHelper.ENSEIGNANT_EMAIL],
        gender: enseignantDetails[DBHelper.ENSEIGNANT_SEXE],
        phonenumber: enseignantDetails[DBHelper.ENSEIGNANT_PHONENUMBER],
        dateofbirth: enseignantDetails[DBHelper.ENSEIGNANT_DATE],
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout(BuildContext context) {
    _authenticatedEnseignant = null;
    notifyListeners();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const ChosePageLogin()),
          (route) => false,
    );
  }
}
