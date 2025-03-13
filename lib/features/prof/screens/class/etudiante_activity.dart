import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/prof/screens/absence/chose_system_absence.dart';
import 'package:attendance_appschool/models/EtudianteItem.dart';
import 'package:attendance_appschool/features/prof/screens/history/attendance_history_page.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../provider/AuthenticationProvider.dart';

class EtudianteActivity extends StatefulWidget {
  final String moduleName;
  final String subjectName;
  final int cid;

  const EtudianteActivity({
    super.key,
    required this.moduleName,
    required this.subjectName,
    required this.cid,
  });

  @override
  _EtudianteActivityState createState() => _EtudianteActivityState();
}

class _EtudianteActivityState extends State<EtudianteActivity> {
  late DBHelper dbHelper;
  late List<EtudianteItem> studentItems = [];
  DateTime? selectedDate = DateTime.now();
  String? selectedDuration = "Sélectionner la durée";
  String? selectedFiliere = "Sélectionner la filière";
  late TextEditingController nomController;
  late TextEditingController filierController;
  late TextEditingController massarIdController;
  late TextEditingController nomfilterController;
  List<String> filieres = ["Sélectionner la filière"];
  int? selectedFiliereId;
  List<EtudianteItem> filteredEtudiants = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadFilieres();
    nomController = TextEditingController();
    filierController = TextEditingController();
    massarIdController = TextEditingController();
    nomfilterController = TextEditingController();
  }
  void filterEtudiantsByNome(String query) {
    setState(() {
      filteredEtudiants = studentItems.where((student) =>
          student.nom.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void loadFilieres() async {
    List<Map<String, dynamic>> filieresFromDb = await dbHelper.getAllFiliers();
    List<String> loadedFilieres = ["Sélectionner la filière"];

    for (var filiereMap in filieresFromDb) {
      if (filiereMap.containsKey(DBHelper.FILIER_NAME) &&
          filiereMap.containsKey(DBHelper.SEMESTRE_NAME)) {
        String filiereName = filiereMap[DBHelper.FILIER_NAME] ?? '';
        String semestreName = filiereMap[DBHelper.SEMESTRE_NAME] ?? '';
        String fullName = '$filiereName - $semestreName';
        loadedFilieres.add(fullName);
      } else {
        print('Invalid filiere map: $filiereMap');
      }
    }

    setState(() {
      filieres = loadedFilieres;
    });
  }

  void loadStudentData({int? filiereId}) async {
    List<Map<String, dynamic>>? students =
        await dbHelper.getEtudianteTable(filiereId: filiereId);
    List<EtudianteItem> loadedEtudianteItems = [];

    for (var studentMap in students ?? []) {
      if (studentMap.containsKey(DBHelper.ETUDIANT_ID) &&
          studentMap.containsKey(DBHelper.ETUDIANT_NOM) &&
          studentMap.containsKey(DBHelper.ETUDIANT_PRENOM) &&
          studentMap.containsKey(DBHelper.ETUDIANT_SEXE) &&
          studentMap.containsKey(DBHelper.FILIER_ID) &&
          studentMap.containsKey(DBHelper.ETUDIANT_MASSAR_ID)) {
        int id = studentMap[DBHelper.ETUDIANT_ID] ?? 0;
        String nom = studentMap[DBHelper.ETUDIANT_NOM] ?? '';
        String prenom = studentMap[DBHelper.ETUDIANT_PRENOM] ?? '';
        int filierid = studentMap[DBHelper.FILIER_ID] ?? '';
        String massarId = studentMap[DBHelper.ETUDIANT_MASSAR_ID] ?? '';
        String? sexe = studentMap[DBHelper.ETUDIANT_SEXE] ?? '';
        String gmail = studentMap[DBHelper.ETUDIANT_GMAIL] ?? '';
        String phonenumber = studentMap[DBHelper.ETUDIANTE_PHONENUMBER] ?? '';
        String dateofbirth = studentMap[DBHelper.ETUDIANTE_PHONENUMBER] ?? '';
        loadedEtudianteItems.add(EtudianteItem(
          id: id,
          nom: nom,
          prenom: prenom,
          filierid: filierid,
          massarId: massarId,
          gender: sexe,
          email: gmail,
          phonenumber: phonenumber,
          dateofbirth: dateofbirth,
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
  Future<Map<String, String>> getFiliereDetails(int FilierId) async {
    final filiere = await dbHelper.getFiliereDetailsById(FilierId); // Assuming dbHelper is accessible
    return {
      'filier_name': filiere['filier_name'] ?? 'Unknown',
    };
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final Enseignantid =
        authProvider.authenticatedEnseignant?.id ?? 0;
    return Scaffold(
      backgroundColor: TColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
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
        title: SvgPicture.asset(
          'assets/logoestk_digital.svg',
          height: 50,
        ),
        backgroundColor: TColors.white,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: TColors.firstcolor,
              size: 40,
            ),
            onPressed: () {
              _openSheetList(widget.cid);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: ElevatedButton(
              onPressed: () {
                late DateTime startAbsenceDateTime = DateTime.now();

                if (selectedDate == null) {
                  showToast("Veuillez sélectionner une date.");
                } else if (selectedDuration == "Sélectionner la durée") {
                  showToast("Veuillez sélectionner une durée.");
                } else if (selectedFiliere == "Sélectionner la filière") {
                  showToast("Veuillez sélectionner une classe.");
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AbsenceChosePage(
                        moduleName: widget.moduleName,
                        subjectName: widget.subjectName,
                        cid: widget.cid,
                        filierid: selectedFiliereId!,
                        selectedDate: selectedDate,
                        selectedDuration: selectedDuration,
                        selectedClass: selectedFiliere,
                        startAbsenceDateTime: startAbsenceDateTime,
                        idenseignants: Enseignantid,
                      ),
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
                  fontWeight: FontWeight.w400,
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.arrow_right,
                    size: 40,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Lancer',
                    style: TextStyle(
                      color: TColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Détails de la Séance",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: TColors.firstcolor,
                          size: 40,
                        ),
                        onPressed: () async{
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
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Titre de la Séance",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          widget.moduleName,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                              ),
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
                          "Filière",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          iconSize: 40,
                          isExpanded: true,
                          iconEnabledColor: TColors.firstcolor,
                          value: selectedFiliere,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFiliere = newValue;
                              selectedFiliereId = filieres.indexOf(newValue!);
                              loadStudentData(filiereId: selectedFiliereId);
                            });
                          },
                          items: filieres
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
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
                          "Date de la Séance ",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          selectedDate != null
                              ? "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}"
                              : "Not selected",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.normal,
                          ),
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
                          "Durée de la leçon",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          iconSize: 40,
                          isExpanded: true,
                          iconEnabledColor: TColors.firstcolor,
                          value: selectedDuration,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDuration = newValue;
                            });
                          },
                          items: const [
                            DropdownMenuItem<String>(
                              value: "Sélectionner la durée",
                              child: Text('Sélectionner la durée',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.normal,
                                     )),
                            ),
                            DropdownMenuItem<String>(
                              value: "08:00-10:00",
                              child: Text('08:00-10:00',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.normal,
                                      )),
                            ),
                            DropdownMenuItem<String>(
                              value: "10:00-12:00",
                              child: Text('10:00-12:00',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.normal,
                                      )),
                            ),
                            DropdownMenuItem<String>(
                              value: "14:00-16:00",
                              child: Text('14:00-16:00',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.normal,
                                  )),
                            ),
                            DropdownMenuItem<String>(
                              value: "16:00-18:00",
                              child: Text('16:00-18:00',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.normal,
                                      )),
                            ),
                            // Add more time ranges as needed
                          ],
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
                          "Contenu de la Séance",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          widget.subjectName,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "La liste des étudiants",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
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
              SizedBox(
                height:1000,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  width: double.infinity,
                  child: selectedFiliere == "Sélectionner la filière"
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/Search-rafiki 1.png', // Replace 'your_image.png' with the path to your image asset
                                width: 250,
                                height: 250,
                                // Adjust width and height as needed
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Aucun choix sélectionné ',
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
                                'Veuillez sélectionner une option',
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
                            return FutureBuilder<Map<String, String>>(
                              future: getFiliereDetails(filteredEtudiants[index].filierid),
                              builder: (context, snapshot) {
                                final studentItem = filteredEtudiants[index];
                                final filiereDetails = snapshot.data ?? {'filier_name': 'Unknown'};
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
                                            color: Color(0xFFA5A9AC),
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
                                                  height: 0,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Filière : ${filiereDetails['filier_name']}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 25,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _openSheetList(int cid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceHistoryPageParseance(cid: cid),
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
}

