import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/admin/notificaton/notification_page.dart';
import 'package:attendance_appschool/features/admin/widgets/app_drawer.dart';
import 'package:attendance_appschool/features/admin/widgets/notification_icon.dart';
import 'package:attendance_appschool/models/EtudianteItem.dart';
import 'package:attendance_appschool/provider/AuthenticationProvider.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<HomePageScreen> {
  late DBHelper dbHelper;
  late Future<List<Map<String, dynamic>>> attendanceHistoryFuture;
  late List<EtudianteItem> studentItems = [];
  int _countenseignant = 0;
  int _countabsence = 0;
  int _countetudiants = 0;




  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    attendanceHistoryFuture = _loadAttendanceHistory();
    loadStudentDataWithMoreThanFourAbsences();
    fetchDatacountabsence();
    fetchDatacountenseignant();
    fetchDatacountetudiants();
  }
  Future<void> fetchDatacountabsence() async {
    int count = await dbHelper.countAbsencesInCurrentMonth();
    setState(() {
      _countabsence = count;
    });
  }
  Future<void> fetchDatacountetudiants() async {
    int count = await dbHelper.countEtudiants();
    setState(() {
      _countetudiants = count;
    });
  }
  Future<void> fetchDatacountenseignant() async {
    int count = await dbHelper.countEnseignant();
    setState(() {
      _countenseignant = count;
    });
  }

  void loadStudentDataWithMoreThanFourAbsences() async {
    List<Map<String, dynamic>>? students;
      students = await dbHelper.getStudentsWithMoreThanFourAbsences();

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
          dateofbirth: dateofbirth
        ));
      } else {
        print('Invalid student map: $studentMap');
      }
    }

    setState(() {
      studentItems = loadedEtudianteItems;
    });
    }

  Future<List<Map<String, dynamic>>> _loadAttendanceHistory() async {
    return dbHelper.getAllAttendanceHistory();
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final fonctionnaireName = authProvider.authenticatedFonctionnaire?.nom ?? 'Fonctionnaire';
    final fonctionnairePrenom = authProvider.authenticatedFonctionnaire?.prenom ?? 'Fonctionnaire';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/logoestm_digital.svg',
          height: 50,
        ),
        actions: [
          TNotificationIcon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>const NotificationScreenFonction()
                  ));
            },
          )
        ],
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
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bonjour',
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: 'Sarala',
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    Text(
                      "$fonctionnaireName $fonctionnairePrenom",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 38,
                        fontFamily: 'Sarala',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'dans espace fonctionnaire',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontFamily: 'Sarala',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(9),
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
                      '$_countenseignant',
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
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(9),
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
                                    Icons.group,
                                    color: TColors.firstcolor,
                                    size: 40,
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(width: 16),
                        const Text(
                          "Total des étudiants",
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                      '$_countetudiants',
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
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(9),
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
                                    Icons.person_off_outlined,
                                    color: TColors.firstcolor,
                                    size: 40,
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(width: 16),
                        const Text(
                          "Total des absences ce mois-ci",
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                      '$_countabsence',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 70,
                        fontFamily: 'Sarala',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const Text("Les étudiantes qui dépassent 4 absences",style: TextStyle(fontSize: 38,fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                width: double.infinity,
                height: 500,
                child: studentItems.isEmpty
                    ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/File searching-cuate.png',
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.cover,
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
                    ],
                  ),
                )
                    :ListView.separated(
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
            ],
          ),
        ),
      ),

    );
  }
}
