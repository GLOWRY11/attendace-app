import 'dart:async';
import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/prof/screens/absence/absence_success_page.dart';
import 'package:attendance_appschool/models/EtudianteItem.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:typed_data';
import 'package:mobile_scanner/mobile_scanner.dart';

class AbsenceQrCodePage extends StatefulWidget {
  final String moduleName;
  final String subjectName;
  final int cid;
  final int filierid;

  final DateTime? selectedDate;
  final DateTime? startAbsenceDateTime;
  final String? selectedDuration;
  final String? selectedClass;
  final int idenseignants;
  const AbsenceQrCodePage(
      {super.key,
      required this.moduleName,
      required this.subjectName,
      required this.cid,
      this.selectedDate,
      this.selectedDuration,
      this.selectedClass,
      this.startAbsenceDateTime,
        required this.idenseignants,

        required this.filierid});

  @override
  State<AbsenceQrCodePage> createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsenceQrCodePage> {
  late MobileScannerController scannerController;
  late DBHelper dbHelper;
  late List<EtudianteItem> studentItems = [];
  late DateTime _currentDateTime;
  bool _absenceSaved = false;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateDateTime());
    dbHelper = DBHelper();
    loadStudentData();
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
          enseignantId: widget.idenseignants
      );

      for (var student in studentItems) {
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
          studentMap.containsKey(DBHelper.FILIER_ID) &&
          studentMap.containsKey(DBHelper.ETUDIANT_SEXE) &&
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
            email:gmail,
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
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/logoestk_digital.svg',
          height: 50,
        ),
        backgroundColor: TColors.white,

      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 36,
            ),
            const Text(
              "Placez le code QR dans la zone pour scanner votre présence",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 36),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1.5, color: Color(0xFFA5A9AC)),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              child: MobileScanner(
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                  returnImage: true,
                ),
                onDetect: _onDetect,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
    );
  }
  void _markAbsentStudents() {
    for (var student in studentItems) {
      if (student.isPresent == null) {
        setState(() {
          student.isPresent = false;
          student.containerColor = Colors.red.withOpacity(0.5);
          student.iconData = Icons.cancel;
          student.iconColor = Colors.red;
        });
      }
    }
  }
  void _handleEndAbsence() {
    for (var student in studentItems) {
      print('isPresent for ${student.getNom}: ${student.isPresent}');
    }

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
                  _markAbsentStudents();
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

  void _onDetect(BarcodeCapture capturedData) {
    for (var barcode in capturedData.barcodes) {
      final String scannedData = barcode.rawValue ??
          '';
      _handleScannedData(scannedData);
    }

    final Uint8List? capturedImage = capturedData.image;

    if (capturedImage != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Données scannées"),
            content: Image.memory(capturedImage),
          );
        },
      );
    }
  }

  void _handleScannedData(String scannedData) {
    bool dataMatched = false;

    for (var student in studentItems) {
      if (student.massarId == scannedData) {
        setState(() {
          student.isPresent = true;
          student.containerColor = Colors.green.withOpacity(0.5);
          student.iconData = Icons.check_circle;
          student.iconColor = Colors.green;
        });
        dataMatched = true;
        break;
      }
    }

    if (!dataMatched) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Étudiant non trouvé'),
            content: Text("Les données scannées ne correspondent à aucun étudiant"),
          );
        },
      );
    }
  }
}
