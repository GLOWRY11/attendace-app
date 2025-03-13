import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/provider/AuthenticationProvider.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/FiliereItem.dart';
import '../Filiers/student_list_page.dart';
import '../notification/notification_page.dart';
import '../widgets/app_drawer.dart';
import '../widgets/notification_icon.dart';

class HomePageScreenProf extends StatefulWidget {
  const HomePageScreenProf({super.key});

  @override
  State<HomePageScreenProf> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<HomePageScreenProf> {
  late DBHelper dbHelper;
  late Future<List<Map<String, dynamic>>> attendanceHistoryFuture;
  late List<FiliereItem> filiereItems = [];
  int _countabsence = 0;




  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }
  Future<void> fetchDatacountetudiants(int id) async {
    int count = await dbHelper.countAttendanceHistoryByEnseignant(id);
    setState(() {
      _countabsence = count;
    });
  }

  void loadData(int enseignantId) async {
    List<Map<String, dynamic>>? filiere = await dbHelper.getFilieresForEnseignant(enseignantId);
    List<FiliereItem> loadedFiliereItems = [];
    for (var filiereMap in filiere) {
      if (filiereMap.containsKey(DBHelper.FILIER_ID) &&
          filiereMap.containsKey(DBHelper.FILIER_NAME) &&
          filiereMap.containsKey(DBHelper.SEMESTRE_NAME) &&
          filiereMap.containsKey(DBHelper.FILIER_Annee)) {
        int id = filiereMap[DBHelper.FILIER_ID] ?? 0;
        String filiername = filiereMap[DBHelper.FILIER_NAME] ?? '';
        String semestrename = filiereMap[DBHelper.SEMESTRE_NAME] ?? '';
        String filierannee = filiereMap[DBHelper.FILIER_Annee] ?? '';
        loadedFiliereItems.add(FiliereItem(
            id: id,
            filier_name: filiername,
            semestre_name: semestrename,
            filier_annee: filierannee));
      } else {
        print('Invalid class map: $filiereMap');
      }
    }
    setState(() {
      filiereItems = loadedFiliereItems;
    });
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final Enseignantnom =
        authProvider.authenticatedEnseignant?.nom ?? 'Enseignant';
    final EnseignantPrenom =
        authProvider.authenticatedEnseignant?.prenom ?? 'Enseignant';
    final Enseignantid =
        authProvider.authenticatedEnseignant?.id ?? 0;
    loadData(Enseignantid);
    fetchDatacountetudiants(Enseignantid);
      return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: SvgPicture.asset(
          'assets/logoestk_digital.svg',
          height: 50,
        ),
        actions: [
          TNotificationIconProf(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>const EnseignantNotificationScreen()
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
      drawer: const AppDrawerProf(),
      body:Padding(
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
                    "$Enseignantnom $EnseignantPrenom",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 38,
                      fontFamily: 'Sarala',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'dans espace Enseignant',
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
                                  Icons.group_off_outlined,
                                  color: TColors.firstcolor,
                                  size: 40,
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(width: 16),
                      const Text(
                        "Total des enregistrements de présence",
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
            const Text("Vos Filières",style: TextStyle(fontSize: 38,fontWeight: FontWeight.bold),),
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
              child: filiereItems.isEmpty
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
                    const Text(
                      "Aucune Filières",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 26,
                        fontFamily: 'Sarala',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              )
                  :Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) =>
                                        const SizedBox(height: 16),
                                        scrollDirection: Axis.vertical,
                                        itemCount: filiereItems.length,
                                        itemBuilder: (context, index) {
                        final filiereItem = filiereItems[index];
                        return filierCard(filiereItem: filiereItem);
                                        },
                                      ),
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),

    );
  }
}
class filierCard extends StatelessWidget {
  const filierCard({
    super.key,
    required this.filiereItem,
  });

  final FiliereItem filiereItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentListPageProf(
                filiereItem: filiereItem,
              ),
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: Colors.grey),
              borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filiereItem.filier_name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  S
                      .of(context)
                      .semester_of(filiereItem.semestre_name.toString()),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  S
                      .of(context)
                      .school_year_of(filiereItem.filier_annee.toString()),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
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
  }
}
