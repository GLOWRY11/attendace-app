import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/navigation_menu_admin.dart';
import 'package:attendance_appschool/provider/AuthenticationProvider.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../../data/sqflite/DBHelper.dart';

class LoginFonctionnaireScreen extends StatefulWidget {
  const LoginFonctionnaireScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<LoginFonctionnaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  late DBHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = Provider.of<DBHelper>(context, listen: false);
    // Initialisation des données dans la base de données
    final dbHelper = Provider.of<DBHelper>(context, listen: false);
    dbHelper
        .addFonctionnaire(
          nom: 'Martin',
          prenom: 'Dubois',
          cin: "v209013",
          email: 'martin.dubois@estm.edu',
          date: '1990-01-01',
          sexe: 'Male',
          phoneNumber: '1234567890',
          motDePasse: 'password123',
        )
        .then((fonctionnaireId) {
      print('Inserted fonctionnaire with ID: $fonctionnaireId');
    }).catchError((error) {
      print('Failed to insert fonctionnaire: $error');
    });

    dbHelper
        .addEtudiant(
          'Sophie',
          'Bernard',
          1,
          "v209013",
          'Female',
          'sophie.bernard@estm.edu',
          '1234567890',
          '1990-01-01',
        )
        .then((etudiantId) {
      print('Inserted etudiant with ID: $etudiantId');
    }).catchError((error) {
      print('Failed to insert etudiant: $error');
    });

    addEnseignant();
  }

  Future<void> addEnseignant() async {
    final dbHelper = Provider.of<DBHelper>(context, listen: false);
    await dbHelper.addEnseignant(
      'Pierre Martin',
      'P987654',
      'Homme',
      'Pierre',
      'pierre.martin@estm.edu',
      '0611111111',
      '1988-03-20',
      'password789'
    );

    await dbHelper.addEnseignant(
      'Sophie Bernard',
      'S456789',
      'Femme',
      'Sophie',
      'sophie.bernard@estm.edu',
      '0622222222',
      '1992-08-10',
      'password101'
    );

    // Identifiants de connexion pour les enseignants :
    // Email: pierre.martin@estm.edu
    // Mot de passe: password789
    // 
    // Email: sophie.bernard@estm.edu
    // Mot de passe: password101
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        print('Tentative de connexion avec:');
        print('Email: $email');
        print('Mot de passe: $password');

        await _dbHelper.printAllFonctionnaires();
        
        final exists = await _dbHelper.fonctionnaireExists(email);
        if (!exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ce fonctionnaire n\'existe pas dans la base de données')),
          );
          return;
        }

        await _dbHelper.printFonctionnaireDetails(email);

        final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
        final isAuthenticated = await authProvider.authenticateFonctionnaire(email, password);
        if (isAuthenticated) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NavigationMenuAdmin()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(S.of(context).bienvenue),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).identifiants_invalides),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 40,
            color: TColors.firstcolor,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 1100),
                        child: Center(
                          child: Image.asset(
                            "assets/images/logo3.png",
                            height: MediaQuery.of(context).size.height * 0.28,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Text(
                              S
                                  .of(context)
                                  .bienvenue_dans_l_espace_fonctionnaire,
                              style: const TextStyle(
                                color: TColors.firstcolor,
                                fontSize: 32,
                                fontFamily: 'Sarala',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Text(
                              S.of(context).connectez_vous_maintenant,
                              style: const TextStyle(
                                color: TColors.firstcolor,
                                fontSize: 32,
                                fontFamily: 'Sarala',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1500),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 24),
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide:
                                  const BorderSide(color: TColors.firstcolor),
                            ),
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              fontSize: 24,
                            ),
                            labelText: S.of(context).email,
                            prefixIcon: const Icon(Icons.person),
                            floatingLabelStyle: const TextStyle(
                              color: TColors.firstcolor,
                              fontSize: 24,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (val) => val!.trim().isEmpty
                              ? S.of(context).veuillez_fournir_une_adresse_email
                              : null,
                        ),
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1600),
                        child: TextFormField(
                          style: const TextStyle(fontSize: 24),
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                              borderSide:
                                  const BorderSide(color: TColors.firstcolor),
                            ),
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              fontSize: 26,
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: TColors.firstcolor,
                              fontSize: 24,
                            ),
                            labelText: S.of(context).mot_de_passe,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_passwordVisible,
                          onFieldSubmitted: (_) => _submitForm(),
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return S
                                  .of(context)
                                  .veuillez_fournir_un_mot_de_passe;
                            }
                            if (val.trim().length < 4) {
                              return S
                                  .of(context)
                                  .le_mot_de_passe_doit_comporter_au_moins_4_caracteres;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1800),
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                TColors.firstcolor),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            minimumSize: WidgetStateProperty.all(
                                const Size(double.infinity, 60)),
                          ),
                          child: Text(
                            S.of(context).connexion,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Sarala',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1900),
                        child: Center(
                          child: Text(
                            "ESTM Digital",
                            style: TextStyle(
                              color: TColors.firstcolor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 2000),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            S.of(context).realisation_par,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 28,
                              fontFamily: 'SaralaRegulair',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
