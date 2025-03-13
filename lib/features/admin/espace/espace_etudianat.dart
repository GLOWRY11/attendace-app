import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/models/EtudianteItem.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../data/sqflite/DBHelper.dart';

class EspaceEtudiante extends StatefulWidget {
  const EspaceEtudiante({super.key});

  @override
  State<EspaceEtudiante> createState() => _EspaceEtudianteState();
}

class _EspaceEtudianteState extends State<EspaceEtudiante> {
  late DBHelper dbHelper;
  late List<EtudianteItem> studentItems = [];
  String? selectedSexe = "Sélectionner le sexe";
  String? selectedFiliere = "Toutes les filières";
  late TextEditingController massarIdController;
  late TextEditingController nomController;
  late TextEditingController prenomController;
  List<String> filieres = ["Toutes les filières"];
  int? selectedFiliereId;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    nomController = TextEditingController();
    massarIdController = TextEditingController();
    prenomController = TextEditingController();
    loadStudentData();
    loadFilieres();
  }

  void loadFilieres() async {
    List<Map<String, dynamic>> filieresFromDb = await dbHelper.getAllFiliers();
    List<String> loadedFilieres = ["Toutes les filières"];
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
      List<Map<String, dynamic>>? students;

      if (filiereId != null) {
        students = await dbHelper.getEtudianteTable(filiereId: filiereId);
      } else {
        students = await dbHelper.getALLEtudianteTable(); // Assuming this method fetches all students
      }

      if (students != null) {
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
            int filierid = studentMap[DBHelper.FILIER_ID] ?? 0;
            String massarId = studentMap[DBHelper.ETUDIANT_MASSAR_ID] ?? '';
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
      } else {
        print('No students found.');
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: TColors.white,
      appBar: AppBar(
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:const Icon(
            Icons.chevron_left,size: 40,color: TColors.firstcolor,
          ),),
        backgroundColor: TColors.white,
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/logoestk_digital.svg',
          height: 50,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  S.of(context).student_space,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontFamily: 'Sarala',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 36,
                ),
                Expanded(
                  child: DropdownButton<String>(
                    iconSize: 40,
                    isExpanded: true,
                    iconEnabledColor: TColors.firstcolor,
                    dropdownColor: Colors.white,
                    value: selectedFiliere,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFiliere = newValue;
                        selectedFiliereId = filieres.indexOf(newValue!);
                        loadStudentData(filiereId: selectedFiliereId);
                      });
                    },
                    items:
                    filieres.map<DropdownMenuItem<String>>((String value) {
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
                ),
              ],
            ),
            const SizedBox(height: 26),
            Text(
              '${studentItems.length} Total des étudiants',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 28,
                fontFamily: 'Sarala',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 26),
            Text(
              S.of(context).student_list,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontFamily: 'Sarala',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 26),
            Expanded(
              child: Container(
                width: double.infinity,
                padding:const  EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: studentItems.isEmpty
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/File searching-cuate.png',
                              width: MediaQuery.of(context).size.width / 2,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              S.of(context).no_students,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 26,
                                fontFamily: 'Sarala',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              S.of(context).add_student_prompt,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 26,
                                fontFamily: 'Sarala',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        scrollDirection: Axis.vertical,
                        itemCount: studentItems.length,
                        itemBuilder: (context, index) {
                          final studentItem = studentItems[index];
                          return GestureDetector(
                            onTap: () {
                              // Handle onTap event
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 2, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                                        color: TColors.firstcolor,
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
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            S.of(context).massar_of(
                                                studentItem.massarId),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            S.of(context).major_of(studentItem
                                                .filierid
                                                .toString()),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 50,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
