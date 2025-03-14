// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  static String m0(major) => "Filière: ${major}";

  static String m1(massar) => "Massar: ${massar}";

  static String m2(nationalCard) =>
      "Carte nationale d identité : ${nationalCard}";

  static String m3(schoolYear) => "Année scolaire : ${schoolYear}";

  static String m4(semester) => "Semestre : ${semester}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_major":
            MessageLookupByLibrary.simpleMessage("Ajouter une filière"),
        "add_major_prompt": MessageLookupByLibrary.simpleMessage(
            "Veuillez ajouter une filière"),
        "add_student_prompt": MessageLookupByLibrary.simpleMessage(
            "Veuillez ajouter un étudiant"),
        "add_teacher_prompt": MessageLookupByLibrary.simpleMessage(
            "Veuillez ajouter un enseignant"),
        "ajoutee": MessageLookupByLibrary.simpleMessage("Ajouter"),
        "bienvenue": MessageLookupByLibrary.simpleMessage("Bienvenue !"),
        "bienvenue_dans_l_espace_enseignant":
            MessageLookupByLibrary.simpleMessage(
                "Bienvenue dans l espace Enseignant"),
        "bienvenue_dans_l_espace_fonctionnaire":
            MessageLookupByLibrary.simpleMessage(
                "Bienvenue dans l espace Fonctionnaire"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "confirm_delete_teacher": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous sûr de vouloir supprimer cet enseignant ?"),
        "connectez_vous_maintenant":
            MessageLookupByLibrary.simpleMessage("Connectez-vous maintenant"),
        "connexion": MessageLookupByLibrary.simpleMessage("Connexion"),
        "contactAdministrator": MessageLookupByLibrary.simpleMessage(
            "Contactez l administrateur pour obtenir vos identifiants."),
        "date_of_birth":
            MessageLookupByLibrary.simpleMessage("Date de naissance"),
        "delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "delete_teacher":
            MessageLookupByLibrary.simpleMessage("Supprimer l enseignant"),
        "email": MessageLookupByLibrary.simpleMessage("E-mail"),
        "email_invalid": MessageLookupByLibrary.simpleMessage(
            "Veuillez fournir une adresse e-mail valide"),
        "email_prompt": MessageLookupByLibrary.simpleMessage(
            "Veuillez fournir une adresse e-mail"),
        "enseignant": MessageLookupByLibrary.simpleMessage("Enseignant"),
        "espace_enseignants":
            MessageLookupByLibrary.simpleMessage("Espace Enseignants"),
        "fill_all_fields": MessageLookupByLibrary.simpleMessage(
            "Veuillez remplir tous les champs"),
        "fonctionnaire": MessageLookupByLibrary.simpleMessage("Fonctionnaire"),
        "gender": MessageLookupByLibrary.simpleMessage("Genre"),
        "home": MessageLookupByLibrary.simpleMessage("Accueil"),
        "id_card_error": MessageLookupByLibrary.simpleMessage(
            "La carte nationale d identité doit commencer par un caractère"),
        "identifiants_invalides": MessageLookupByLibrary.simpleMessage(
            "Identifiants invalides. Veuillez réessayer."),
        "le_mot_de_passe_doit_comporter_au_moins_4_caracteres":
            MessageLookupByLibrary.simpleMessage(
                "Le mot de passe doit comporter au moins 4 caractères"),
        "logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
        "major": MessageLookupByLibrary.simpleMessage("Filière"),
        "major_name": MessageLookupByLibrary.simpleMessage("Nom de la filière"),
        "major_name_prompt": MessageLookupByLibrary.simpleMessage(
            "Veuillez fournir un nom de la filière"),
        "major_of": m0,
        "major_space": MessageLookupByLibrary.simpleMessage("Espace Filières"),
        "massar": MessageLookupByLibrary.simpleMessage("Massar"),
        "massar_of": m1,
        "module_management_space": MessageLookupByLibrary.simpleMessage(
            "Espace de Gestion des Modules et des Éléments"),
        "mot_de_passe": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "national_card":
            MessageLookupByLibrary.simpleMessage("Carte nationale d identité"),
        "national_card_of": m2,
        "no_major": MessageLookupByLibrary.simpleMessage("Aucun filière"),
        "no_students": MessageLookupByLibrary.simpleMessage("Aucun étudiant"),
        "no_teacher": MessageLookupByLibrary.simpleMessage("Aucun enseignant"),
        "prenom": MessageLookupByLibrary.simpleMessage("Prénom"),
        "profile_space": MessageLookupByLibrary.simpleMessage("Espace Profil"),
        "ready_to_start":
            MessageLookupByLibrary.simpleMessage("Prêt à débuter ?"),
        "realisation_par": MessageLookupByLibrary.simpleMessage(
            "Réalisation par Abderrahmane Chaoui\nOmar Chouhani"),
        "school_year": MessageLookupByLibrary.simpleMessage("Année scolaire"),
        "school_year_of": m3,
        "select_gender": MessageLookupByLibrary.simpleMessage(
            "Veuillez sélectionner un sexe"),
        "select_school_year": MessageLookupByLibrary.simpleMessage(
            "Sélectionner l\'\'année scolaire"),
        "select_school_year_prompt": MessageLookupByLibrary.simpleMessage(
            "Veuillez sélectionner une année scolaire"),
        "select_semester":
            MessageLookupByLibrary.simpleMessage("Sélectionner le semestre"),
        "select_semester_prompt": MessageLookupByLibrary.simpleMessage(
            "Veuillez sélectionner un semestre"),
        "selectionnez_une_option_ci_dessous_pour_commencer":
            MessageLookupByLibrary.simpleMessage(
                "Sélectionnez une option ci-dessous pour commencer"),
        "semester": MessageLookupByLibrary.simpleMessage("Semestre"),
        "semester_of": m4,
        "student_list":
            MessageLookupByLibrary.simpleMessage("La liste des Étudiants"),
        "student_space":
            MessageLookupByLibrary.simpleMessage("Espace Étudiants"),
        "teacher_list":
            MessageLookupByLibrary.simpleMessage("La liste des enseignantes"),
        "total_enseignants":
            MessageLookupByLibrary.simpleMessage("Total des enseignants"),
        "veuillez_fournir_un_cin": MessageLookupByLibrary.simpleMessage(
            "Veuillez fournir la carte nationale d\'\'identité"),
        "veuillez_fournir_un_mot_de_passe":
            MessageLookupByLibrary.simpleMessage(
                "Veuillez fournir un mot de passe"),
        "veuillez_fournir_un_nom":
            MessageLookupByLibrary.simpleMessage("Veuillez fournir un nom"),
        "veuillez_fournir_un_prenom":
            MessageLookupByLibrary.simpleMessage("Veuillez fournir un prénom"),
        "veuillez_fournir_une_adresse_email":
            MessageLookupByLibrary.simpleMessage(
                "Veuillez fournir une adresse e-mail")
      };
}
