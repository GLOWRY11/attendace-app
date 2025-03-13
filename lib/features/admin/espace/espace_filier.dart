import 'package:attendance_appschool/data/sqflite/DBHelper.dart';
import 'package:attendance_appschool/features/admin/espace/student_list_page.dart';
import 'package:attendance_appschool/features/admin/notificaton/notification_page.dart';
import 'package:attendance_appschool/features/admin/widgets/app_drawer.dart';
import 'package:attendance_appschool/features/admin/widgets/notification_icon.dart';
import 'package:attendance_appschool/generated/l10n.dart';
import 'package:attendance_appschool/models/FiliereItem.dart';
import 'package:attendance_appschool/util/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EspaceFiliere extends StatefulWidget {
  const EspaceFiliere({super.key});

  @override
  State<EspaceFiliere> createState() => _Espace_FiliereState();
}

class _Espace_FiliereState extends State<EspaceFiliere> {
  final _formKey = GlobalKey<FormState>();
  late DBHelper dbHelper;
  late List<FiliereItem> filiereItems = [];
  String? selectedSemestre = "Sélectionner le semestre";
  String? selectedAnnee = "Sélectionner l'année scolaire";
  late TextEditingController filiernameController;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
    filiernameController = TextEditingController();
  }

  void loadData() async {
    List<Map<String, dynamic>>? filiere = await dbHelper.getAllFiliers();
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

  void removeFilier(int filiereId) async {
    setState(() {
      filiereItems.removeWhere((filier) => filier.id == filiereId);
    });
    await dbHelper.deleteFilier(filiereId);
  }

  void _showDeleteConfirmationDialog(int filiereId) {
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
                removeFilier(filiereId);
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
      drawer: const AppDrawer(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Espace Filières",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      _showAddFilierDialog();
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
                    child: Row(
                      children: [
                        const Icon(
                          Icons.group_add_outlined,
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
                    )),
              ],
            ),
            const SizedBox(
              height: 26,
            ),
            Text(
              '${filiereItems.length} Total des filières',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 28,
                fontFamily: 'Sarala',
                fontWeight: FontWeight.w500,
                height: 0,
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
                              width: MediaQuery.of(context).size.width / 2,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              S.of(context).no_major,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 30,
                                fontFamily: 'Sarala',
                                fontWeight: FontWeight.normal,
                                height: 0,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              S.of(context).add_major_prompt,
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
                        separatorBuilder: (context, index) => const SizedBox(
                            height: 16), // Adjust the height as needed
                        scrollDirection: Axis.vertical,
                        itemCount: filiereItems.length,
                        itemBuilder: (context, index) {
                          final filiereItem = filiereItems[index];
                          return Container(
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
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
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
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => StudentListPage(
                                                    filiereItem: filiereItem,
                                                  ),
                                                ));
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
                                                filiereItem.id);
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            size: 50,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                              )
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

  void _showAddFilierDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          backgroundColor: Colors.white,
          title: Text(
            S.of(context).add_major,
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
                  const SizedBox(height: 36),
                  TextFormField(
                    style: const TextStyle(fontSize: 24),
                    controller: filiernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFA5A9AC)),
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
                      hintStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey),
                      prefixIconColor: Colors.grey,
                      floatingLabelStyle: const TextStyle().copyWith(
                          fontSize: 24, color: Colors.grey.withOpacity(0.8)),
                      prefixIcon: const Icon(Icons.class_outlined),
                      labelText: S.of(context).major_name,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).major_name_prompt;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 36),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFA5A9AC)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: TColors.firstcolor),
                      ),
                    ),
                    iconSize: 40,
                    isExpanded: true,
                    iconEnabledColor: TColors.firstcolor,
                    value: selectedSemestre,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSemestre = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: "Sélectionner le semestre",
                        child: Text(S.of(context).select_semester,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                      const DropdownMenuItem<String>(
                        value: "Semestre 1",
                        child: Text("Semestre 1",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                      const DropdownMenuItem<String>(
                        value: "Semestre 2",
                        child: Text("Semestre 2",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                      const DropdownMenuItem<String>(
                        value: "Semestre 3",
                        child: Text("Semestre 3",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                      const DropdownMenuItem<String>(
                        value: "Semestre 4",
                        child: Text("Semestre 4",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                    ],
                    validator: (value) {
                      if (value == "Sélectionner le semestre") {
                        return S.of(context).select_semester_prompt;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 36),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: TColors.firstcolor),
                      ),
                    ),
                    iconSize: 40,
                    isExpanded: true,
                    iconEnabledColor: TColors.firstcolor,
                    value: selectedAnnee,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAnnee = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: "Sélectionner l'année scolaire",
                        child: Text(S.of(context).select_school_year,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                      const DropdownMenuItem<String>(
                        value: "2024/2025",
                        child: Text("2024/2025",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                    ],
                    validator: (value) {
                      if (value == "Sélectionner l'année scolaire") {
                        return S.of(context).select_school_year_prompt;
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
                if (_formKey.currentState?.validate() ?? false) {
                  addFilier(
                    filiernameController.text,
                    selectedSemestre,
                    selectedAnnee,
                  );
                  Navigator.pop(context);
                  filiernameController.clear();
                  setState(() {
                    selectedAnnee = "Sélectionner l'année scolaire";
                    selectedSemestre = "Sélectionner le semestre";
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


  void addFilier(String filiername, String? semestre, String? annee) async {
    if (filiername.isNotEmpty &&
        semestre != "Sélectionner le semestre" &&
        annee != "Sélectionner l'année scolaire") {
      int? id = await dbHelper.addFilier(filiername, semestre, annee);
      FiliereItem filiereItem = FiliereItem(
          id: id,
          filier_name: filiername,
          semestre_name: semestre,
          filier_annee: annee);
      setState(() {
        filiereItems.add(filiereItem);
      });
    } else {
      showToast(S.of(context).fill_all_fields);
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
}



