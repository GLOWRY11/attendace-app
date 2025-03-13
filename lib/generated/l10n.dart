// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Ready to start?`
  String get ready_to_start {
    return Intl.message(
      'Ready to start?',
      name: 'ready_to_start',
      desc: '',
      args: [],
    );
  }

  /// `Select an option below to start`
  String get selectionnez_une_option_ci_dessous_pour_commencer {
    return Intl.message(
      'Select an option below to start',
      name: 'selectionnez_une_option_ci_dessous_pour_commencer',
      desc: '',
      args: [],
    );
  }

  /// `Civil servant`
  String get fonctionnaire {
    return Intl.message(
      'Civil servant',
      name: 'fonctionnaire',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get bienvenue {
    return Intl.message(
      'Welcome!',
      name: 'bienvenue',
      desc: '',
      args: [],
    );
  }

  /// `Invalid credentials. Please try again.`
  String get identifiants_invalides {
    return Intl.message(
      'Invalid credentials. Please try again.',
      name: 'identifiants_invalides',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Civil Servant space`
  String get bienvenue_dans_l_espace_fonctionnaire {
    return Intl.message(
      'Welcome to the Civil Servant space',
      name: 'bienvenue_dans_l_espace_fonctionnaire',
      desc: '',
      args: [],
    );
  }

  /// `Contact the administrator to obtain your credentials.`
  String get contactAdministrator {
    return Intl.message(
      'Contact the administrator to obtain your credentials.',
      name: 'contactAdministrator',
      desc: '',
      args: [],
    );
  }

  /// `Log in now`
  String get connectez_vous_maintenant {
    return Intl.message(
      'Log in now',
      name: 'connectez_vous_maintenant',
      desc: '',
      args: [],
    );
  }

  /// `Teachers Space`
  String get espace_enseignants {
    return Intl.message(
      'Teachers Space',
      name: 'espace_enseignants',
      desc: '',
      args: [],
    );
  }

  /// `E-mail`
  String get email {
    return Intl.message(
      'E-mail',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Please provide an email address`
  String get veuillez_fournir_une_adresse_email {
    return Intl.message(
      'Please provide an email address',
      name: 'veuillez_fournir_une_adresse_email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get mot_de_passe {
    return Intl.message(
      'Password',
      name: 'mot_de_passe',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get ajoutee {
    return Intl.message(
      'Add',
      name: 'ajoutee',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a password`
  String get veuillez_fournir_un_mot_de_passe {
    return Intl.message(
      'Please provide a password',
      name: 'veuillez_fournir_un_mot_de_passe',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 4 characters long`
  String get le_mot_de_passe_doit_comporter_au_moins_4_caracteres {
    return Intl.message(
      'Password must be at least 4 characters long',
      name: 'le_mot_de_passe_doit_comporter_au_moins_4_caracteres',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get connexion {
    return Intl.message(
      'Log In',
      name: 'connexion',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Teachers Space`
  String get bienvenue_dans_l_espace_enseignant {
    return Intl.message(
      'Welcome to the Teachers Space',
      name: 'bienvenue_dans_l_espace_enseignant',
      desc: '',
      args: [],
    );
  }

  /// `Total Teachers`
  String get total_enseignants {
    return Intl.message(
      'Total Teachers',
      name: 'total_enseignants',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get prenom {
    return Intl.message(
      'First Name',
      name: 'prenom',
      desc: '',
      args: [],
    );
  }

  /// `No teacher`
  String get no_teacher {
    return Intl.message(
      'No teacher',
      name: 'no_teacher',
      desc: '',
      args: [],
    );
  }

  /// `No students`
  String get no_students {
    return Intl.message(
      'No students',
      name: 'no_students',
      desc: '',
      args: [],
    );
  }

  /// `Please select a gender`
  String get select_gender {
    return Intl.message(
      'Please select a gender',
      name: 'select_gender',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get date_of_birth {
    return Intl.message(
      'Date of Birth',
      name: 'date_of_birth',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a name`
  String get veuillez_fournir_un_nom {
    return Intl.message(
      'Please provide a name',
      name: 'veuillez_fournir_un_nom',
      desc: '',
      args: [],
    );
  }

  /// `Please add a student`
  String get add_student_prompt {
    return Intl.message(
      'Please add a student',
      name: 'add_student_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a first name`
  String get veuillez_fournir_un_prenom {
    return Intl.message(
      'Please provide a first name',
      name: 'veuillez_fournir_un_prenom',
      desc: '',
      args: [],
    );
  }

  /// `Please add a teacher`
  String get add_teacher_prompt {
    return Intl.message(
      'Please add a teacher',
      name: 'add_teacher_prompt',
      desc: '',
      args: [],
    );
  }

  /// `National ID card`
  String get national_card {
    return Intl.message(
      'National ID card',
      name: 'national_card',
      desc: '',
      args: [],
    );
  }

  /// `List of teachers`
  String get teacher_list {
    return Intl.message(
      'List of teachers',
      name: 'teacher_list',
      desc: '',
      args: [],
    );
  }

  /// `Please provide an email address`
  String get email_prompt {
    return Intl.message(
      'Please provide an email address',
      name: 'email_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a valid email address`
  String get email_invalid {
    return Intl.message(
      'Please provide a valid email address',
      name: 'email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a National ID card`
  String get veuillez_fournir_un_cin {
    return Intl.message(
      'Please provide a National ID card',
      name: 'veuillez_fournir_un_cin',
      desc: '',
      args: [],
    );
  }

  /// `National ID card: {national_card}`
  String national_card_of(String national_card) {
    return Intl.message(
      'National ID card: $national_card',
      name: 'national_card_of',
      desc: '',
      args: [national_card],
    );
  }

  /// `Created by Abderrahmane Chaoui\nOmar Chouhani`
  String get realisation_par {
    return Intl.message(
      'Created by Abderrahmane Chaoui\nOmar Chouhani',
      name: 'realisation_par',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all fields`
  String get fill_all_fields {
    return Intl.message(
      'Please fill in all fields',
      name: 'fill_all_fields',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete teacher`
  String get delete_teacher {
    return Intl.message(
      'Delete teacher',
      name: 'delete_teacher',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this teacher?`
  String get confirm_delete_teacher {
    return Intl.message(
      'Are you sure you want to delete this teacher?',
      name: 'confirm_delete_teacher',
      desc: '',
      args: [],
    );
  }

  /// `National ID card must start with a character`
  String get id_card_error {
    return Intl.message(
      'National ID card must start with a character',
      name: 'id_card_error',
      desc: '',
      args: [],
    );
  }

  /// `Student Space`
  String get student_space {
    return Intl.message(
      'Student Space',
      name: 'student_space',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get enseignant {
    return Intl.message(
      'Teacher',
      name: 'enseignant',
      desc: '',
      args: [],
    );
  }

  /// `Module and Element Management Space`
  String get module_management_space {
    return Intl.message(
      'Module and Element Management Space',
      name: 'module_management_space',
      desc: '',
      args: [],
    );
  }

  /// `Profile Space`
  String get profile_space {
    return Intl.message(
      'Profile Space',
      name: 'profile_space',
      desc: '',
      args: [],
    );
  }

  /// `No major`
  String get no_major {
    return Intl.message(
      'No major',
      name: 'no_major',
      desc: '',
      args: [],
    );
  }

  /// `Please add a major`
  String get add_major_prompt {
    return Intl.message(
      'Please add a major',
      name: 'add_major_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Add a major`
  String get add_major {
    return Intl.message(
      'Add a major',
      name: 'add_major',
      desc: '',
      args: [],
    );
  }

  /// `Major Space`
  String get major_space {
    return Intl.message(
      'Major Space',
      name: 'major_space',
      desc: '',
      args: [],
    );
  }

  /// `Name of the major`
  String get major_name {
    return Intl.message(
      'Name of the major',
      name: 'major_name',
      desc: '',
      args: [],
    );
  }

  /// `List of Students`
  String get student_list {
    return Intl.message(
      'List of Students',
      name: 'student_list',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Massar`
  String get massar {
    return Intl.message(
      'Massar',
      name: 'massar',
      desc: '',
      args: [],
    );
  }

  /// `Massar: {massar}`
  String massar_of(String massar) {
    return Intl.message(
      'Massar: $massar',
      name: 'massar_of',
      desc: '',
      args: [massar],
    );
  }

  /// `Major`
  String get major {
    return Intl.message(
      'Major',
      name: 'major',
      desc: '',
      args: [],
    );
  }

  /// `Major: {major}`
  String major_of(String major) {
    return Intl.message(
      'Major: $major',
      name: 'major_of',
      desc: '',
      args: [major],
    );
  }

  /// `School Year : {school_year}`
  String school_year_of(String school_year) {
    return Intl.message(
      'School Year : $school_year',
      name: 'school_year_of',
      desc: '',
      args: [school_year],
    );
  }

  /// `Semester : {semester}`
  String semester_of(String semester) {
    return Intl.message(
      'Semester : $semester',
      name: 'semester_of',
      desc: '',
      args: [semester],
    );
  }

  /// `Please provide the name of the major`
  String get major_name_prompt {
    return Intl.message(
      'Please provide the name of the major',
      name: 'major_name_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Select the semester`
  String get select_semester {
    return Intl.message(
      'Select the semester',
      name: 'select_semester',
      desc: '',
      args: [],
    );
  }

  /// `Select the school year`
  String get select_school_year {
    return Intl.message(
      'Select the school year',
      name: 'select_school_year',
      desc: '',
      args: [],
    );
  }

  /// `Please select a school year`
  String get select_school_year_prompt {
    return Intl.message(
      'Please select a school year',
      name: 'select_school_year_prompt',
      desc: '',
      args: [],
    );
  }

  /// `School Year`
  String get school_year {
    return Intl.message(
      'School Year',
      name: 'school_year',
      desc: '',
      args: [],
    );
  }

  /// `Semester`
  String get semester {
    return Intl.message(
      'Semester',
      name: 'semester',
      desc: '',
      args: [],
    );
  }

  /// `Please select a semester`
  String get select_semester_prompt {
    return Intl.message(
      'Please select a semester',
      name: 'select_semester_prompt',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
