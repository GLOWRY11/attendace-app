import 'package:attendance_appschool/features/admin/details/student_details.dart';
import 'package:attendance_appschool/features/admin/history/attendance_history_page_filier.dart';
import 'package:attendance_appschool/models/EtudianteItem.dart';
import 'package:attendance_appschool/models/FiliereItem.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/sqflite/DBHelper.dart';
import '../../../generated/l10n.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key, required this.filiereItem});
  final FiliereItem filiereItem;

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final _formKey = GlobalKey<FormState>();

  late DBHelper dbHelper;
  late List<EtudianteItem> studentItems = [];
  late TextEditingController nomController;
  late TextEditingController nomfilterController;
  late TextEditingController phonenumberController;
  String? selectedSexe = "Sélectionner le sexe";
  late TextEditingController prenomController;
  late TextEditingController gmailController;
  late TextEditingController massarIdController;
  late TextEditingController dateController ;

  List<EtudianteItem> filteredEtudiants = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadStudentData(widget.filiereItem.id);
    nomController = TextEditingController();
    massarIdController = TextEditingController();
    prenomController = TextEditingController();
    nomfilterController = TextEditingController();
    phonenumberController = TextEditingController();
    gmailController = TextEditingController();
    dateController = TextEditingController();
  }

  void filterEtudiantsByNome(String query) {
    setState(() {
      filteredEtudiants = studentItems.where((student) =>
          student.nom.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void loadStudentData(int filierId) async {
    List<Map<String, dynamic>>? students =
        await dbHelper.getStudentsByFilier(filierId);
    List<EtudianteItem> loadedEtudianteItems = [];

    for (var studentMap in students) {
      if (studentMap.containsKey(DBHelper.ETUDIANT_ID) &&
          studentMap.containsKey(DBHelper.ETUDIANT_NOM) &&
          studentMap.containsKey(DBHelper.ETUDIANT_PRENOM) &&
          studentMap.containsKey(DBHelper.ETUDIANT_SEXE) &&
          studentMap.containsKey(DBHelper.FILIER_ID) &&
          studentMap.containsKey(DBHelper.ETUDIANT_MASSAR_ID)) {
        int id = studentMap[DBHelper.ETUDIANT_ID] ?? 0;
        String nom = studentMap[DBHelper.ETUDIANT_NOM] ?? '';
        String prenom = studentMap[DBHelper.ETUDIANT_PRENOM] ?? '';
        String? sexe = studentMap[DBHelper.ETUDIANT_SEXE] ?? '';
        int filier = studentMap[DBHelper.FILIER_ID] ?? '';
        String massarId = studentMap[DBHelper.ETUDIANT_MASSAR_ID] ?? '';
        String gmail = studentMap[DBHelper.ETUDIANT_GMAIL] ?? '';
        String phonenumber = studentMap[DBHelper.ETUDIANTE_PHONENUMBER] ?? '';
        String dateofbirth = studentMap[DBHelper.ETUDIANTE_PHONENUMBER] ?? '';
        loadedEtudianteItems.add(EtudianteItem(
          id: id,
          nom: nom,
          prenom: prenom,
          filierid: filier,
          massarId: massarId,
          gender: sexe,
          email: gmail,
          phonenumber: phonenumber,
          dateofbirth: dateofbirth
        ));
      } else {
        print('Invalid student map: $studentMap');
      }
    }
    setState(() {
      studentItems = loadedEtudianteItems;
      filteredEtudiants= studentItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/logoestm_digital.svg',
          height: 50,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: TColors.firstcolor,
              size: 40,
            ),
            onPressed: () {
              _openSheetList(widget.filiereItem.id);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Détails de la filière",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _showAddStudentDialog();
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        backgroundColor:
                        WidgetStateProperty.all<Color>(TColors.firstcolor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.person_add,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            'Ajoutée',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontFamily: 'Sarala',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Titre de la filière",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          widget.filiereItem.filier_name,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                              color: TColors.firstcolor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Semestre",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          widget.filiereItem.semestre_name.toString(),
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                              color: TColors.firstcolor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Année scolaire",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          widget.filiereItem.filier_annee.toString(),
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                              color: TColors.firstcolor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total des étudiants",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          studentItems.length.toString(),
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                              color: TColors.firstcolor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 26,
              ),
              Row(
                children: [
                  const Text(
                    'La liste des Étudiants',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontFamily: 'Sarala',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: nomfilterController,
                      onChanged: (value) {
                        filterEtudiantsByNome(value);
                      },
                      decoration: InputDecoration(
                        focusColor:TColors.firstcolor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:const BorderSide(width: 1, color: TColors.firstcolor),  // Focused border color
                        ),
                        hoverColor: TColors.firstcolor,
                        hintText: 'Rechercher par nom de famille...',
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
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        width: 1.5, color: Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                width: double.infinity,
                height: 1000,
                child: studentItems.isEmpty
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/Search-rafiki 1.png', // Replace 'your_image.png' with the path to your image asset
                              width: MediaQuery.of(context).size.width / 3,
                              fit: BoxFit.fill,
                              // Adjust width and height as needed
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Aucun étudiant",
                              textAlign: TextAlign.center,
                              style: TextStyle(
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
                            const Text(
                              "Veuillez ajouter un étudiante",
                              textAlign: TextAlign.center,
                              style: TextStyle(
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
                        itemCount: filteredEtudiants.length,
                        itemBuilder: (context, index) {
                          final studentItem = filteredEtudiants[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFFA5A9AC)),
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
                                          "${studentItem.nom} ${studentItem.prenom}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            height: 0,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Massar : ${studentItem.massarId}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 25,
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
                                                ShowStudentDetails(
                                                  studentid: studentItem.id,
                                                  nom: studentItem.nom,
                                                  prenom: studentItem.prenom,
                                                  massar: studentItem.massarId,
                                                  email: studentItem.email,
                                                  gender: studentItem.gender,
                                                  phonenuber: studentItem.phonenumber,
                                                  dateofbirth: studentItem.dateofbirth,
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
                                        _showDeleteConfirmationDialog(studentItem.id);
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        size: 50,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          )),
    );
  }

  void _showAddStudentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                9), // Apply border radius to the AlertDialog
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Ajouter un élève",
            style: TextStyle(
              color: TColors.firstcolor,
              fontSize: 25,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
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
                        return 'Veuillez fournir un nom';
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
                      labelText: 'Prénom',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez fournir un prénom';
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
                        return 'Veuillez fournir un Massar';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: const TextStyle(fontSize: 24),
                    controller: gmailController,
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
                        return 'Veuillez fournir un Email';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: const TextStyle(fontSize: 24),
                    controller: massarIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
                      labelText: S.of(context).massar,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez fournir un Massar';
                      }
                      if (!RegExp(r'^[A-Za-z]').hasMatch(value)) {
                        return 'Le Massar doit commencer par un caractère';
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
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
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
                                fontWeight: FontWeight.normal,)),
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
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nomController.text.isNotEmpty &&
                    massarIdController.text.isNotEmpty &&
                    prenomController.text.isNotEmpty &&
                    gmailController.text.isNotEmpty &&
                    phonenumberController.text.isNotEmpty &&
                    dateController.text.isNotEmpty &&
                    selectedSexe != "Sélectionner le sexe") {
                  addStudent(nomController.text, prenomController.text,
                      massarIdController.text, selectedSexe,gmailController.text,phonenumberController.text,dateController.text);
                  Navigator.pop(context);
                  nomController.clear();
                  massarIdController.clear();
                  prenomController.clear();
                  gmailController.clear();
                  phonenumberController.clear();
                  dateController.clear();
                  setState(() {
                    selectedSexe = "Sélectionner le sexe";
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Veuillez remplir tous les champs'),
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
                    borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              child: Text(
                S.of(context).ajoutee,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void addStudent(
      String nom, String prenom, String massarId, String? gender,String gmail,String phonenumber,String dateofbirth) async {
    if (nom.isNotEmpty && prenom.isNotEmpty && massarId.isNotEmpty) {
      int? sid = await dbHelper.addEtudiant(
          nom, prenom, widget.filiereItem.id, massarId, gender,gmail,phonenumber,dateofbirth);
      EtudianteItem etudianteItem = EtudianteItem(
          id: sid!,
          prenom: prenom,
          filierid: widget.filiereItem.id,
          nom: nom,
          massarId: massarId,
          gender: gender,
      email: gmail,
        phonenumber: phonenumber,
        dateofbirth: dateofbirth
      );
      setState(() {
        studentItems.add(etudianteItem);
      });
    } else {
      showToast("Veuillez entrer les noms de la classe et de la matière");
    }
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

  void _showDeleteConfirmationDialog(int studentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                12), // Apply border radius to the AlertDialog
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Supprimer l'élève",
            style: TextStyle(
              color: TColors.firstcolor,
              fontSize: 28,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: const Text(
            "Êtes-vous sûr de vouloir supprimer cet élève ?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Annuler',
                style: TextStyle(
                  color: TColors.firstcolor,
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                removeStudent(studentId);
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
              child: const Text(
                'Supprimer',
                style: TextStyle(
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

  void removeStudent(int studentId) async {
    setState(() {
      studentItems.removeWhere((student) => student.id == studentId);
    });
    await dbHelper.deleteEtudiant(studentId);
  }

  void _openSheetList(int filierid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceHistoryFilierPage(filierid: filierid),
      ),
    );
  }
}
