import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/navigation_menu_prof.dart';
import 'package:attendance_appschool/provider/AuthenticationProvider.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:attendance_appschool/data/sqflite/DBHelper.dart';

class LoginEnsignScreen extends StatefulWidget {
  const LoginEnsignScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<LoginEnsignScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  late DBHelper _dbHelper;
  late AuthenticationProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _dbHelper = Provider.of<DBHelper>(context, listen: false);
    _authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    
    // Initialize test teachers
    _initializeTeachers();
  }

  Future<void> _initializeTeachers() async {
    try {
      // Check if teachers already exist
      final exists1 = await _dbHelper.enseignantExists('pierre.martin@estm.edu');
      final exists2 = await _dbHelper.enseignantExists('sophie.bernard@estm.edu');

      if (!exists1) {
        await _dbHelper.addEnseignant(
          'Martin',
          'Pierre',
          'P987654',
          'pierre.martin@estm.edu',
          'password789',
          'Homme',
          '0611111111',
          '1988-03-20'
        );
        print('Teacher 1 added successfully');
      }

      if (!exists2) {
        await _dbHelper.addEnseignant(
          'Bernard',
          'Sophie',
          'S456789',
          'sophie.bernard@estm.edu',
          'password101',
          'Femme',
          '0622222222',
          '1992-08-10'
        );
        print('Teacher 2 added successfully');
      }

      // Print all teachers for debugging
      await _dbHelper.printAllEnseignants();
    } catch (e) {
      print('Error initializing teachers: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        print('Tentative de connexion avec:');
        print('Email: $email');
        print('Mot de passe: $password');
        
        await _dbHelper.printAllEnseignants();
        
        final exists = await _dbHelper.enseignantExists(email);
        if (!exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cet enseignant n\'existe pas dans la base de données')),
          );
          return;
        }

        await _dbHelper.printEnseignantDetails(email);

        final success = await _authProvider.authenticateEnseignant(email, password);
        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigationMenuProf()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bienvenue ${_authProvider.authenticatedEnseignant?.prenom ?? ""}!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Identifiants invalides')),
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
      backgroundColor: Colors.white,
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
                              S.of(context).bienvenue_dans_l_espace_enseignant,
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
                          const SizedBox(
                            height: 15,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Text(
                              S.of(context).contactAdministrator,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 22,
                                fontFamily: 'SaralaRegulair',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
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
                              borderSide: const BorderSide(color: TColors.firstcolor),
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
                              borderSide: const BorderSide(color: TColors.firstcolor),
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
                          onFieldSubmitted: (_) => _login(),
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
                          onPressed: _login,
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
