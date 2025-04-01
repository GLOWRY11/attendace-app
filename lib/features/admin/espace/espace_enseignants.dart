import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/admin/details/enseignants_details.dart';
import 'package:attendance_appschool/features/admin/notificaton/notification_page.dart';
import 'package:attendance_appschool/features/admin/widgets/app_drawer.dart';
import 'package:attendance_appschool/features/admin/widgets/notification_icon.dart';
import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/models/EnseignantItem.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';

class EspaceEnsgeint extends StatefulWidget {
  const EspaceEnsgeint({super.key});

  @override
  State<EspaceEnsgeint> createState() => _EspaceEnsgeintState();
}

class _EspaceEnsgeintState extends State<EspaceEnsgeint> {
  final _formKey = GlobalKey<FormState>();
  late DBHelper dbHelper;
  late List<EnseignantItem> enseignantItems = [];
  String? selectedSexe = "Sélectionner le sexe";
  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController emailController;
  late TextEditingController cinController;
  late TextEditingController phonenumberController;
  late TextEditingController carteNatioController;
  List<EnseignantItem> filteredEnseignants = [];
  late TextEditingController dateController ;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadEnseignantsData();
    nomController = TextEditingController();
    prenomController = TextEditingController();
    emailController = TextEditingController();
    cinController = TextEditingController();
    carteNatioController = TextEditingController();
    phonenumberController = TextEditingController();
    dateController = TextEditingController();
  }



  void loadEnseignantsData() async {
    List<Map<String, dynamic>>? enseignants =
        await dbHelper.getAllEnseignantTable();
    List<EnseignantItem> loadedEnseignantsItems = [];

    for (var enseignantMap in enseignants!) {
      if (enseignantMap.containsKey(DBHelper.ENSEIGNANT_ID) &&
          enseignantMap.containsKey(DBHelper.ENSEIGNANT_NOM) &&
          enseignantMap.containsKey(DBHelper.ENSEIGNANT_CIN) &&
          enseignantMap.containsKey(DBHelper.ENSEIGNANT_PRENOM) &&
          enseignantMap.containsKey(DBHelper.ENSEIGNANT_SEXE) &&
          enseignantMap.containsKey(DBHelper.ENSEIGNANT_EMAIL)) {
        int id = enseignantMap[DBHelper.ENSEIGNANT_ID] ?? 0;
        String nom = enseignantMap[DBHelper.ENSEIGNANT_NOM] ?? '';
        String prenom = enseignantMap[DBHelper.ENSEIGNANT_PRENOM] ?? '';
        String gender = enseignantMap[DBHelper.ENSEIGNANT_SEXE] ?? '';
        String cin = enseignantMap[DBHelper.ENSEIGNANT_CIN] ?? '';
        String email = enseignantMap[DBHelper.ENSEIGNANT_EMAIL] ?? '';
        String  phonenumber = enseignantMap[DBHelper.ENSEIGNANT_PHONENUMBER] ?? '';
        String dateofbirth = enseignantMap[DBHelper.ENSEIGNANT_DATE] ?? '';

        loadedEnseignantsItems.add(EnseignantItem(
            id: id,
            nom: nom,
            prenom: prenom,
            gender: gender,
            cin: cin,
            email: email,
        phonenumber: phonenumber,
        dateofbirth: dateofbirth
        ));
      } else {
        print('Invalid student map: $enseignantMap');
      }
    }
    setState(() {
      enseignantItems = loadedEnseignantsItems;
      filteredEnseignants = enseignantItems;
    });
    }
  void filterEnseignantsByCarteNationale(String query) {
    setState(() {
      filteredEnseignants = enseignantItems.where((enseignant) =>
          enseignant.cin.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: TColors.white,
      appBar: AppBar(
        actions: [
          TNotificationIcon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreenFonction()
                  ));
            },
          )
        ],
        title: SvgPicture.asset(
          'assets/logoestm_digital.svg',
          height: 50,
        ),
        backgroundColor: TColors.white,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              color: TColors.firstcolor,
              size: 45,
            ), // Change the icon here
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 26,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).espace_enseignants,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontFamily: 'Sarala',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _showAddEnseignantsDialog();
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        backgroundColor:
                            WidgetStateProperty.all<Color>(TColors.firstcolor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_add,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            S.of(context).ajoutee,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontFamily: 'Sarala',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(5),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0x4CFCA129),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: const Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.group_outlined,
                                    color: TColors.firstcolor,
                                    size: 40,
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(width: 16),
                        Text(
                          S.of(context).total_enseignants,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 28,
                            fontFamily: 'Sarala',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      enseignantItems.length.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 70,
                        fontFamily: 'Sarala',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 26,
              ),
              Row(
                children: [
                  Text(
                    S.of(context).teacher_list,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),

                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: carteNatioController,
                      onChanged: (value) {
                        filterEnseignantsByCarteNationale(value);
                      },
                      decoration: InputDecoration(
                        focusColor:TColors.firstcolor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:const BorderSide(width: 1, color: TColors.firstcolor),  // Focused border color
                        ),
                        hoverColor: TColors.firstcolor,
                        hintText: 'Rechercher par cin...',
                        prefixIcon:const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(width: 1, color:Color(0xFFA5A9AC),
                        ),
                      ),
                    ),
                  ),
                  )
                ],
                  ),
              const SizedBox(
                height: 26,
              ),
              Container(
                width: double.infinity,
                height: 1000,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color:Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: filteredEnseignants.isEmpty
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/Hidden mining-rafiki.png',
                              width: MediaQuery.of(context).size.width / 2,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              S.of(context).no_teacher,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 26,
                                fontFamily: 'Sarala',
                                fontWeight: FontWeight.normal,
                                height: 0,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              S.of(context).add_teacher_prompt,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 26,
                                fontFamily: 'Sarala',
                                fontWeight: FontWeight.normal,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const SizedBox(
                            height: 16), // Adjust the height as needed
                        scrollDirection: Axis.vertical,
                        itemCount: filteredEnseignants.length,
                        itemBuilder: (context, index) {
                          final enseignantItem = filteredEnseignants[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color:Color(0xFFA5A9AC)),
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_2_rounded,
                                      size: 120,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 17),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${enseignantItem.nom} ${enseignantItem.prenom}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          S.of(context).national_card_of(
                                              enseignantItem.cin),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ShowEnseignantDetails(
                                              enseignantid: enseignantItem.id,
                                              nom: enseignantItem.nom,
                                              prenom: enseignantItem.prenom,
                                              cin: enseignantItem.cin,
                                              email: enseignantItem.email,
                                              gender: enseignantItem.gender,
                                                  phonenumberl: enseignantItem.phonenumber,
                                                  dateofbirth: enseignantItem.dateofbirth,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.info_outline,
                                        size: 50,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                            enseignantItem.id);
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        size: 50,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEnseignantsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                12),
          ),
          backgroundColor: Colors.white,
          title: Text(
            S.of(context).ajoutee,
            style: const TextStyle(
              color: TColors.firstcolor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    style: const TextStyle(fontSize: 24),
                    controller: nomController,
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
                      errorMaxLines: 3,
                      hintStyle: const TextStyle()
                          .copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      prefixIcon: const Icon(Icons.group),
                      labelText: 'Nom',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).veuillez_fournir_un_nom;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: const TextStyle(fontSize: 24),
                    controller: prenomController,
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
                      errorMaxLines: 3,
                      hintStyle: const TextStyle()
                          .copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      prefixIcon: const Icon(Icons.person_3),
                      labelText: S.of(context).prenom,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).veuillez_fournir_un_prenom;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: const TextStyle(fontSize: 24),
                    controller: cinController,
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
                      errorMaxLines: 3,
                      hintStyle: const TextStyle()
                          .copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      prefixIcon: const Icon(Icons.perm_identity),
                      labelText: S.of(context).national_card,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).veuillez_fournir_un_cin;
                      }
                      if (!RegExp(r'^[A-Za-z]').hasMatch(value)) {
                        return S.of(context).id_card_error;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: dateController,
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
                      errorMaxLines: 3,
                      hintStyle: const TextStyle()
                          .copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      labelText: 'Date (YYYY-MM-DD)',
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: TColors.firstcolor, // Color of the date picker header
                                    onPrimary: Colors.white, // Text color of the date picker header
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedDate != null) {
                            dateController.text = pickedDate.toString().substring(0, 10); // Format the picked date
                          }
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez choisir une date';
                      }
                      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                        return 'Format de date invalide (YYYY-MM-DD)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: const TextStyle(fontSize: 24),
                    controller: emailController,
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
                      errorMaxLines: 3,
                      hintStyle: const TextStyle()
                          .copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      prefixIcon: const Icon(Icons.email),
                      labelText: S.of(context).email,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).email_prompt;
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return S.of(context).email_invalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: const TextStyle(fontSize: 24),
                    controller: phonenumberController,
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
                      errorMaxLines: 3,
                      hintStyle: const TextStyle()
                          .copyWith(fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      prefixIcon: const Icon(Icons.phone),
                      labelText:"Numéro de téléphone",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Numéro de téléphone";
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return S.of(context).email_invalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: TColors.firstcolor),
                      ),
                    ),
                    iconSize: 40,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    iconEnabledColor: TColors.firstcolor,
                    value: selectedSexe,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSexe = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(

                        value: "Sélectionner le sexe",
                        child: Text('Sélectionner le sexe',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.normal,
                            )),
                      ),
                      DropdownMenuItem<String>(
                        value: "Femme-امرأة",
                        child: Text('Femme-امرأة',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.normal,
                  )),
                      ),
                      DropdownMenuItem<String>(
                        value: "Homme-رجل",
                        child: Text('Homme-رجل',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.normal,
                            )),
                      ),
                    ],
                    validator: (value) {
                      if (value == "Sélectionner le sexe") {
                        return S.of(context).select_gender;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                S.of(context).cancel,
                style: const TextStyle(
                  color: TColors.firstcolor,
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nomController.text.isNotEmpty &&
                    prenomController.text.isNotEmpty &&
                    cinController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    phonenumberController.text.isNotEmpty &&
                    dateController.text.isNotEmpty &&
                    selectedSexe != "Sélectionner le sexe") {
                  addEnseignant(nomController.text, prenomController.text,
                      cinController.text, emailController.text, selectedSexe,phonenumberController.text,dateController.text);
                  Navigator.pop(context);
                  nomController.clear();
                  prenomController.clear();
                  cinController.clear();
                  emailController.clear();
                  phonenumberController.clear();
                  dateController.clear();
                  setState(() {
                    selectedSexe = "Sélectionner le sexe";
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(S.of(context).fill_all_fields),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: TColors.firstcolor,
                disabledBackgroundColor: Colors.grey,
                disabledForegroundColor: Colors.grey,
                side: const BorderSide(color: TColors.firstcolor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              child: Text(
                S.of(context).ajoutee,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void addEnseignant(String nom, String prenom, String cin, String email, String? sexe,String phonenumber,String dateofbirth) async {
    if (nom.isNotEmpty &&
        prenom.isNotEmpty &&
        cin.isNotEmpty &&
        email.isNotEmpty &&
        phonenumber.isNotEmpty &&
        dateofbirth.isNotEmpty &&
        sexe != "Sélectionner le sexe") {
      String motDePasse = generateRandomPassword(12);
      int? id = await dbHelper.addEnseignant(
          nom, prenom, cin, email, motDePasse, sexe,phonenumber,dateofbirth);
      EnseignantItem enseignantItem = EnseignantItem(
          id: id ?? 0,
          cin: cin,
          nom: nom,
          prenom: prenom,
          gender: sexe,
          email: email,
          phonenumber: phonenumber,
        dateofbirth: dateofbirth
      );
      setState(() {
        enseignantItems.add(enseignantItem);
      });
    } else {
      showToast(S.of(context).fill_all_fields);
    }
  }


  void _showDeleteConfirmationDialog(int studentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                9),
          ),
          backgroundColor: Colors.white,
          title: Text(
            S.of(context).delete_teacher,
            style: const TextStyle(
              color: TColors.firstcolor,
              fontSize: 28,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(
            S.of(context).confirm_delete_teacher,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                S.of(context).cancel,
                style: const TextStyle(
                  color: TColors.firstcolor,
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                removeEnseignant(studentId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: TColors.firstcolor,
                disabledBackgroundColor: Colors.grey,
                disabledForegroundColor: Colors.grey,
                side: const BorderSide(color: TColors.firstcolor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              child: Text(
                S.of(context).delete,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String generateRandomPassword(int length) {
    const String letters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%^&*()-_=+[]{}|;:",.<>?/`~';
    const String chars = '$letters$numbers$symbols';
    final Random rnd = Random();

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 28,
          ),
        )));
  }

  void removeEnseignant(int enseignantId) async {
    setState(() {
      enseignantItems
          .removeWhere((enseignant) => enseignant.id == enseignantId);
    });
    await dbHelper.deleteEnseignant(enseignantId);
  }
}
