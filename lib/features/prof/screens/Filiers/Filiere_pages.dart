import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/admin/widgets/notification_icon.dart';
import 'package:attendance_appschool/features/prof/screens/Filiers/student_list_page.dart';
import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/models/FiliereItem.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../provider/AuthenticationProvider.dart';
import '../notification/notification_page.dart';
import '../widgets/app_drawer.dart';

class EspaceFiliereProf extends StatefulWidget {
  const EspaceFiliereProf({super.key});

  @override
  State<EspaceFiliereProf> createState() => _Espace_FiliereState();
}

class _Espace_FiliereState extends State<EspaceFiliereProf> {
  late DBHelper dbHelper;
  late List<FiliereItem> filiereItems = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
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
    final Enseignantid =
        authProvider.authenticatedEnseignant?.id ?? 0;
    loadData(Enseignantid);
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
                      builder: (context) => const EnseignantNotificationScreen()
                  ));
            },
          )
        ],
        title: SvgPicture.asset(
          'assets/logoestk_digital.svg',
          height: 50,
        ),
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
        backgroundColor: TColors.white,
      ),
      drawer: const AppDrawerProf(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Les Filières que vous enseignez",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFA5A9AC)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: filiereItems.isEmpty
                    ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Search-rafiki 1.png',
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 2,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        S
                            .of(context)
                            .no_major,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 30,
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
                  separatorBuilder: (context, index) =>
                  const SizedBox(
                      height: 16),
                  // Adjust the height as needed
                  scrollDirection: Axis.vertical,
                  itemCount: filiereItems.length,
                  itemBuilder: (context, index) {
                    final filiereItem = filiereItems[index];
                    return filierCard(filiereItem: filiereItem);
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
