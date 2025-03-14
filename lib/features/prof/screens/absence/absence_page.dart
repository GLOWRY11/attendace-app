import 'dart:async';

import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/prof/screens/absence/absence_success_page.dart';
import 'package:attendance_appschool/models/EtudianteItem.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';

class AbsencePage extends StatefulWidget {
  final String moduleName;
  final String subjectName;
  final int cid;
  final int filierid;
  final DateTime? selectedDate;
  final DateTime? startAbsenceDateTime;
  final String? selectedDuration;
  final String? selectedClass;
  final int idenseignants;
  const AbsencePage(
      {super.key,
      required this.moduleName,
      required this.subjectName,
      required this.cid,
      this.selectedDate,
      this.selectedDuration,
      this.selectedClass,
      this.startAbsenceDateTime,
        required this.filierid,
        required this.idenseignants
      });

  @override
  State<AbsencePage> createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  late DBHelper dbHelper;
  late List<EtudianteItem> studentItems = [];
  late DateTime _currentDateTime;
  bool _absenceSaved = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _timer = Timer.periodic(const Duration(seconds: 1),
        (Timer t) => _updateDateTime()); // Initialize the Timer
    dbHelper = DBHelper();
    loadStudentData();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer in the dispose method
    super.dispose();
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

  void _saveAbsenceData(DateTime endAbsenceDateTime) async {
    if (!_absenceSaved) {
      int presentCount =
          studentItems.where((student) => student.isPresent == true).length;
      int absentCount =
          studentItems.where((student) => student.isPresent != true).length;

      int attendanceHistoryId = await dbHelper.insertAttendanceHistory(
        classID: widget.cid,
        date: _currentDateTime.toIso8601String(),
        presentCount: presentCount,
        absentCount: absentCount,
        filierid: widget.filierid,
        enseignantId: widget.filierid
      );

      for (var student in studentItems) {
        // Insert absence data into the database
        await dbHelper.insertAbsence(
          etudiantId: student.getId,
          isPresent: student.isPresent == true ? 1 : 0,
          absenceDate: _currentDateTime,
          startTime: widget.startAbsenceDateTime!,
          endTime: endAbsenceDateTime,
          attendanceHistoryId: attendanceHistoryId,
        );
      }
      setState(() {
        _absenceSaved = true; // Mark absence data as saved
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AbsenceSuccessPage()),
      );
    }
  }

  void loadStudentData() async {
    List<Map<String, dynamic>>? students = await dbHelper.getEtudianteTable();
    print("Students found: $students");
    List<EtudianteItem> loadedEtudianteItems = [];

    for (var studentMap in students ?? []) {
      print(studentMap.containsKey(DBHelper.ETUDIANT_MASSAR_ID));
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
    });
      for (var student in studentItems) {
      print(
          "ID: ${student.getId}, Nom: ${student.getNom}, Filier: ${student.filierid}, Massar ID: ${student.getMassarId}");
    }
  }

  void _updateDateTime() {
    setState(() {
      _currentDateTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.chevron_left,
                size: 40,
                color: TColors.firstcolor,
              ),
            );
          }
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.moduleName,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enregistrement d'absence",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${_currentDateTime.day} ${_getMonthName(_currentDateTime.month)} ${_currentDateTime.year}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF788590),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  Text(
                    '${_currentDateTime.hour.toString().padLeft(2, '0')}:${_currentDateTime.minute.toString().padLeft(2, '0')}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: TColors.firstcolor,
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
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
                    height: 16,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Icon(
                              Icons.checklist,
                              color: Color(0xFF0C7C43),
                              size: 30,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Présent",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF0C7C43),
                              ),
                            )
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Icon(
                              Icons.checklist,
                              color: Color(0xFFF54135),
                              size: 30,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Absent sans justification",
                              style: TextStyle(
                                  color: Color(0xFFF54135),
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side:
                        const BorderSide(width: 1.5, color: Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16), // Adjust the height as needed
                  scrollDirection: Axis.vertical,
                  itemCount: studentItems.length,
                  itemBuilder: (context, index) {
                    final studentItem = studentItems[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (studentItems[index].isPresent == null) {
                            studentItems[index].isPresent = true;
                          } else if (studentItems[index].isPresent == true) {
                            studentItems[index].isPresent = false;
                          } else {
                            studentItems[index].isPresent = true;
                          }
                          studentItems[index].textColor = Colors.white;
                          studentItems[index].containerColor =
                              studentItems[index].isPresent == true
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.red.withOpacity(0.5);
                          studentItems[index].iconData =
                              studentItems[index].isPresent == true
                                  ? Icons.check_circle
                                  : Icons.cancel;
                          studentItems[index].iconColor =
                              studentItems[index].isPresent == true
                                  ? Colors.green
                                  : Colors.red;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 10),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: studentItems[index].containerColor,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1.5, color: Colors.grey),
                              borderRadius: BorderRadius.circular(9)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_2_rounded,
                                  size: 120,
                                  color: studentItems[index].iconColor,
                                ),
                                const SizedBox(width: 17),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      studentItem.nom,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: studentItems[index].textColor,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        height: 0,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Massar : ${studentItem.massarId}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: studentItems[index].textColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.normal,
                                        height: 0,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Filier : ${studentItem.id}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: studentItems[index].textColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.normal,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              studentItems[index].iconData,
                              size: 60,
                              color: studentItems[index].iconColor,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _handleEndAbsence();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF00A223),
                          disabledBackgroundColor: Colors.grey,
                          disabledForegroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9)),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.checklist_rtl,
                                size: 40,
                                color: TColors.white,
                              ),
                              SizedBox(width: 27),
                              Text(
                                "Enregistrement d'absence terminé",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 36,
                    ),
                    Text(
                      'Veuillez respecter la date du cour',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'janvier';
      case 2:
        return 'février';
      case 3:
        return 'mars';
      case 4:
        return 'avril';
      case 5:
        return 'mai';
      case 6:
        return 'juin';
      case 7:
        return 'juillet';
      case 8:
        return 'août';
      case 9:
        return 'septembre';
      case 10:
        return 'octobre';
      case 11:
        return 'novembre';
      case 12:
        return 'décembre';
      default:
        return '';
    }
  }

  void _handleEndAbsence() {
    for (var student in studentItems) {
      print('isPresent for ${student.getNom}: ${student.isPresent}');
    }
    bool allClicked =
        studentItems.every((student) => student.isPresent != null);
    print(allClicked);
    if (!allClicked) {
      showToast("L'enregistrement d'absence n'est pas complet.");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  9), // Apply border radius to the AlertDialog
            ),
            backgroundColor: Colors.white,
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 180,
                    color: TColors.firstcolor,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Voulez-vous vraiment enregistrer l'absence ?",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Annuler',
                  style: TextStyle(
                    color: TColors.firstcolor,
                    fontSize: 28,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _saveAbsenceData(DateTime.now());
                  Navigator.of(context).pop(); // Close the dialog
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
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Confirmer",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
