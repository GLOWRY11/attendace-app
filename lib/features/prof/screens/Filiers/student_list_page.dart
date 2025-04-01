import 'package:attendance_appschool/features/prof/screens/Filiers/student_details.dart';
import 'package:attendance_appschool/models/EtudianteItem.dart';
import 'package:attendance_appschool/models/FiliereItem.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../data/sqflite/DBHelper.dart';

class StudentListPageProf extends StatefulWidget {
  const StudentListPageProf({super.key, required this.filiereItem});
  final FiliereItem filiereItem;

  @override
  State<StudentListPageProf> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPageProf> {

  late DBHelper dbHelper;
  late List<EtudianteItem> studentItems = [];
  late TextEditingController nomfilterController;
  String? selectedSexe = "Sélectionner le sexe";


  List<EtudianteItem> filteredEtudiants = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadStudentData(widget.filiereItem.id);

    nomfilterController = TextEditingController();

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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Détails de la filière",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
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
                            "Titre de la Séance",
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
                SizedBox(
                  height: 1000,
                  child: Container(
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
                    child: studentItems.isEmpty
                        ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 20),
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
                                                    ShowStudentEnseignatDetails(
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
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            )),
      ),
    );
  }


}
